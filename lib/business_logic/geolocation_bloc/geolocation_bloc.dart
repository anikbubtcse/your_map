import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:your_map/api/api.dart';
import 'package:your_map/model/address_model.dart';
import 'package:your_map/utils/internet_checker.dart';

part 'geolocation_event.dart';

part 'geolocation_state.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  GeolocationBloc() : super(GeolocationInitial()) {
    on<GeolocationEventAddress>(_onGeolocationEventAddress);
  }

  FutureOr<void> _onGeolocationEventAddress(
      GeolocationEventAddress event, Emitter<GeolocationState> emit) async {
    if (!await InternetInfo().getInternetConnection) {
      emit(const GeolocationNoInternet(
          errorMessage:
              'Internet access is required. Please go back and check your internet connection.'));

      return;
    }
    emit(GeolocationLoading());

    final response = await http.get(
      API.getGeoAddress(latLng: event.latLng),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final addressModel = AddressModel.fromJson(jsonDecode(response.body));

      emit(GeolocationAddressLoaded(addressModel: addressModel));
      return;
    }

    if (response.statusCode == 401) {
      emit(const GeolocationTokenInvalid(
          errorMessage: 'Api token invalid. Go back and try again later.'));
      return;
    }
    if (response.statusCode == 400 ||
        response.statusCode == 402 ||
        response.statusCode == 429) {
      emit(const GeolocationServerError(
          errorMessage: 'Something went wrong. Go back and try again later.'));
      return;
    }
  }
}

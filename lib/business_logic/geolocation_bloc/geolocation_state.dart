part of 'geolocation_bloc.dart';

sealed class GeolocationState extends Equatable {
  const GeolocationState();
}

final class GeolocationInitial extends GeolocationState {
  @override
  List<Object> get props => [];
}

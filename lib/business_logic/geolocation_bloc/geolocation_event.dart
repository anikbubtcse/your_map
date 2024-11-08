part of 'geolocation_bloc.dart';

sealed class GeolocationEvent extends Equatable {
  const GeolocationEvent();
}

class GeolocationEventAddress extends GeolocationEvent {
  const GeolocationEventAddress({required this.latLng});

  final LatLng latLng;

  @override
  List<Object?> get props => [latLng];
}

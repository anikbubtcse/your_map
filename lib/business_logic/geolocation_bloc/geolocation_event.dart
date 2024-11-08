part of 'geolocation_bloc.dart';

sealed class GeolocationEvent extends Equatable {
  const GeolocationEvent();
}

class GeolocationEventAddress extends GeolocationEvent {
  @override
  List<Object?> get props => [];
}

part of 'geolocation_bloc.dart';

sealed class GeolocationState extends Equatable {
  const GeolocationState();
}

final class GeolocationInitial extends GeolocationState {
  @override
  List<Object> get props => [];
}

final class GeolocationLoading extends GeolocationState {
  @override
  List<Object> get props => [];
}

final class GeolocationNoInternet extends GeolocationState {
  @override
  List<Object> get props => [];
}

final class GeolocationServerError extends GeolocationState {
  @override
  List<Object> get props => [];
}

final class GeolocationTokenInvalid extends GeolocationState {
  @override
  List<Object> get props => [];
}

final class GeolocationAddressLoaded extends GeolocationState {
  final AddressModel addressModel;

  const GeolocationAddressLoaded({required this.addressModel});

  @override
  List<Object> get props => [addressModel];
}

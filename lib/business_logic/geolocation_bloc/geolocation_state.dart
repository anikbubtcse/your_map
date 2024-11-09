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
  const GeolocationNoInternet({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

final class GeolocationServerError extends GeolocationState {
  const GeolocationServerError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

final class GeolocationTokenInvalid extends GeolocationState {
  const GeolocationTokenInvalid({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

final class GeolocationAddressLoaded extends GeolocationState {
  final AddressModel addressModel;

  const GeolocationAddressLoaded({required this.addressModel});

  @override
  List<Object> get props => [addressModel];
}

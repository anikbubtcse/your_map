import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetInfo {
  final InternetConnectionChecker connectionChecker =
      InternetConnectionChecker();

  Future<bool> get getInternetConnection async =>
      await connectionChecker.hasConnection;
}

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:your_map/exception/exception.dart';
import 'package:your_map/utils/internet_checker.dart';

class PermissionChecker {
  static Future<LatLng> requestPermission(
      {required Permission permission, required BuildContext context}) async {
    final status = permission.request();

    if (await status.isDenied) {
      throw PermissionException();
    } else if (await status.isGranted) {
      if (await InternetInfo().getInternetConnection) {
        Location location = Location();

        final LocationData locationData = await location.getLocation();
        final latLng = LatLng(locationData.latitude!, locationData.longitude!);
        return latLng;
      } else {
        throw InternetConnectionException();
      }
    } else {
      throw PermissionException();
    }
  }
}

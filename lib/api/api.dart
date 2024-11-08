import 'package:google_maps_flutter/google_maps_flutter.dart';

class API {
  static Uri getGeoAddress({required LatLng latLng}) {
    return Uri.parse(
        'https://barikoi.xyz/v2/api/search/reverse/geocode?api_key=bkoi_70fd53edab706d18be398cd088f621deef1b4998f9ee7f13b6bff6f01af185f9&longitude=${latLng.longitude}&latitude=${latLng.latitude}');
  }
}

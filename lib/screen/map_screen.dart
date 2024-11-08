import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:your_map/exception/exception.dart';
import 'package:your_map/utils/alert_dialog.dart';
import 'package:your_map/utils/permission_checker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition? currentPosition;
  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();

    getLocationPermission();
  }

  getLocationPermission() async {
    try {
      final latLng = await PermissionChecker.requestPermission(
          permission: Permission.location, context: context);

      setState(() {
        currentPosition = CameraPosition(target: latLng, zoom: 14.4746);
      });
    } on PermissionException {
      MapAlertDialog.showAlertDialog(
          dialogName:
              'You must provide the permission. Please go back and give the location permission.',
          context: context);
    } on InternetConnectionException {
      MapAlertDialog.showAlertDialog(
          dialogName:
              'You must need internet. Please go back and check your internet connection.',
          context: context);
    } catch (e) {
      MapAlertDialog.showAlertDialog(
          dialogName:
              'Something went wrong. Please go back and open the app again.',
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFD2E9FF),
        title: Text(
          'Your Map',
          style: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: currentPosition!,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onTap: (LatLng latLng) {},
                    markers: markers,
                  ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
    );
  }
}

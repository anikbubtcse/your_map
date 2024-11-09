import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:your_map/exception/exception.dart';
import 'package:your_map/utils/alert_dialog.dart';
import 'package:your_map/utils/permission_checker.dart';

import '../business_logic/geolocation_bloc/geolocation_bloc.dart';

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
  String? address;
  LatLng? selectedLatLng;

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
    return LoaderOverlay(
      overlayColor: const Color(0x80808080),
      child: Scaffold(
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
            BlocConsumer<GeolocationBloc, GeolocationState>(
                listener: (context, geoState) {
              if (geoState is GeolocationServerError) {
                context.loaderOverlay.hide();
                MapAlertDialog.showAlertDialog(
                    dialogName: geoState.errorMessage, context: context);
              }

              if (geoState is GeolocationTokenInvalid) {
                context.loaderOverlay.hide();
                MapAlertDialog.showAlertDialog(
                    dialogName: geoState.errorMessage, context: context);
              }

              if (geoState is GeolocationNoInternet) {
                context.loaderOverlay.hide();
                MapAlertDialog.showAlertDialog(
                    dialogName: geoState.errorMessage, context: context);
              }

              if (geoState is GeolocationAddressLoaded &&
                  selectedLatLng != null) {
                context.loaderOverlay.hide();

                setState(() {
                  address = geoState.addressModel.place.address;
                  markers.clear();
                  markers.add(Marker(
                    markerId: MarkerId(selectedLatLng.toString()),
                    position: selectedLatLng!,
                    infoWindow: InfoWindow(title: address),
                  ));
                });
              }
            }, builder: (context, geoState) {
              if (geoState is GeolocationLoading) {
                context.loaderOverlay.show(
                    widgetBuilder: (_) => const Center(
                          child: SpinKitDoubleBounce(
                            color: Colors.white,
                            size: 60.0,
                          ),
                        ));
              }

              return Expanded(
                child: currentPosition == null
                    ? const Center(
                        child: SpinKitDoubleBounce(
                          color: Colors.black,
                          size: 60.0,
                        ),
                      )
                    : GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: currentPosition!,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        onTap: (LatLng latLng) async {
                          selectedLatLng = latLng;

                          context
                              .read<GeolocationBloc>()
                              .add(GeolocationEventAddress(latLng: latLng));

                          final GoogleMapController controller =
                              await _controller.future;

                          setState(() {
                            currentPosition = CameraPosition(
                                target:
                                    LatLng(latLng.latitude, latLng.longitude),
                                zoom: 14.4746);
                          });
                          await controller.animateCamera(
                              CameraUpdate.newCameraPosition(currentPosition!));

                          setState(() {
                            markers.clear();
                            markers.add(Marker(
                              markerId: MarkerId(latLng.toString()),
                              position: latLng,
                              infoWindow: InfoWindow(title: address),
                            ));
                          });
                        },
                        markers: markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

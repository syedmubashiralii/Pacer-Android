import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pacer/Src/Domain/Controllers/HomeController.dart';
import 'package:pacer/Src/Domain/Model/PlaceModel.dart';
import 'package:pacer/Src/Utils/Constants.dart';

import '../../Utils/Functions.dart';
import '../Model/TrackModel.dart';

String trackfilename = "track";

class TrackController extends GetxController {
  Rx<MapType> mapType = MapType.normal.obs;
  late StreamSubscription<Position> positionSubscription;

  HomeController homecontroller = Get.find();

  Position? lastPosition;
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  RxString locationaddress = "".obs;
  RxString locationname = "".obs;

  RxList<TrackModel> tracklist = <TrackModel>[].obs;
  final List<LatLng> _points = [];
  double currentZoomLevel = 15.0;

  RxList<PlaceModel> storedplacesjson = <PlaceModel>[].obs;
  RxBool ispickershown = false.obs;
  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  List buttonitems = [
    {
      "icon": Icons.layers_rounded,
    },
    {"icon": Icons.add_location_outlined},
    {"icon": Icons.my_location},
    {"icon": Icons.add},
    {"icon": Icons.remove}
  ];

  void startListening() {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      positionSubscription =
          Geolocator.getPositionStream().listen((Position position) async {
        // try {
        //   if (mapController != null) {
        //     mapController!
        //         .getZoomLevel()
        //         .then((value) => currentZoomLevel = value);
        //     dlog("zoom", currentZoomLevel.toString());
        //   }
        // } catch (e) {
        //   dlog("zoom", e.toString());
        // }

        lastPosition = position;
        if (mapController != null) {
          addmarker(LatLng(position.latitude, position.longitude),
              "Current Location", null);
          _points.add(LatLng(position.latitude, position.longitude));
          drawPolyline(position.latitude, position.longitude, 3);
          if (ispickershown.value != true) {
            WidgetsBinding.instance.addPostFrameCallback((_) =>
                mapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: currentZoomLevel,
                    // bearing: position.heading,
                  ),
                )));

            addTrackData(position);

            placemarkFromCoordinates(position.latitude, position.longitude)
                .then((value) {
              locationaddress.value =
                  "${value.first.street},  ${value.first.administrativeArea},${value.first.subLocality},${value.first.locality}";
              locationname.value = value.first.street!;
            });
          }
        }
      });
    } catch (e) {
      dlog("Locationstream exception", e.toString());
    }
  }

  void addTrackData(Position position) {
    if (homecontroller.trackingenumval.value == TrackingEnum.tracking) {
      tracklist.add(TrackModel(
          timestamp: DateTime.now().toString(),
          floor: position.floor ?? 0,
          accuracy: position.accuracy,
          steps: homecontroller.tracksteps.value,
          altitude: position.altitude,
          heading: position.heading,
          isMocked: position.isMocked,
          location: DateTime.now().toString(),
          latitude: position.latitude,
          longitude: position.longitude,
          speed: position.speed,
          speedAccuracy: position.speedAccuracy,
          distance: homecontroller.trackdistance.value,
          calories: homecontroller.trackcalories.value,
          duration: homecontroller.trackstoredDuration.value));

      saveTrackInFile(tracklist, trackfilename);
    }
  }

  void drawPolyline(
    double latitude,
    double longitude,
    int width,
  ) {
    Polyline polyline = Polyline(
        polylineId: PolylineId('polyline$latitude$longitude'),
        color: AppColors.backgroundcolor,
        width: width,
        points: _points);

    polylines.add(polyline);
  }

  changepickervalue(bool val) {
    ispickershown.value = val;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    dlog("title", "value");
    startListening();
    getdatafromfile().then((value) {
      storedplacesjson.value = value;
      addplaces();
    });
  } 

  @override
  void dispose() {
    super.dispose();
    if (mapController != null) {
      mapController!.dispose();
    }
  }

  @override
  void onClose() {
    positionSubscription.cancel();
    super.onClose();
  }

  addplaces() async {
    try {
      for (var item in storedplacesjson) {
        var marker =
            await getBytesFromAsset(geticonfromcategory(item.category), 70);
        addmarker(
          LatLng(item.latitude, item.longitude),
          item.placeName,
          BitmapDescriptor.fromBytes(marker),
        );
      }
    } catch (e) {
      dlog("", e.toString());
    }
  }

  addmarker(LatLng position, String id, BitmapDescriptor? bitmap) async {
    markers.add(Marker(
      markerId: MarkerId(id),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(
        title: id,
      ),
      icon: bitmap ?? BitmapDescriptor.defaultMarker,
    ));

    update();
  }

  void zoomin() {
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.zoomIn());
    }
  }

  void zoomout() {
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.zoomOut());
    }
  }

  void recenterMap() {
    if (mapController != null && lastPosition != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(
          LatLng(lastPosition!.latitude, lastPosition!.longitude)));
    }
  }

  ////
  ///
  ///
  void changeMapType(MapType newType) {
    mapType.value = newType;
    update();
    Get.back(); // Close the dialog after selecting a map type
  }
}

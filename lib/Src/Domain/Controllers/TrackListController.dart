import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pacer/Src/Domain/Model/TrackModel.dart';

import '../../Utils/Constants.dart';
import '../../Utils/Functions.dart';

class TrackListController extends GetxController {
  RxBool isloading = false.obs;

  List<TrackModel> selecteditem = [];
  String startloc = "";
  String endloc = "";
  Uint8List? marker;

  List tracklist = [];
  RxList<File> files = <File>[].obs;

  //trackdetail variables
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  RxDouble currentZoomLevel = 14.0.obs;
  LatLng startLocation = const LatLng(33.6844, 73.0479);
  RxDouble totalSpeed = 0.0.obs;
  RxDouble distancecovered = 0.0.obs;
  RxDouble averageSpeed = 0.0.obs;
  RxInt index = 0.obs;
  RxInt lastindex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    customMarker();
    loadTracks();
  }

  customMarker() async {
    marker = await getBytesFromAsset(AppImages.dotimg, 50);
  }

  loadTracks() async {
    isloading.value = true;
    tracklist = [];
    files.value = [];
    files.value = await loadFilesFromFolder();
    for (int i = 0; i < files.length; i++) {
      List<TrackModel> filedata = await getTrackfromFile(files[i].path);
      dlog("", filedata[0].timestamp);
      tracklist.add({"$i": filedata});
    }
    isloading.value = false;
    // dlog(tracklist[0]["0"][0]);
  }

  setDetailscreendata() async {
    isloading.value = true;

    startLocation = LatLng(selecteditem[0].latitude, selecteditem[0].longitude);
    addmarker(LatLng(selecteditem[0].latitude, selecteditem[0].longitude),
            "Starting Point", startloc, BitmapDescriptor.defaultMarker)
        .then((value) => null);
    addmarker(
      LatLng(selecteditem.last.latitude, selecteditem.last.longitude),
      "Ending Point",
      endloc,
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ).then((value) => null);

    for (int i = 0; i < selecteditem.length; i++) {
      totalSpeed.value += selecteditem[i].speed * 3.6;
    }
    lastindex.value = selecteditem.length;
    averageSpeed.value = totalSpeed / selecteditem.length;
    dlog("", averageSpeed);

    distancecovered.value = await calculateDistance(
      selecteditem[0].latitude,
      selecteditem[0].longitude,
      selecteditem.last.latitude,
      selecteditem.last.longitude,
    );

    for (int i = 0; i < selecteditem.length; i++) {
      if (i != 0 && i != selecteditem.length - 1) {
        LatLng startPoint =
            LatLng(selecteditem[i - 1].latitude, selecteditem[i - 1].longitude);
        LatLng endPoint =
            LatLng(selecteditem[i].latitude, selecteditem[i].longitude);

        addPolyline(startPoint, endPoint);
        addmarker(
          LatLng(selecteditem[i].latitude, selecteditem[i].longitude),
          "Speed: ${selecteditem[i].speed.toString()}",
          selecteditem[i].timestamp.toString(),
          marker == null
              ? BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta)
              : BitmapDescriptor.fromBytes(marker!),
        );
      }
    }

    isloading.value = false;
  }

  Future addmarker(LatLng position, String loc, String snip,
      BitmapDescriptor descriptor) async {
    markers.add(Marker(
      markerId: MarkerId(loc),
      position:
          //  loc == "Starting Point"?
          LatLng(position.latitude, position.longitude),
      // : const LatLng(33.6844, 73.0479),
      infoWindow: InfoWindow(title: loc.toString(), snippet: snip),
      icon: descriptor,
    ));
  }

  void addPolyline(LatLng startLatLng, LatLng endLatLng) {
    PolylineId polylineId = PolylineId(startLatLng.toString());

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      color: AppColors.black,
      width: 2,
      points: [startLatLng, endLatLng],
    );
    polylines[polylineId] = polyline;
  }
}

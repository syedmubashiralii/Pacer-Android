import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../Domain/Controllers/TrackListController.dart';
import '../../../Utils/Constants.dart';
import '../../../Utils/Widgets.dart';

class TrackDetailScreen extends StatefulWidget {
  static const String route = "track_map_sceen";
  const TrackDetailScreen({super.key});

  @override
  State<TrackDetailScreen> createState() => _TrackDetailScreenState();
}

class _TrackDetailScreenState extends State<TrackDetailScreen> {
  TrackListController trackListController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      trackListController.setDetailscreendata();
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.backgroundcolor,
      child: SafeArea(
        child: Scaffold(
          body: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppImages.homebgimg),
                      fit: BoxFit.fill)),
              child: Obx(() {
                return trackListController.isloading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                        children: [
                          GoogleMap(
                            myLocationEnabled: false,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: trackListController.startLocation,
                              zoom: trackListController.currentZoomLevel.value,
                            ),
                            polylines: Set<Polyline>.of(
                                trackListController.polylines.values),
                            markers:
                                Set<Marker>.of(trackListController.markers),
                            mapType: MapType.normal,
                            onMapCreated: (controller) {
                              if (mounted) {
                                setState(() {
                                  trackListController.mapController =
                                      controller;
                                });
                              }
                            },
                          ),
                          Positioned(
                            top: 10,
                            left: 0,
                            child: IgnorePointer(
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    color: AppColors.white.withOpacity(.5),
                                    child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Center(
                                                child: Text(
                                              "Track Information",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.black),
                                            )),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Stated At :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  trackListController
                                                      .selecteditem[0].timestamp
                                                      .toString()
                                                      .split(".")[0]
                                                      .replaceAll(
                                                          " ", "    Time: "),
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Closed At :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  trackListController
                                                      .selecteditem
                                                      .last
                                                      .timestamp
                                                      .toString()
                                                      .split(".")[0]
                                                      .replaceAll(
                                                          " ", "    Time: "),
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Duration :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  DateTime.parse(
                                                          trackListController
                                                              .selecteditem
                                                              .last
                                                              .timestamp
                                                              .toString())
                                                      .difference(DateTime.parse(
                                                          trackListController
                                                              .selecteditem[0]
                                                              .timestamp
                                                              .toString()))
                                                      .toString()
                                                      .split(".")[0],
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Average Speed :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${trackListController.averageSpeed.value.toStringAsFixed(2)} km/h",
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Distance Covered :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${trackListController.distancecovered.value.toStringAsFixed(2)} km",
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  )),
                            ),
                          ),

                          ///record of each object
                          Positioned(
                            bottom: 10,
                            left: 0,
                            child: IgnorePointer(
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    color: AppColors.white.withOpacity(.5),
                                    child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  "Time :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  trackListController
                                                      .selecteditem[
                                                          trackListController
                                                              .index.value]
                                                      .timestamp
                                                      .toString()
                                                      .split(".")[0]
                                                      .replaceAll(
                                                          " ", "    Time: "),
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Location :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  trackListController
                                                      .selecteditem[
                                                          trackListController
                                                              .index.value]
                                                      .location
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Longitude :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  trackListController
                                                      .selecteditem[
                                                          trackListController
                                                              .index.value]
                                                      .longitude
                                                      .toStringAsFixed(2)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Latitude :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  trackListController
                                                      .selecteditem[
                                                          trackListController
                                                              .index.value]
                                                      .latitude
                                                      .toStringAsFixed(2)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Altitude :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${(trackListController.selecteditem[trackListController.index.value].altitude * 3.28084).toStringAsFixed(2)} ft",
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            // Row(
                                            //   children: [
                                            //     const Text(
                                            //       "Status :\t\t",
                                            //       style: TextStyle(
                                            //           color: AppColors.black,
                                            //           fontWeight: FontWeight.bold),
                                            //     ),
                                            //     Text(
                                            //       "${distancecovered.toStringAsFixed(2)} km",
                                            //       style: const TextStyle(
                                            //           color: AppColors.black,
                                            //           fontWeight: FontWeight.w400),
                                            //     ),
                                            //   ],
                                            // ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Speed :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${(trackListController.selecteditem[trackListController.index.value].speed * 3.6).toStringAsFixed(2)} km/h",
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),

                                            Row(
                                              children: [
                                                const Text(
                                                  "Distance :\t\t",
                                                  style: TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${trackListController.selecteditem[trackListController.index.value].distance.toStringAsFixed(2)} km",
                                                  style: const TextStyle(
                                                      color: AppColors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  )),
                            ),
                          ),

                          ///
                          ////

                          ///
                          ///
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 8.0, bottom: 100),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // AddPlacesCircleButton(
                                  //   ontap: () {},
                                  //   icon: Icons.share,
                                  // ),
                                  AddPlacesCircleButton(
                                    ontap: () async {
                                      trackListController.mapController!
                                          .animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                      target:
                                                          trackListController
                                                              .startLocation,
                                                      zoom: trackListController
                                                          .currentZoomLevel
                                                          .value)));
                                    },
                                    icon: Icons.my_location,
                                  ),
                                  AddPlacesCircleButton(
                                      ontap: () async {
                                        trackListController
                                                .currentZoomLevel.value =
                                            await trackListController
                                                .mapController!
                                                .getZoomLevel();
                                        trackListController.currentZoomLevel
                                            .value = trackListController
                                                .currentZoomLevel.value +
                                            2;
                                        if (trackListController
                                                .currentZoomLevel.value <
                                            0) {
                                          trackListController
                                              .currentZoomLevel.value = 0;
                                        }
                                        trackListController.mapController!
                                            .animateCamera(
                                          CameraUpdate.newCameraPosition(
                                            CameraPosition(
                                              target: trackListController
                                                  .startLocation,
                                              zoom: trackListController
                                                  .currentZoomLevel.value,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icons.add),
                                  AddPlacesCircleButton(
                                    ontap: () async {
                                      trackListController
                                              .currentZoomLevel.value =
                                          await trackListController
                                              .mapController!
                                              .getZoomLevel();
                                      trackListController.currentZoomLevel
                                          .value = trackListController
                                              .currentZoomLevel.value -
                                          2;
                                      if (trackListController
                                              .currentZoomLevel.value <
                                          0) {
                                        trackListController
                                            .currentZoomLevel.value = 0;
                                      }
                                      trackListController.mapController!
                                          .animateCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            target: trackListController
                                                .startLocation,
                                            zoom: trackListController
                                                .currentZoomLevel.value,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icons.remove,
                                  ),
                                  AddPlacesCircleButton(
                                    ontap: () async {
                                      Navigator.pop(context);
                                    },
                                    icon: Icons.arrow_back,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
              }),
            ),
          ),
          bottomNavigationBar: Container(
            color: AppColors.backgroundcolor,
            height: h * .06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () async {
                      if (trackListController.index.value == 0) {
                        Get.closeAllSnackbars();
                        Get.snackbar("Pacer", "Start Point",
                            colorText: Colors.white,
                            backgroundColor: Colors.red);
                      } else {
                        trackListController.index.value = 0;
                        setState(() {});
                        trackListController.currentZoomLevel.value =
                            await trackListController.mapController!
                                .getZoomLevel();
                        trackListController.mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(
                              trackListController
                                  .selecteditem[trackListController.index.value]
                                  .latitude,
                              trackListController
                                  .selecteditem[trackListController.index.value]
                                  .longitude),
                          zoom: trackListController.currentZoomLevel.value,
                        )));
                      }
                    },
                    icon: const Icon(
                      Icons.fast_rewind,
                      size: 32,
                      color: AppColors.white,
                    )),
                IconButton(
                    onPressed: () async {
                      if (trackListController.index.value == 0) {
                        Get.closeAllSnackbars();
                        Get.snackbar("Pacer", "Start Point",
                            colorText: Colors.white,
                            backgroundColor: Colors.red);
                      } else {
                        trackListController.index.value -= 1;
                        setState(() {});
                        trackListController.currentZoomLevel.value =
                            await trackListController.mapController!
                                .getZoomLevel();
                        trackListController.mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(
                              trackListController
                                  .selecteditem[trackListController.index.value]
                                  .latitude,
                              trackListController
                                  .selecteditem[trackListController.index.value]
                                  .longitude),
                          zoom: trackListController.currentZoomLevel.value,
                        )));
                      }
                    },
                    icon: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationZ(-3.14),
                      child: const RotationTransition(
                        turns: AlwaysStoppedAnimation(1),
                        child: Icon(
                          Icons.play_arrow,
                          size: 32,
                          color: AppColors.white,
                        ),
                      ),
                    )),
                const SizedBox(
                  width: 15,
                ),
                IconButton(
                    onPressed: () async {
                      if (trackListController.index.value ==
                          trackListController.lastindex.value - 1) {
                        Get.closeAllSnackbars();
                        Get.snackbar("Pacer", "Last Point",
                            colorText: Colors.white,
                            backgroundColor: Colors.red);
                      } else {
                        trackListController.index.value += 1;
                        setState(() {});
                        trackListController.currentZoomLevel.value =
                            await trackListController.mapController!
                                .getZoomLevel();
                        trackListController.mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(
                              trackListController
                                  .selecteditem[trackListController.index.value]
                                  .latitude,
                              trackListController
                                  .selecteditem[trackListController.index.value]
                                  .longitude),
                          zoom: trackListController.currentZoomLevel.value,
                        )));
                      }
                    },
                    icon: const Icon(
                      Icons.play_arrow,
                      size: 32,
                      color: AppColors.white,
                    )),
                IconButton(
                    onPressed: () async {
                      if (trackListController.index.value ==
                          trackListController.lastindex.value) {
                        Get.closeAllSnackbars();
                        Get.snackbar("Pacer", "Last Point",
                            colorText: Colors.white,
                            backgroundColor: Colors.red);
                      } else {
                        trackListController.index.value =
                            trackListController.lastindex.value - 1;
                        setState(() {});
                        trackListController.currentZoomLevel.value =
                            await trackListController.mapController!
                                .getZoomLevel();
                        trackListController.mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(
                              trackListController
                                  .selecteditem[trackListController.index.value]
                                  .latitude,
                              trackListController
                                  .selecteditem[trackListController.index.value]
                                  .longitude),
                          zoom: trackListController.currentZoomLevel.value,
                        )));
                      }
                    },
                    icon: const Icon(
                      Icons.fast_forward,
                      size: 32,
                      color: AppColors.white,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

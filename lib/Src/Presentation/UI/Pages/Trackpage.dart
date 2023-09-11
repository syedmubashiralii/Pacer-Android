import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:pacer/Src/Domain/Controllers/TrackController.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../Domain/Controllers/HomeController.dart';
import '../../../Utils/Constants.dart';
import '../../../Utils/Dialogs.dart';
import '../../../Utils/Functions.dart';
import '../../Widgets/TrackWidget.dart';
import '../../Widgets/WeatherWidget.dart';

var uuid = const Uuid();

class Trackpage extends StatefulWidget {
  const Trackpage({super.key});

  @override
  _TrackpageState createState() => _TrackpageState();
}

class _TrackpageState extends State<Trackpage> {
  String walkId = uuid.v1();
  GoogleMapController? mapController;
  final HomeController homecontroller = Get.find();
  TrackController trackcontroller = Get.put(TrackController());
  @override
  void initState() {
    super.initState();
    trackcontroller.changepickervalue(false);
    trackcontroller.polylines.value = {};
    trackcontroller.markers.value = {};
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: height * .55,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GetBuilder<TrackController>(builder: (context) {
                          return Stack(
                            children: [
                              FadeInLeft(
                                child: GoogleMap(
                                  mapType: trackcontroller.mapType.value,
                                  onMapCreated: (controller) {
                                    trackcontroller.mapController = controller;
                                  },
                                  onCameraMove:
                                      (CameraPosition cameraPositiona) {
                                    trackcontroller.cameraPosition =
                                        cameraPositiona;
                                  },
                                  onCameraIdle: () async {
                                    if (trackcontroller.ispickershown.value) {
                                      List<Placemark> placemarks =
                                          await placemarkFromCoordinates(
                                              trackcontroller.cameraPosition!
                                                  .target.latitude,
                                              trackcontroller.cameraPosition!
                                                  .target.longitude);

                                      trackcontroller.locationaddress.value =
                                          "${placemarks.first.street},  ${placemarks.first.administrativeArea}";
                                      trackcontroller.locationname.value =
                                          placemarks.first.street!;
                                    }
                                  },
                                  zoomControlsEnabled: false,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: false,
                                  polylines: trackcontroller.polylines.toSet(),
                                  initialCameraPosition: const CameraPosition(
                                    target: LatLng(33.6844, 73.0479),
                                    zoom: 14.4746,
                                  ),
                                  markers: trackcontroller.markers.toSet(),
                                ),
                              ),
                              ////////////////////////////////////Addplace Widget/////////////////////////////////
                              FadeInLeft(
                                child: AddPlaceWidget(
                                    trackcontroller: trackcontroller,
                                    width: width),
                              ),
                              ////////////////////////////////////////////////////////////////////////////////////
                              Container(
                                alignment: Alignment.topRight,
                                margin: const EdgeInsets.all(12),
                                child: FadeInLeft(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i <
                                              trackcontroller
                                                  .buttonitems.length;
                                          i++) ...[
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            if (i == 0) {
                                              showMapTypeDialog(
                                                  trackcontroller);
                                            } else if (i == 1) {
                                              trackcontroller.changepickervalue(
                                                  !trackcontroller
                                                      .ispickershown.value);
                                            } else if (i == 2) {
                                              trackcontroller.recenterMap();
                                            } else if (i == 3) {
                                              trackcontroller.zoomin();
                                            } else if (i == 4) {
                                              trackcontroller.zoomout();
                                            }
                                          },
                                          child: AnimatedContainer(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6),
                                            duration: const Duration(
                                                milliseconds: 1000),
                                            child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: AppColors
                                                    .colorPrimaryDark
                                                    .withOpacity(.7),
                                                child: Icon(
                                                  trackcontroller.buttonitems[i]
                                                      ["icon"],
                                                  color: AppColors.white,
                                                  size: 26,
                                                )),
                                          ),
                                        )
                                      ]
                                    ],
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  height: height * .1,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.colorPrimaryDark
                                          .withOpacity(.8)),
                                  child: const CompassWidget(),
                                ),
                              ),
                            ],
                          );
                        })),
                  ),
                ),
              ),
              FadeInLeft(
                child: Container(
                    height: height * .07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.colorPrimaryDark.withOpacity(0.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FadeInDown(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                  "210 ${'steps'.tr}",
                                  style:
                                      AppTextStyles.performancepagetextstyle1),
                              Text(
                                textScaleFactor:
                                    ScaleSize.textScaleFactor(context),
                                "${'steps'.tr} ",
                                style: AppTextStyles.performancepagetextstyle,
                              ),
                            ],
                          ),
                        ),
                        FadeInDown(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                  "0.15 km",
                                  style:
                                      AppTextStyles.performancepagetextstyle1),
                              Text(
                                textScaleFactor:
                                    ScaleSize.textScaleFactor(context),
                                "${'distance'.tr} ",
                                style: AppTextStyles.performancepagetextstyle,
                              ),
                            ],
                          ),
                        ),
                        FadeInDown(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                  "8.4 kcal",
                                  style:
                                      AppTextStyles.performancepagetextstyle1),
                              Text(
                                textScaleFactor:
                                    ScaleSize.textScaleFactor(context),
                                'calories'.tr,
                                style: AppTextStyles.performancepagetextstyle,
                              ),
                            ],
                          ),
                        ),
                        FadeInDown(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                  "00:10 hrs",
                                  style:
                                      AppTextStyles.performancepagetextstyle1),
                              Text(
                                textScaleFactor:
                                    ScaleSize.textScaleFactor(context),
                                'duration'.tr,
                                style: AppTextStyles.performancepagetextstyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    if (trackcontroller.mapController != null) {
      trackcontroller.mapController!.dispose();
    }
  }
}

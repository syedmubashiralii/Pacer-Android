import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pacer/Src/Domain/Controllers/TrackListController.dart';
import 'package:pacer/Src/Domain/Model/TrackModel.dart';
import 'package:pacer/Src/Utils/Constants.dart';

import '../../../Utils/Functions.dart';
import 'TrackDetailScreen.dart';

class TrackListScreen extends StatefulWidget {
  const TrackListScreen({super.key});

  @override
  State<TrackListScreen> createState() => _TrackListScreenState();
}

class _TrackListScreenState extends State<TrackListScreen> {
  TrackListController trackListController = Get.put(TrackListController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // loadTracks();
    });
  }

  Future<Map<String, dynamic>> getData(
      double fromlat, double fromlng, double tolat, double tolng) async {
    var placemark1 = "No result";
    var placemark2 = "No result";
    if (await checkInternet()) {
      try {
        var p1 = await getlocfromlatlng(fromlat, fromlng);
        placemark1 = "${p1.name}, ${p1.subLocality}, ${p1.locality}";
        var p2 = await getlocfromlatlng(tolat, tolng);
        placemark2 = "${p2.name}, ${p2.subLocality}, ${p2.locality}";
      } catch (e) {
        placemark1 = "No result";
        placemark2 = "No result";
      }
    }

    return {"from": placemark1, "to": placemark2};
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Container(
      color: AppColors.backgroundcolor,
      child: SafeArea(
        child: Scaffold(
          body: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColors.backgroundcolor,
              title: Text(
                "pasttracks".tr,
                style: const TextStyle(color: AppColors.white),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                  )),
            ),
            body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppImages.homebgimg),
                      fit: BoxFit.fill)),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() {
                  return trackListController.isloading.value
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryLight,
                          ),
                        )
                      : trackListController.tracklist.isEmpty &&
                              trackListController.isloading.value == false
                          ? Center(
                              child: Text(   
                              "nopasttracks".tr,
                              style: AppTextStyles.performancepagetextstyle,
                            ))
                          : ListView.builder(
                              itemCount: trackListController.tracklist.length,
                              itemBuilder: (context, index) {
                                List<TrackModel> item = trackListController
                                    .tracklist[index]["$index"];
                                var firstitem = item.first;
                                var lastitem = item.last;

                                return FutureBuilder(
                                  future: getData(
                                      firstitem.latitude,
                                      firstitem.longitude,
                                      lastitem.latitude,
                                      lastitem.longitude),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text(
                                            '${snapshot.error} occurred',
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        );
                                      } else if (snapshot.hasData) {
                                        final data = snapshot.data as Map;
                                        return InkWell(
                                          onTap: () {
                                            trackListController.selecteditem =
                                                item;
                                            trackListController.startloc =
                                                data["from"];
                                            trackListController.endloc =
                                                data["to"];

                                            Get.to(() =>
                                                const TrackDetailScreen());
                                          },
                                          child: Dismissible(
                                            key:
                                                UniqueKey(), // Use a unique key for each item.
                                            direction: DismissDirection
                                                .endToStart, // Swiping right to dismiss.
                                            onDismissed: (direction) {
                                              log(direction.toString());

                                              trackListController.tracklist
                                                  .removeAt(index);
                                              File(trackListController
                                                      .files[index].path)
                                                  .delete();
                                              trackListController.loadTracks();
                                            },
                                            background: Container(
                                              color: Colors
                                                  .red, // Set the background color for the delete button.
                                              alignment: Alignment.centerRight,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6,
                                                      horizontal: 10),
                                              decoration: const BoxDecoration(
                                                  color: AppColors.transparent,
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: AppColors
                                                              .white))),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Trip Id :\t\t\t\t\t\t",
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Trip_$index",
                                                        style: const TextStyle(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Stated At :\t\t",
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        firstitem.timestamp
                                                            .toString()
                                                            .split(".")[0]
                                                            .replaceAll(" ",
                                                                "    Time: "),
                                                        style: const TextStyle(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Closed At :\t\t",
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        lastitem.timestamp
                                                            .toString()
                                                            .split(".")[0]
                                                            .replaceAll(" ",
                                                                "    Time: "),
                                                        style: const TextStyle(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "From :\t\t\t\t\t\t\t\t\t",
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        data["from"],
                                                        style: const TextStyle(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "To :\t\t\t\t\t\t\t\t\t\t\t\t\t\t",
                                                        style: TextStyle(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        data["to"],
                                                        style: const TextStyle(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }

                                    return const Center(
                                      child: SizedBox.shrink(),
                                    );
                                  },
                                );
                              },
                            );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

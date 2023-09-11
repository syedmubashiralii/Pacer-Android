import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pacer/Src/Utils/Constants.dart';

import '../../Domain/Controllers/TrackController.dart';
import '../../Domain/Model/PlaceModel.dart';
import '../../Utils/Dialogs.dart';
import '../../Utils/Functions.dart';

class AddPlaceWidget extends StatelessWidget {
  const AddPlaceWidget({
    super.key,
    required this.trackcontroller,
    required this.width,
  });

  final TrackController trackcontroller;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: trackcontroller.ispickershown.value,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: AppColors.white,
              child: SizedBox(
                  width: width * .55,
                  child: ListTile(
                    title: Text(
                      trackcontroller.locationname.value,
                      style: const TextStyle(fontSize: 13),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        var cat = await Get.dialog(
                          AddPlacesdialog(
                            cont: trackcontroller,
                          ),
                        );
                        if (cat != null) {
                          var id = DateTime.now().toString();
                          trackcontroller.storedplacesjson.add(
                            PlaceModel(
                              id: id,
                              placeName: trackcontroller.locationname.value,
                              placeAddress:
                                  trackcontroller.locationaddress.value,
                              latitude: trackcontroller
                                  .cameraPosition!.target.latitude,
                              longitude: trackcontroller
                                  .cameraPosition!.target.longitude,
                              category: cat,
                              icon: geticonfromcategory(cat),
                            ),
                          );
                          await saveplacesinfile(
                              trackcontroller.storedplacesjson);
                          await getdatafromfile().then((value) {
                            trackcontroller.storedplacesjson.value = value;
                            trackcontroller.addplaces();
                          });
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    dense: true,
                  )),
            ),
            Image.asset(
              "assets/icons/locationicon.png",
              width: 40,
            ),
          ],
        ),
      ),
    );
  }
}

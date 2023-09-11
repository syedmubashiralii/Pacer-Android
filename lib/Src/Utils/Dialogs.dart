import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pacer/Src/Domain/Controllers/TrackController.dart';

import '../Data/PlacesJson.dart';
import 'Constants.dart';

void showMapTypeDialog(TrackController cont) {
  Get.defaultDialog(
    contentPadding: const EdgeInsets.all(6),
    titlePadding: const EdgeInsets.all(12),
    backgroundColor: AppColors.backgroundcolor,
    title: 'Select Map Type',
    titleStyle: AppTextStyles.appslogantextstyle,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () {
            cont.changeMapType(MapType.normal);
          },
          leading: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: cont.mapType.value == MapType.normal
                    ? AppColors.colorAccent
                    : AppColors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: SizedBox(
                height: 50,
                child: Image.asset(AppImages.defaultmapimg),
              ),
            ),
          ),
          title: const Text(
            "Default Map",
            style: AppTextStyles.historypagetextstyle,
          ),
        ),
        const SizedBox(height: 16.0),
        ListTile(
          onTap: () {
            cont.changeMapType(MapType.satellite);
          },
          leading: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: cont.mapType.value == MapType.satellite
                    ? AppColors.colorAccent
                    : AppColors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: SizedBox(
                height: 50,
                child: Image.asset(
                  AppImages.satellitemapimg,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          title: const Text(
            "Satellite Map",
            style: AppTextStyles.historypagetextstyle,
          ),
        ),
        const SizedBox(height: 16.0),
        ListTile(
          onTap: () {
            cont.changeMapType(MapType.terrain);
          },
          leading: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: cont.mapType.value == MapType.terrain
                    ? AppColors.colorAccent
                    : AppColors.white),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: SizedBox(
                height: 50,
                child: Image.asset(AppImages.terrainmapimg),
              ),
            ),
          ),
          title: const Text(
            "Terrain Map",
            style: AppTextStyles.historypagetextstyle,
          ),
        ),
      ],
    ),
  );
}

class AddPlacesdialog extends StatefulWidget {
  TrackController cont;

  AddPlacesdialog({super.key, required this.cont});
  @override
  _AddPlacesdialogState createState() => _AddPlacesdialogState();
}

class _AddPlacesdialogState extends State<AddPlacesdialog> {
  String _selectedItem = "Airports";
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  @override
  void initState() {
    super.initState();
    _textFieldController1.text = widget.cont.locationname.value;
    _textFieldController2.text = widget.cont.locationaddress.value;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text(
                "Add Place",
                style: TextStyle(color: AppColors.white),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: AppColors.backgroundcolor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _textFieldController1,
                    decoration: const InputDecoration(
                      labelText: "Place Name",
                    ),
                    onChanged: (val) {
                      widget.cont.locationname.value = val;
                    },
                  ),
                  TextField(
                    controller: _textFieldController2,
                    decoration: const InputDecoration(
                      labelText: "Place Address",
                    ),
                    onChanged: (val) {
                      widget.cont.locationaddress.value = val;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  const Text("Select Category"),
                  const SizedBox(height: 8.0),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    color: AppColors.backgroundcolor.withOpacity(.4),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      menuMaxHeight: 400.0,
                      underline: const SizedBox(),
                      value: _selectedItem,
                      items: placesjson.map((var item) {
                        return DropdownMenuItem<String>(
                          value: item.name,
                          child: Text(item.name),
                        );
                      }).toList(),
                      onChanged: (String? selectedItem) {
                        setState(() {
                          _selectedItem = selectedItem!;
                        });
                      },
                      hint: const Text('Select an item'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    color: AppColors.backgroundcolor,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                  MaterialButton(
                    color: AppColors.backgroundcolor,
                    onPressed: () {
                      widget.cont.changepickervalue(false);
                      Navigator.of(context).pop(_selectedItem);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

/////
///
Future<void> showCustomOptionsPopupMenu(BuildContext context,
    List<String> optionTexts, List<void Function()> optionActions) async {
  assert(optionTexts.length == optionActions.length);

  await showMenu<void>(
    context: context,
    position:
        const RelativeRect.fromLTRB(100, 120, 10, 0), // Adjust the position
    items: List.generate(
      optionTexts.length,
      (index) {
        return PopupMenuItem<void Function()>(
          onTap: optionActions[index],
          child: Text(optionTexts[index]),
        );
      },
    ),
  );
}

////
///
///
///
loadingDialog({required String text}) {
  Get.defaultDialog(
      title: "",
      backgroundColor: Colors.transparent, // This makes the dialog transparent
      content: Dialog(
          backgroundColor: Colors.transparent,
          child: AnimatedDialog(
            text: text,
          )));
}

class AnimatedDialog extends StatefulWidget {
  String text;
  AnimatedDialog({super.key, required this.text});

  @override
  AnimatedDialogState createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog> {
  double _imageSize = 50.0; // Initial size of the image

  @override
  void initState() {
    super.initState();
    // You can add logic here to start the animation when needed
    _startAnimation();
  }

  void _startAnimation() {
    // Use a timer to gradually increase the image size
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (_imageSize < 100) {
        if (mounted) {
          setState(() {
            _imageSize += 10.0;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _imageSize -= 10.0;
          });
        }
        // Stop the animation when image reaches desired size
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 100), // Animation duration
            height: _imageSize,
            child: Image.asset(
                AppImages.shoesimg), // Replace with your image asset
          ),
          const SizedBox(height: 16),
          Text(
            widget.text,
            style: AppTextStyles.performancepagetextstyle,
          ),
        ],
      ),
    );
  }
}

void showhelpDialog() {
  Get.dialog(
    AlertDialog(
      title: Center(
          child: Text(
        "welcome".tr,
        style: const TextStyle(
            color: AppColors.backgroundcolor, fontWeight: FontWeight.bold),
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "helptext".tr,
            style:
                const TextStyle(color: AppColors.backgroundcolor, fontSize: 13),
          ),
          // Add any other widgets you need in the dialog content
        ],
      ),
      actions: [
        Center(
          child: InkWell(
            onTap: () {
              // Close the dialog when the button is pressed
              Get.back();
            },
            child: Container(
              color: AppColors.backgroundcolor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Text(
                  "gotit".tr,
                  style: const TextStyle(color: AppColors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

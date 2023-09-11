// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import '../../Utils/Constants.dart';

class WaterActivity extends StatefulWidget {
  const WaterActivity({super.key});

  @override
  WaterActivityState createState() => WaterActivityState();
}

int water = 0;

class WaterActivityState extends State<WaterActivity> {
  void incrementWater() {
    setState(() {
      water++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.homebgimg),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).clearSnackBars();
              },
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Water", style: AppTextStyles.waterpagetextstyle),
                SizedBox(height: 20),
                Text("Water Drank: $water glasses",
                    style: AppTextStyles.waterpagetextstyle1),
                SizedBox(height: 20),
                DraggableGlass(),
                SizedBox(height: 20),
                DragTarget(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: AppColors.colorPrimaryDark,
                      child: Center(
                        child: Text("Drop here",
                            style: AppTextStyles.waterpagetextstyle1),
                      ),
                    );
                  },
                  onWillAccept: (data) => data == 'glass',
                  onAccept: (data) {
                    incrementWater();
                    Get.closeAllSnackbars();
                    Get.snackbar("Pacer", "Water drank!",
                        backgroundColor: Colors.green,
                        colorText: AppColors.white);
                  },
                  onLeave: (data) {},
                ),
                SizedBox(height: 20),
                Text("Drag glass to increase water drank",
                    style: AppTextStyles.waterpagetextstyle1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DraggableGlass extends StatelessWidget {
  const DraggableGlass({super.key});

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data:
          'glass', // Data to send when the draggable is accepted by the target.
      child: Icon(
        MaterialCommunityIcons
            .glass_pint_outline, // You can replace this with any appropriate glass icon.
        color: Colors.blue,
        size: 40,
      ),
      feedback: Icon(
        MaterialCommunityIcons.glass_pint_outline,
        color: Colors.blue.withOpacity(0.7),
        size: 40,
      ),
      childWhenDragging: Icon(
        MaterialCommunityIcons.glass_pint_outline,
        color: Colors.grey,
        size: 40,
      ),
      onDragEnd: (details) {},
    );
  }
}

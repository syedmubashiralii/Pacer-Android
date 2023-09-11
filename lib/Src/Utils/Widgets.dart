// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../Presentation/UI/WaterPage.dart';
import '../Presentation/Widgets/PerformanceWidgets.dart';
import 'Constants.dart';
import 'Functions.dart';

class AppWigets {
  static Widget textwidget(String text, Color color, VoidCallback onTap,
          {double size = 14}) =>
      Builder(builder: (context) {
        return InkWell(
          onTap: onTap,
          child: Text(
            textScaleFactor: ScaleSize.textScaleFactor(context),
            textAlign: TextAlign.center,
            text,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w700, fontSize: size),
          ),
        );
      });
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  Widget child;

  CustomAppBar({Key? key, required this.height, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: child);
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

Widget waterWidget(context) {
  return Visibility(
    visible: false,
    replacement: const SizedBox.shrink(),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WaterActivity(),
          ),
        );
      },
      child: const BlinkingWidget(
        isBelowRequirement: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.radio_button_checked,
              color: Colors.white,
              size: 22,
            ),
            Text(
              "${AppStrings.water} ",
              style: AppTextStyles.performancepagetextstyle,
            ),
          ],
        ),
      ),
    ),
  );
}

class AddPlacesCircleButton extends StatelessWidget {
  VoidCallback ontap;
  IconData icon;
  AddPlacesCircleButton({super.key, required this.ontap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.backgroundcolor,
        ),
        child: Icon(
          icon,
          color: AppColors.white,
        ),
      ),
    );
  }
}

Widget text(String text, String name) {
  return Text(
    text,
    style: TextStyle(
        fontSize: 14,
        color: selectedlanguage == name ? Colors.red : Colors.white,
        fontWeight: FontWeight.w400),
  );
}

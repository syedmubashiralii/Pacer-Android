import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';

import '../../Domain/Controllers/WidgetsController.dart';
import '../../Utils/Constants.dart';
import 'package:alxgration_speedometer/speedometer.dart';

import '../../Utils/Functions.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({
    super.key,
  });

  @override
  WeatherWidgetState createState() => WeatherWidgetState();
}

class WeatherWidgetState extends State<WeatherWidget> {
  WidgetsController widgetsController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      widgetsController.weatherIcon,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text('${widgetsController.temp.value} °C',
                        textScaleFactor: ScaleSize.textScaleFactor(context),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15)),
                  ],
                ),
                Text("${'humidity'.tr}: ${widgetsController.humidity.value}",
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                    style: AppTextStyles.goalpagetextstyle1),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widgetsController.time.value,
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15)),
                Text("${'sunrise'.tr}: ${widgetsController.sunrise.value}",
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                    style: AppTextStyles.goalpagetextstyle1),
                Text("${'sunset'.tr}: ${widgetsController.sunset.value}",
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                    style: AppTextStyles.goalpagetextstyle1),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class CompassWidget extends StatefulWidget {
  const CompassWidget({super.key});

  @override
  _CompassWidgetState createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget> {
  StreamSubscription<CompassEvent>? _compassSubscription;
  WidgetsController widgetcontroller = Get.find();
  @override
  void initState() {
    super.initState();
    _listenDirection();
  }

  // Function to start listening to changes in direction
  void _listenDirection() {
    _compassSubscription = FlutterCompass.events!.listen((CompassEvent data) {
      widgetcontroller.direction.value = data.heading!;
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel(); // Cancel the subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return widgetcontroller.direction.value != 0.0
          ? Transform.rotate(
              angle: ((widgetcontroller.direction.value ?? 0) *
                  (math.pi / 180) *
                  -1),
              child: Image.asset(AppImages.compassimg),
            )
          : Center(child: Image.asset(AppImages.compassimg));
    });
  }
}

class SpeedometerWidget extends StatelessWidget {
  final double speed;

  const SpeedometerWidget({Key? key, required this.speed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int speedValue = speed.toInt();

    return Speedometer(
      minValue: 0,
      maxValue: 200,
      currentValue: speedValue,
      pointerColor: AppColors.white,
      barColor: Colors.green,
      displayText: 'km/h',
      displayNumericStyle: const TextStyle(color: AppColors.white),
      displayTextStyle: const TextStyle(color: AppColors.white),
    );
  }
}

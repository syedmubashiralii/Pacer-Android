import 'package:get/get.dart';
import 'package:pacer/Src/Domain/Controllers/GoalController.dart';
import 'package:pacer/Src/Domain/Controllers/HistoryController.dart';
import 'package:pacer/Src/Domain/Controllers/HomeController.dart';
import 'package:pacer/Src/Domain/Controllers/TrackController.dart';
import 'package:pacer/Src/Domain/Controllers/WidgetsController.dart';

class PacerBindings implements Bindings {
// default dependency
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => WidgetsController());
    Get.lazyPut(() => HistoryController());
    Get.lazyPut(() => GoalController());
    Get.lazyPut(() => TrackController());
  }
}

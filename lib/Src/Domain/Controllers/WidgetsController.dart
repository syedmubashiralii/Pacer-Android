import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pacer/Src/Utils/Constants.dart';
import 'package:pacer/Src/Utils/Functions.dart';

class WidgetsController extends GetxController {
  late StreamSubscription<Position> positionSubscription;
  RxString time = "".obs;
  RxString humidity = "".obs;
  RxString sunrise = "".obs;
  RxString sunset = "".obs;
  RxString temp = "".obs;
  RxString address = "".obs;
  RxDouble speed = 0.0.obs;
  RxDouble latitude = 33.7.obs;
  RxDouble longitude = 63.6.obs;

  
  //////
  ///
  RxDouble direction=0.0.obs;
  ///////

  //*********************************************************************************** */
  //********************************************************************************** */
  //****************************************************Weather data Widget Variables */

  IconData weatherIcon = Icons.sunny;

  ///*********************************************************************************** */
  /////********************************************************************************* */

  Timer? timer;
  Position? lastPosition;

  @override
  void onInit() {
    super.onInit();
    initPosition();
  }

  @override
  void onClose() {
    super.onClose();
    positionSubscription.cancel();
  }

  Future<void> updateWeather() async {
    try {
      final uri = Uri.https(
        'api.openweathermap.org',
        '/data/2.5/weather',
        {
          'lat': '${latitude.value}',
          'lon': '${longitude.value}',
          'appid': AppStrings.openWeatherMapsApi,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var temperature = jsonResponse['main']['temp'];
        var hum = jsonResponse['main']['humidity'];
        var sunRise = jsonResponse['sys']['sunrise'];
        var sunSet = jsonResponse['sys']['sunset'];
        var w = jsonResponse['weather'][0]['main'];
        var icon = WeatherIconHelper.getWeatherIcon(w);

        temp.value = (temperature - 273.15).toStringAsFixed(2);
        humidity.value = hum.toString();
        sunrise.value =
            formatTime(DateTime.fromMillisecondsSinceEpoch(sunRise * 1000));
        sunset.value =
            formatTime(DateTime.fromMillisecondsSinceEpoch(sunSet * 1000));
        weatherIcon = icon;
        time.value = formatTime(DateTime.now());
      }
    } catch (e) {
      dlog("Widgetscontrollerweatherwidgetexception", e);
    }
  }

  String formatTime(DateTime dateTime) {
    int hour = dateTime.hour;
    if (dateTime.hour > 12) {
      hour = dateTime.hour - 12;
    }
    String SHour = hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String period = dateTime.hour < 12 ? 'AM' : 'PM';

    return '$SHour:$minute $period';
  }

  void initPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    time.value = formatTime(DateTime.now());
    updateWeather();
    updateAddress(position);
    startListening();
  }

  void startListening() {
    try {
      positionSubscription =
          Geolocator.getPositionStream().listen((Position position) {
        time.value = formatTime(DateTime.now());
        lastPosition = position;
        double tempSpeed = position.speed * 3.6;
        if (tempSpeed < 0) tempSpeed = 0;
        speed.value = tempSpeed;

        updateAddress(position);
      });
    } catch (e) {
      dlog("Locationstrem exception", e.toString());
    }
  }

  Future<void> updateAddress(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        address.value =
            '${place.street},${place.subLocality} ${place.locality}, ${place.country}';
      }
    } catch (e) {
      dlog('Failed to get address:', e);
    }
  }
}

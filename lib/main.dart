import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pacer/Src/Configs/Bindings.dart';
import 'package:pacer/Src/Utils/Functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upgrader/upgrader.dart';
import 'Src/Data/Translations.dart';
import 'Src/Domain/DataHandlers/PreferencesData.dart';
import 'Src/Domain/Services/BackgroundService.dart';
import 'Src/Presentation/UI/LandingPage.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Directory? directory;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  directory = await getExternalStorageDirectory();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initializeService();

  await AppSharedPreferences.initializepref();
  await MobileAds.instance.initialize();
  if (kDebugMode) {
    MobileAds.instance.initialize().then((initializationStatus) {
      initializationStatus.adapterStatuses.forEach((key, value) {
        debugPrint('Adapter status for $key: ${value.description}');
      });
    });
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    await MobileAds.instance
        .updateRequestConfiguration(RequestConfiguration(testDeviceIds: [
      '207F634965BDB8A1770F48FCBDCC687E',
      '259B8E84159393A011811CF8414D3001',
      '608354B9C20C9712E0DDD21BF1B87519',
      '5F4E42DDDE3816C33A24C0B220592846',
      'DC70E32DDC2878521A736B5CF7868630',
      '00ef33fa-9a30-4cd7-9cfb-0653f3de2b83'
    ]));
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(

      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) {
      //     return
      const MyApp()
      // })
      );
}

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Languages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Pacer',
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.green, // Change cursor color
          selectionHandleColor: Colors.green, // Change handle color
        ),
        fontFamily: "poppins",
        useMaterial3: false,
      ),
      initialBinding: PacerBindings(),
      navigatorObservers: <NavigatorObserver>[observer],
      home: FGBGNotifier(
          onEvent: (event) async {
            dlog("", event);
            final service = FlutterBackgroundService();
            if (event == FGBGType.background) {
              service.startService();
            } else {
              service.invoke("stopService");
            }
            var isRunning = await service.isRunning();
            dlog("isservice running", isRunning);
          },
          child: UpgradeAlert(child: const LandingPage())),
    );
  }
}

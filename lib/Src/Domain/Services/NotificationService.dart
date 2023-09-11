import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../Utils/Functions.dart';

class NotificationServices {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initializelocalnotifications() {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: onSelectNotification);
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // onSelectNotification(payload);

      handleMessage(context, message);
    });
  }

  Future<dynamic> onSelectNotification(payload) async {
    dlog("", "entered payload");
    try {
      Map paylod = jsonDecode(payload.toString());
      dlog("", paylod["data"]);
    } catch (e) {
      print(e.toString());
    }
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString(),
        importance: Importance.max,
        showBadge: true,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'));

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'High Importance Notification chanel',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            ticker: 'ticker',
            sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
            //  icon: largeIconPath
            );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<void> showlocalnotification(
      String message, String title, String payload, String imageUrl) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        importance: Importance.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('jetsons_doorbell'));
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(imageUrl),
        largeIcon: FilePathAndroidBitmap(imageUrl),
        contentTitle: title,
        summaryText: message,
      ),
    );
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          1, title, message.toString(), notificationDetails,
          payload: payload);
    });
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MessageScreen(
      //               id: message.data['id'],
      //             )));
      dlog(message.data['groupusers'].toString(), "");
      // Navigator.pushNamed(context, chatScreen.id, arguments: {
      //   "groupId": message.data['groupId'],
      //   "groupName": message.data['groupName'],
      //   "groupusers": message.data['groupusers'],
      //   "createdBy": message.data["createdBy"],
      //   "groupImgPath": message.data["groupIcon"]
      // });
    } else if (message.data['type'] == 'groupinvite') {}
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  sendnotification(
      String fcm,
      String title,
      String body,
      String groupid,
      String groupname,
      List groupusers,
      String createdby,
      String groupimgpath) async {
    // send notification from one device to another

    var data = {
      'to': fcm.toString(),
      'notification': {
        'title': title,
        'body': body,
        "sound": "jetsons_doorbell.mp3"
      },
      'android': {
        'notification': {
          'notification_count': 23,
        },
      },
      'data': {
        'type': 'msg',
        'groupId': groupid,
        "groupName": groupname,
        "groupusers": groupusers,
        "createdBy": createdby,
        "groupImgPath": groupimgpath
      }
    };

    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAg5Untsk:APA91bGpEHZpeJJu1vHqoYnnfcsBv__pMCBU0lD0lB09yDIJ5RDvS5vwkvHDw574Ly2YYjFCHKe4wRPy9Lg9VxpMZw9gDsxcer9KGLBJkk-4xrW2KZGzfO8QRPmWqEse1gAMbRqpuk4i'
        }).then((value) {
      if (kDebugMode) {
        dlog("", value.body.toString());
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        dlog("", error);
      }
    });
  }

  sendinvitetouser(
    String fcm,
    String title,
    String body,
  ) async {
    var data = {
      'to': fcm.toString(),
      'notification': {
        'title': title,
        'body': body,
        "sound": "jetsons_doorbell.mp3"
      },
      'android': {
        'notification': {
          'notification_count': 1,
        },
      },
      'data': {
        'type': 'groupinvite',
      }
    };

    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAjkaO7Lo:APA91bFhMkXnhwfUW9vPCunEMkFymG500ODbKvLkK9jjJCLDp74lSeMwux62-XfsDZqS5B0U10DOBTY3haSenq2ZQIwoy7ogPRpR-emrgSN2oJqmR3H5FNFzc40ELwEVplCaVc8tHG0T'
        }).then((value) {
      if (kDebugMode) {
        dlog("", value.body.toString());
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        dlog("", error);
      }
    });
  }
}

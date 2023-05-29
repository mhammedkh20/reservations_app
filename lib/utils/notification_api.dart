import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reservations_app/utils/app_constant.dart';

//  android and ios
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('my token Device ${await FirebaseMessaging.instance.getToken()}');

  RemoteNotification? notification = message.notification;

  if (notification != null) {
    if (notification.title != null) {
      NotificationApi.showNotification(
        id: notification.hashCode,
        title: notification.title ?? "",
        body: notification.body ?? "",
        urlImage: notification.android == null
            ? null
            : notification.android!.imageUrl,
        // payload: 'mohammed',
      );
    }
  }
}

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();
  // static final onNotification = BehaviorSubject<String?>();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
    playSound: true,
  );

  static void requestIOSPermissions() {
    if (Platform.isIOS) {
      _notification
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  static Future _notificationDetails({String? urlImage}) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        icon: '@mipmap/launcher_icon',
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future initNotification() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions();
  }

  static Future init() async {
    log('my token Device ${await FirebaseMessaging.instance.getToken()}');
    NotificationAppLaunchDetails? details =
        await _notification.getNotificationAppLaunchDetails();

    AndroidInitializationSettings android =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    DarwinInitializationSettings ios = const DarwinInitializationSettings();

    InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: ios,
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    String? urlImage,
  }) async {
    _notification.show(
      id,
      title,
      body,
      await _notificationDetails(urlImage: urlImage),
      payload: payload,
    );
  }

  Future cancelNotificationById(int id) async {
    await _notification.cancel(id);
  }

  Future cancelAllNotification() async {
    await _notification.cancelAll();
  }

  static Future<bool> pushNotificationsAllUsers({
    required String title,
    required String body,
  }) async {
    String dataNotifications = '{ '
        ' "to" : "/topics/all_users" , '
        ' "notification" : {'
        ' "title":"$title" , '
        ' "body":"$body" '
        ' } '
        ' } ';

    var response = await http.post(
      Uri.parse(AppConstantNotification.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${AppConstantNotification.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    print(response.body.toString());
    return true;
  }

  static Future<bool> pushNotificationsToUser({
    required String title,
    required String body,
    required String fcm,
  }) async {
    String dataNotifications = '{ "to" : "$fcm",'
        ' "notification" : {'
        ' "title":"$title",'
        '"body":"$body"'
        ' }'
        ' }';

    var response = await http.post(
      Uri.parse(AppConstantNotification.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${AppConstantNotification.KEY_SERVER}',
        'project_id': "AppConstantNotification.SENDER_ID"
      },
      body: dataNotifications,
    );
    log(response.statusCode.toString());
    print(response.body.toString());
    return true;
  }
}

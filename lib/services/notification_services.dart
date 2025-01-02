import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Top-level function for handling background notifications
void backgroundNotificationResponseHandler(
    NotificationResponse notification) async {}

class NotificationService {
//Todo Initlize FlutterLocalNotificationsPlugin

  static final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

//Todo Initlize notification
  Future<void> initNotification() async {
    //Todo Defind Andriod initlize notification
    const AndroidInitializationSettings initializationAndroidSettings =
        AndroidInitializationSettings('logo');

    final DarwinInitializationSettings initializationSettingIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      defaultPresentSound: true,
      defaultPresentAlert: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );
//Todo initlize both platform settings
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationAndroidSettings,
      iOS: initializationSettingIOS,
    );

    await notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          backgroundNotificationResponseHandler,
    );
  }

//Todo Calling Notification Dialog
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await notificationPlugin.show(
      id,
      title,
      body,
      await notificationDetails(),
      payload: payload,
    );
  }

//Todo given notification Details
  Future<NotificationDetails> notificationDetails() async {
    return const NotificationDetails(
      iOS: DarwinNotificationDetails(),
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }
}

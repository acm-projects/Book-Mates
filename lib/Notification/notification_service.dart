import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> initNotifications() async {
  const androidSettings =
      AndroidInitializationSettings('mipmap/ic_launcher'); // Path to icon
  const initSettings = InitializationSettings(android: androidSettings);
  await FlutterLocalNotificationsPlugin().initialize(initSettings);
}

Future<void> sendNotification(String title, String body) async {
  AndroidNotificationDetails androidPlatformChannel =
      const AndroidNotificationDetails(
          'notification_service', 'notification service',
          playSound: true, importance: Importance.max, priority: Priority.max);
  final details = NotificationDetails(android: androidPlatformChannel);
  await FlutterLocalNotificationsPlugin().show(0, title, body, details);
}

Map<String, dynamic> newData = {};
DateTime appStartTime = DateTime.now();
Future<void> checkMessages() async {
  // Get current users currentGroup
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  final userData =
      FirebaseFirestore.instance.collection('users').doc(userEmail);
  final snapshot = await userData.get();
  Map<String, dynamic>? data = snapshot.data();
  if (data != null && data.containsKey('currentGroupID')) {
    String currentGroupID = data['currentGroupID'].toString();

    // Get updated list of all messages in the group
    FirebaseFirestore.instance
        .collection('groups')
        .doc(currentGroupID)
        .collection('Messages')
        .orderBy('timeStamp')
        .snapshots()
        .listen((event) {
      final messages = [];
      for (var doc in event.docs) {
        messages.add(doc.data());
      }

      // Last message in list is the newest message
      if (messages.last['timeStamp'] != newData['timeStamp']) {
        newData = messages.last;
        print('New message from ${newData['senderID']}: ${newData['text']}');
        if ((newData['timeStamp'] as Timestamp)
            .toDate()
            .isAfter(appStartTime)) {
          // Un comment this if you want it to send notification for your own messages
          // if (newData['senderID'] != userEmail) {
          sendNotification(newData['senderID'], newData['text']);
          // }
        }
      }
    });
  }
}

Future<void> initBackgroundService() async {
  print('Background service started');
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false,
    ),
  );
}

Future<void> onStart(ServiceInstance service) async {
  await initNotifications();
  await Firebase.initializeApp();
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: 'FOREGROUND', content: 'App is in foreground');
      }
    }
    checkMessages();
    print('Background service running');
    service.invoke('update');
  });
}

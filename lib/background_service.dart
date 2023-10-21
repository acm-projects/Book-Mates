import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

// Global Const for notification settings
const notificationChannelID = 'chat_background';
const notificationID = 888;

// Needed to init local notification plugin settings before sending
Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const androidSettings =
      AndroidInitializationSettings('mipmap/ic_launcher'); // Path to icon
  const initSettings = InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

// Simple notification function, all you need is a title, body, and local notification instance
Future<void> sendNotification(
    String title, String body, FlutterLocalNotificationsPlugin fln) async {
  AndroidNotificationDetails androidPlatformChannel =
      const AndroidNotificationDetails('noti_service', 'Notification Service',
          channelDescription: 'Gorup chat notifications in the background',
          playSound: true,
          importance: Importance.max,
          priority: Priority.max);
  final details = NotificationDetails(android: androidPlatformChannel);
  await fln.show(0, title, body, details);
}

// Global to store whenever there is a new message
Map<String, dynamic> newestData = {
  'text': 'message',
  'senderID': 'user',
};

// Check firestore group/message collection for a new entry
Future<void> checkForNewMessages(ServiceInstance service) async {
  // Get current users 'currentGroup'
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  String? userEmail = auth.currentUser?.email;

  final userDB = db.collection('users').doc(userEmail);
  final snapshot = await userDB.get();
  Map<String, dynamic>? data = snapshot.data();

  // Check if the user has a 'currentGroup' field in the 'users' collection
  if (data != null && data.containsKey('currentGroupID')) {
    final currentGroup = data['currentGroupID'].toString();

    // Get an updated list of all of the messages in the 'currentGroup'/'Messages' collection
    final fln = FlutterLocalNotificationsPlugin();
    initNotifications(fln);
    FirebaseFirestore.instance
        .collection('groups')
        .doc(currentGroup)
        .collection('Messages')
        .orderBy('timeStamp')
        .snapshots()
        .listen(
      (event) async {
        // Store sorted messages in the list
        final messages = [];
        for (var doc in event.docs) {
          messages.add(doc.data());
        }

        // Last message in list is the newest message based on 'TimeCreated'
        if (messages.last['timeStamp'] != newestData['timeStamp']) {
          // If this newest message was created in a different time then it is the new message
          newestData = messages.last;
          print(
              'NOTICE:::::::::::::NEWEST MESSAGE: ${newestData['senderID']}: "${newestData['text']}"');

          // If the service is not in foreground mode send the notification
          if (service is AndroidServiceInstance) {
            if (await service.isForegroundService() == false) {
              if (newestData['senderID'] != auth.currentUser?.email) {
                await sendNotification(
                    newestData['senderID'], newestData['text'], fln);
              }
            }
          }
        }
      },
    );
  } else {
    print('NOTICE:::::::::::::User is not currently in a group');
  }
}

// Initialize the background service (Start in main.dart)
Future<void> initBackgroundService() async {
  print('BACKGROUND:::::::::::::SERVICE:::::::::::::STARTED');

  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
  );
}

// Start the service using configuration from initBackgroundService()
Future<void> onStart(ServiceInstance service) async {
  // Firebase needs to be initialized with the service so we can use firebase pkgs
  await Firebase.initializeApp();
  DartPluginRegistrant.ensureInitialized();

  // Define service functions
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

  // Keep persistent notification when app is in foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        // Show notification every second in foreground
        service.setForegroundNotificationInfo(
            title: 'FOREGROUND', content: 'App is in foreground');
      }
    }
    // Check for new message every second
    checkForNewMessages(service);

    service.invoke('update');
  });
}

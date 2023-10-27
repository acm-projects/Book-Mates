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

Future<String> getCurrentGroupID() async {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  final userData =
      FirebaseFirestore.instance.collection('users').doc(userEmail);
  final snapshot = await userData.get();
  Map<String, dynamic>? data = snapshot.data();
  if (data != null && data.containsKey('currentGroupID')) {
    return data['currentGroupID'];
  } else {
    return "";
  }
}

DateTime appstartTime = DateTime.now();

// Fix null type error here
bool isNewData(Timestamp? initTime, Timestamp? compareTime) {
  if (initTime!.toDate().isAfter(appstartTime)) {
    if (compareTime == null) {
      return true;
    }
    if (initTime != compareTime) {
      return true;
    }
  }
  return false;
}

Map<String, dynamic> newMessage = {};
Future<void> checkForNewMessages() async {
  String currentGroupID = await getCurrentGroupID();
  if (currentGroupID != "") {
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

      // if (isNewData(messages.last?['timeStamp'], newMessage['timeStamp'])) {
      //   newMessage = messages.last;
      //   print('New message from ${newMessage['senderID']}: ${newMessage['text']}');
      //   sendNotification(newMessage['senderID'], newMessage['text']);
      // }
      if ((messages.last['timeStamp']).toDate().isAfter(appstartTime)) {
        if (messages.last['timeStamp'] != newMessage['timeStamp']) {
          newMessage = messages.last;
          print(
              'New message from ${newMessage['senderID']}: ${newMessage['text']}');
          sendNotification(newMessage['senderID'], newMessage['text']);
        }
      }
    });
  }
}

Map<String, dynamic> newMilestone = {};
Future<void> checkForNewMilestone() async {
  String currentGroupID = await getCurrentGroupID();
  if (currentGroupID != "") {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(currentGroupID)
        .collection('Milestone')
        .orderBy('startTime')
        .snapshots()
        .listen((event) {
      final milestones = [];
      for (var doc in event.docs) {
        milestones.add(doc.data());
      }

      // if (isNewData(milestones.last['startTime'], newMilestone['start'])) {
      //   newMilestone = milestones.last;
      //   print('New milestone has been created ${newMilestone['goal']}');
      //   sendNotification('${currentGroupID} has a new Milestone!', newMilestone['goal']);
      // }

      if ((milestones.last['startTime']).toDate().isAfter(appstartTime)) {
        if (milestones.last['startTime'] != newMilestone['startTime']) {
          newMilestone = milestones.last;
          print('New milestone has been created ${newMilestone['goal']}');
          sendNotification(
              '$currentGroupID has a new Milestone!', newMilestone['goal']);
        }
      }
    });
  }
}

Future<void> initBackgroundService() async {
  print('Background service startTimeed');
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
    checkForNewMessages();
    checkForNewMilestone();
    print('Background service running');
    service.invoke('update');
  });
}

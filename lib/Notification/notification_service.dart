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

Future<void> sendNotification(String title, String body, bool media) async {
  AndroidNotificationDetails androidPlatformChannel =
      const AndroidNotificationDetails(
          'notification_service', 'notification service',
          playSound: true, importance: Importance.max, priority: Priority.max);
  final details = NotificationDetails(android: androidPlatformChannel);
  if (media) {
    await FlutterLocalNotificationsPlugin().show(0, title, 'image', details);
  } else {
    await FlutterLocalNotificationsPlugin().show(0, title, body, details);
  }
}

Future<String?> getCurrentGroupID() async {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  final userData =
      FirebaseFirestore.instance.collection('users').doc(userEmail);
  final snapshot = await userData.get();
  Map<String, dynamic>? data = snapshot.data();
  if (data != null && data.containsKey('currentGroupID')) {
    return data['currentGroupID'];
  } else {
    return null;
  }
}

DateTime appstartTime = DateTime.now();

List<Timestamp> newMessages = [];
Future<void> checkForNewMessages() async {
  String? currentGroupID = await getCurrentGroupID();
  bool media = false;
  if (currentGroupID != null) {
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

      if (messages.isNotEmpty) {
        Timestamp? timeStamp = messages.last['timeStamp'];
        final message = messages.last;

        if (timeStamp != null && timeStamp.toDate().isAfter(appstartTime)) {
          if (!newMessages.contains(timeStamp)) {
            newMessages.add(timeStamp);
            if (message['mediaURL'] != '') { media = true; } 
            else { media = false; }

            print('New message.last from ${message['senderID']}: ${message['text']}, media: $media');
            sendNotification(message['senderID'], message['text'], media);
          }
        }

      }
    });
  }
}

List<Timestamp> newMilestone = [];
Future<void> checkForNewMilestone() async {
  String? currentGroupID = await getCurrentGroupID();
  if (currentGroupID != null) {
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

      if (milestones.isNotEmpty) {
        Timestamp? timeStamp = milestones.last['startTime'];
        final milestone = milestones.last;

        if (timeStamp != null && timeStamp.toDate().isAfter(appstartTime)) {
            if (!newMilestone.contains(timeStamp)) {
              newMilestone.add(timeStamp);
              print('New milestone has been created ${milestone['goal']}');
              sendNotification('$currentGroupID has a new Milestone!', milestone['goal'], false);
            }
          }
        }
      }
    );
  }
}

List<String> completedMilestones = [];
Future<void> checkForCompletedMilestone() async {
  String? currentGroupID = await getCurrentGroupID();
  if (currentGroupID != null) {
    final snapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(currentGroupID)
        .collection('Milestone')
        .get();

    final milestoneCollection = snapshot.docs;
    for (var data in milestoneCollection) {
      final milestoneData = data.data();
      if (milestoneData['completeTime'] != null &&
          (milestoneData['completeTime']).toDate().isAfter(appstartTime)) {
        if (!completedMilestones.contains(milestoneData['id'])) {
          completedMilestones.add(milestoneData['id']);
          print('Milestone ${milestoneData['goal']} has been completed');
          sendNotification('$currentGroupID Milestone completed!',
              '${milestoneData['goal']}', false);
          await FirebaseFirestore.instance
              .collection("groups/$currentGroupID/Milestone")
              .doc(milestoneData['id'])
              .delete();
        }
      }
    }
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
    checkForNewMessages();
    checkForNewMilestone();
    checkForCompletedMilestone();
    print('Background service running');
    // service.invoke('update');
  });
}

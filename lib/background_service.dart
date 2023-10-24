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

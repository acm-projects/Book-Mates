<<<<<<< HEAD
import 'package:bookmates_app/Milestone/milestone_page.dart';
import 'package:bookmates_app/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'library.dart';

AppLifecycleState state = AppLifecycleState.detached;

//import 'screen123.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBkxFME7rc2qYpjJcO_nSnEmlyfNBh5jms",
          appId: "1:413615361765:web:a80bfa4e1ccedd1fdcce0c",
          messagingSenderId: "413615361765",
          projectId: "bookma-d79ce"));

  runApp(const MaterialApp(home: Library()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/milestonePage': (context) => const MilestoneListPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const WidgetTree(),
    );
  }
}
=======
import 'package:bookmates_app/Group%20Operations/create_group.dart';
import 'package:bookmates_app/Group%20Operations/delete_page.dart';
import 'package:bookmates_app/GroupChat/chat_page.dart';
import 'package:bookmates_app/Milestone/milestone_page.dart';
import 'package:bookmates_app/Notification/notification_service.dart';
import 'package:bookmates_app/PDF%20Upload/pdf_screen.dart';
import 'package:bookmates_app/home_page.dart';
import 'package:bookmates_app/login_register.dart';
import 'package:bookmates_app/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

AppLifecycleState state = AppLifecycleState.detached;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBkxFME7rc2qYpjJcO_nSnEmlyfNBh5jms",
          appId: "1:413615361765:web:a80bfa4e1ccedd1fdcce0c",
          messagingSenderId: "413615361765",
          projectId: "bookma-d79ce"));
  Permission.notification.isDenied.then(
    (value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );
  await initBackgroundService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        // routes to easily navigate from one page to another
        '/milestonePage': (context) => const MilestoneListPage(),
        '/createGroup': (context) => const CreateOrDeleteGroup(),
        '/deletePage': (context) => const DeletePage(),
        '/chatPage': (context) => const ChatHome(),
        '/pdfScreen': (context) => const PDFReaderApp(),
        '/homePage': (context) => const HomePage(),
        'loginRegister': (context) => const LoginPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const WidgetTree(),
    );
  }
}
>>>>>>> 16842178a12d63b1bb36202202abb9e0f59603bc

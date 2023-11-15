import 'package:bookmates_app/Group%20Operations/create_group.dart';
import 'package:bookmates_app/Group%20Operations/delete_page.dart';
import 'package:bookmates_app/Group%20Operations/group_home.dart';
import 'package:bookmates_app/Group%20Operations/group_list.dart';
import 'package:bookmates_app/Group%20Operations/group_widget_tree.dart';
import 'package:bookmates_app/Group%20Operations/join_group.dart';
import 'package:bookmates_app/GroupChat/chat_page.dart';
import 'package:bookmates_app/Milestone/milestone_page.dart';
import 'package:bookmates_app/Notification/notification_service.dart';
import 'package:bookmates_app/PDF%20Upload/pdf_screen.dart';
import 'package:bookmates_app/User%20Implementation/profile_page.dart';
import 'package:bookmates_app/home_page.dart';
import 'package:bookmates_app/login_screen.dart';
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
        '/groupWidgetTree': (context) => const GroupWidgetTree(),
        '/groupPage': (context) => const GroupHome(),
        '/createGroup': (context) => const CreateGroupScreen(),
        '/deletePage': (context) => const DeletePage(),
        '/chatPage': (context) => const ChatHome(),
        '/pdfScreen': (context) => const PDFReaderApp(),
        '/homePage': (context) => const HomePage(),
        '/loginPage': (context) => const LoginPage(),
        '/joinGroup': (context) => const JoinGroup(),
        '/listGroups': (context) => const Groups(),
        '/profilePage': (context) => const ProfilePage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const WidgetTree(),
    );
  }
}

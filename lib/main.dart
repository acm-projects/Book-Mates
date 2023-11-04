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

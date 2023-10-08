import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bookmates_app/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home:
          const WidgetTree(), // the home of the app is the widget tree, where itll direct the unsigned user to the loginpage, or the signed in user to the hompage
    );
  }
}

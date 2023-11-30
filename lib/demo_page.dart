import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

// backgroud color of the join group page
Widget _backgroundContainer() {
  return Container(
    color: const Color(0xFF75A10F),
    height: double.infinity,
  );
}

// the title of the page
Widget _appBarWidget() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Container(
      padding: const EdgeInsets.only(
        top: 25,
      ),
      child: const Text(
        "",
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'LeagueSpartan',
          fontWeight: FontWeight.w600,
          color: Colors.white, // Text color
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(70, 70, 70, 0.918),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    ),
    backgroundColor: Colors.transparent,
    centerTitle: true,
    elevation: 0,
  );
}

// the 'main' of flutter, where are all the widgets are called
class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundContainer(),
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 240, 223, 173),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              // child: _verificationCodeWidget(),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _appBarWidget(),
          ),
        ],
      ),
    );
  }
}

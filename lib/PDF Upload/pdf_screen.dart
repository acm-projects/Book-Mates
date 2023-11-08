import 'package:bookmates_app/PDF%20Upload/pdf_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PDFReaderApp extends StatefulWidget {
  const PDFReaderApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PDFReaderAppState createState() => _PDFReaderAppState();
}

class _PDFReaderAppState extends State<PDFReaderApp> {
  String? selectedPDFPath;
  List<String> recentlyReadPDFs = [];
  final email = FirebaseAuth.instance.currentUser?.email;

  @override
  void initState() {
    super.initState();
  }

  Widget _displayRecentlyRead() {
    // each individual PDF that the user has read before displayed in a list
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users/$email/BookPDFs')
            .orderBy('timeStamp', descending: true) // newest pdf first
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          // get the list of all documents in this snapshot
          var documents = snapshot.data!.docs;

          return ListView.builder(
            // user can only have 5 books at the same time
            itemCount: documents.length > 5 ? 5 : documents.length,
            itemBuilder: (context, index) {
              final pdfPath = documents[index].data()['filePath'];
              final displayTitle = pdfPath.split('/').join().substring(50);
              final display =
                  displayTitle.substring(0, displayTitle.length - 4);

              return Dismissible(
                // the key of each widget
                key: Key(display),

                onDismissed: (direction) async {
                  await FirebaseFirestore.instance
                      .collection('users/$email/BookPDFs')
                      .doc(display)
                      .delete();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10), // Adjust the vertical padding as needed
                  margin: const EdgeInsets.only(
                      bottom:
                          10), // Add margin only to the bottom for vertical spacing
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFF75A10F), // Background color
                    ),
                    child: ListTile(
                      // Bold and white text style
                      title: Text(
                        display,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PDFViewer(pdfPath),
                        ));
                      },
                      // delete specific book from history of books
                      onLongPress: () async {
                        await FirebaseFirestore.instance
                            .collection('users/$email/BookPDFs')
                            .doc(display)
                            .delete();
                      },
                      selectedColor: Colors.lightGreen,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _displayClearHistory() {
    return ElevatedButton(
        onPressed: () async {
          RecentlyRead.clearHistory();
        },
        child: const Text('Clear Books?'));
  }

  Widget _appBarWidget() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.only(
          top: 25,
        ),
        child: const Text(
          "Your Library",
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

  Widget _backgroundContainer() {
    return Container(
      color: const Color(0xFF75A10F),
      height: double.infinity,
    );
  }

  // where all the widgets are placed in the screen
  Widget _home() {
    return Stack(
      children: [
        Column(
          children: [
            _displayRecentlyRead(),
          ],
        ),
        Positioned(
          top: 600,
          right: 0,
          bottom: 0, // Adjust the desired distance from the bottom
          left: -150, // Adjust the desired distance from the left
          child: Transform.scale(
            scale: 0.9, // You can adjust the scale factor as needed
            child: const Image(
              image: AssetImage('icons/worm.png'),
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 0, // Adjust the desired distance from the bottom
          right: 0, // Adjust the desired distance from the right
          child: Container(
            margin: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: pickAndDisplayPDF,
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF75A10F),
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundContainer(),
          Positioned(
            top: 100,
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
              child: _home(),
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

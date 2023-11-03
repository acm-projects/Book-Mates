import 'package:bookmates_app/PDF%20Upload/pdf_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
    _loadRecentlyReadPDFs();
  }

//****************************FUNCTIONALITY******************************* */

  Future<void> _loadRecentlyReadPDFs() async {
    // to render all pdfs read by the user
    final recentPDFs = await RecentlyRead.getRecentlyRead();
    setState(() {
      recentlyReadPDFs = recentPDFs.toList();
    });
  }

  Future<void> pickAndDisplayPDF() async {
    // to update the filepath to view in app
    final pdfPath = await pickPDF();
    final pdfName = pdfPath?.split('/').join();
    final docID = pdfName?.substring(50, pdfName.length - 4);
    final pdfRef =
        FirebaseFirestore.instance.collection('users/$email/BookPDFs');

    await pdfRef.doc(docID).set({
      'filePath': pdfPath, // actual path in user's device to access
      'timeStamp': DateTime.now(), // to be able to store history in order
    });

    if (pdfPath != null) {
      setState(() {
        selectedPDFPath = pdfPath;
      });
    }
  }

  Future<String?> pickPDF() async {
    //sending user to drive to choose file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // only allowing pdfs for now
    );

    if (result != null) {
      return result.files.single.path;
    } else {
      return null;
    }
  }

  Future<void> _clearHistory() async {
    //to clear all recent history of the user
    await RecentlyRead.clearHistory();
    setState(() {
      recentlyReadPDFs = [];
    });
  }

//**********************************WIDGETS**************************** */

  Widget _selectPDF() {
    //choosing a pdf in drive to eventually open
    return ElevatedButton(
        onPressed: pickAndDisplayPDF, child: const Text('Select Book'));
  }

  Widget _displayReadTitle() {
    // the header of the files recently head
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Continue Reading',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _displayRecentlyRead() {
    // each individual PDF that the user has read before displayed in a list
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users/$email/BookPDFs')
            .orderBy('timeStamp',
                descending: true) // Order by timeStamp in descending order
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final PDFPath = documents[index].data()['filePath'];
              final displayTitle = PDFPath.split('/').join().substring(50);
              final display =
                  displayTitle.substring(0, displayTitle.length - 4);
              return ListTile(
                title: Text(display),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PDFViewer(PDFPath),
                  ));
                },
                // delete specific book from history of books
                onLongPress: () async => await FirebaseFirestore.instance
                    .collection('users/$email/BookPDFs')
                    .doc(display)
                    .delete(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _displayClearHistory() {
    return ElevatedButton(
        onPressed: _clearHistory, child: const Text('Clear History?'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Crash Course'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _selectPDF(),
            if (recentlyReadPDFs.isNotEmpty) _displayReadTitle(),
            _displayRecentlyRead(),
            _displayClearHistory(),
          ],
        ),
      ),
    );
  }
}

import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFViewer extends StatelessWidget {
  final String pdfUrl;
  const PDFViewer(this.pdfUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    // Add the PDF to the recently read list.
    RecentlyRead.addRecentlyRead(pdfUrl);

    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
      ),
      body: Center(
        child: PDFView(
          filePath: pdfUrl, //load PDF url
        ),
      ),
    );
  }
}

class RecentlyRead {
  static const _key = 'recently_read_pdfs';

  static Future<Set<String>> getRecentlyRead() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    // get reference to the users PDF library
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users/$email/BookPDFs')
        .get();
    // get every filePath the user has acess to and return it as a set for uniqeness
    Set<String> set = Set<String>();
    for (var doc in querySnapshot.docs) {
      final filePath = doc.data()['filePath'];
      set.add(filePath);
    }

    return set;
  }

  static Future<void> addRecentlyRead(String pdfPath) async {
    final prefs = await SharedPreferences.getInstance();
    final recentList = await getRecentlyRead();
    recentList.add(pdfPath);
    await prefs.setStringList(_key, recentList.toList());
  }

  static Future<void> clearHistory() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    subDelete('users/$email/BookPDFs');
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

Future<void> pickAndDisplayPDF() async {
  // to update the filepath to view in app
  final email = FirebaseAuth.instance.currentUser?.email;
  final pdfPath = await pickPDF();
  final pdfName = pdfPath?.split('/').join();
  final docID = pdfName?.substring(50, pdfName.length - 4);
  final pdfRef = FirebaseFirestore.instance.collection('users/$email/BookPDFs');
  if (pdfPath != null) {
    await pdfRef.doc(docID).set({
      'filePath': pdfPath, // actual path in user's device to access
      'timeStamp': DateTime.now(), // to be able to store history in order
    });
  }
}

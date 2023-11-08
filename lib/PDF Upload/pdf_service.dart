import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

// simple screen to view a PDF
class PDFViewer extends StatelessWidget {
  final String pdfUrl;
  const PDFViewer(this.pdfUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    // Add the PDF to the recently read list.

    return Scaffold(
      body: Center(
        child: PDFView(
          filePath: pdfUrl, //load PDF url
        ),
      ),
    );
  }
}

// to return the filePath of the pdf the user chooses
Future<String?> pickPDF() async {
  //sending user to drive to choose file
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'], // only allow pdfs
  );

  if (result != null) {
    return result.files.single.path;
  } else {
    return null;
  }
}

// to add the pdfPath to user's subcollection called 'BookPDFs'
Future<void> addPDF() async {
  // to update the filepath to view in app
  final email = FirebaseAuth.instance.currentUser?.email;
  // gets the filePath user chose
  final pdfPath = await pickPDF();
  // parses the long filepath into something readable
  final pdfName = pdfPath?.split('/').join();
  final docID = pdfName?.substring(50, pdfName.length - 4);
  final pdfRef = FirebaseFirestore.instance.collection('users/$email/BookPDFs');

  // if user actually chose a file, store the path in Firestore
  if (pdfPath != null) {
    await pdfRef.doc(docID).set({
      'filePath': pdfPath, // actual path in user's device to access
      'timeStamp': DateTime.now(), // to be able to store history in order
    });
  }
}

import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

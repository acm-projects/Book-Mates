import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFViewer extends StatelessWidget {
  final String pdfPath;

  const PDFViewer(this.pdfPath, {super.key});

  @override
  Widget build(BuildContext context) {
    // Add the PDF to the recently read list.
    RecentlyRead.addRecentlyRead(pdfPath);

    return Scaffold(
      //the pdf reading page once you select from your recently read
      appBar: AppBar(
        title: const Text("PDF Viewer"),
      ),
      body: Center(
        child: PDFView(filePath: pdfPath),
      ),
    );
  }
}

class RecentlyRead {
  static const _key = 'recently_read_pdfs';

  static Future<Set<String>> getRecentlyRead() async {
    final prefs = await SharedPreferences.getInstance();
    final pdfs = prefs.getStringList(_key) ?? [];

    return pdfs.toSet();
  }

  static Future<void> addRecentlyRead(String pdfPath) async {
    final prefs = await SharedPreferences.getInstance();
    final recentList = await getRecentlyRead();
    recentList.add(pdfPath);
    await prefs.setStringList(_key, recentList.toList());
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

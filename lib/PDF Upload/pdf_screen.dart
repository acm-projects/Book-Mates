import 'package:bookmates_app/PDF%20Upload/pdf_service.dart';
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

//buttons

  Widget _openPDFInApp() {
    // button to press when opening selected pdf in-app
    return ElevatedButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PDFViewer(selectedPDFPath!),
          ));
          _loadRecentlyReadPDFs(); // rerender recently read after opening
        },
        child: const Text('Open Book'));
  }

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
    // each individual pdf that the user has read before displayed in a list
    return Expanded(
      child: ListView.builder(
        itemCount: recentlyReadPDFs.length,
        itemBuilder: (context, index) {
          final PDFPath = recentlyReadPDFs[index];
          final PDFTitle = PDFPath.split('/').join();
          return ListTile(
              title: Text(PDFTitle.substring(50, PDFTitle.length - 4)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PDFViewer(PDFPath),
                ));
              });
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
            if (selectedPDFPath != null) _openPDFInApp(),
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

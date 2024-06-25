import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:your_app_name/const.dart';
import 'package:your_app_name/scan_view.dart';

import 'scan_desktop.dart';
import 'scan_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Printing"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DesktopScannerView(),
                ));
              },
              icon: const Icon(Icons.document_scanner))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ElevatedButton(
              onPressed: _createPdf,
              child: Text(
                'Create & Print PDF',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _displayPdf,
              child: const Text(
                'Display PDF',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const ElevatedButton(
              onPressed: generatePdf,
              child: Text(
                'Generate Advanced PDF',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// display a pdf document.
  void _displayPdf() {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        clip: true,
        build: (pw.Context context) {
          return pw.Row(children: [
            pw.Text(
              'Ali',
              style: const pw.TextStyle(fontSize: 30),
            ),
          ]);
        },
      ),
    );

    /// open Preview Screen
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(doc: doc),
        ));
  }
}

void _createPdf() async {
  final doc = pw.Document();

  /// for using an image from assets
  // final image = await imageFromAssetBundle('assets/image.png');
  http.Response response = await http.get(Uri.parse(
      'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf'));
  var pdfData = response.bodyBytes;
  // doc.addPage(
  //   pw.Page(
  //     pageFormat: PdfPageFormat.a4,
  //     build: (pw.Context context) {
  //       return pw.Center(
  //         child: pw.Text('Hello eclectify Enthusiast'),
  //       ); // Center
  //     },
  //   ),
  // ); // Page

  /// print the document using the iOS or Android print service:
  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfData);

  /// share the document to other applications:
  // await Printing.sharePdf(bytes: await doc.save(), filename: 'my-document.pdf');

  /// tutorial for using path_provider: https://www.youtube.com/watch?v=fJtFDrjEvE8
  /// save PDF with Flutter library "path_provider":
  // final output = await getTemporaryDirectory();
  // final file = File('${output.path}/example.pdf');
  // await file.writeAsBytes(await doc.save());
}

/// more advanced PDF styling
Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.nunitoExtraLight();

  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Column(
          children: [
            pw.SizedBox(
              width: double.infinity,
              child: pw.FittedBox(
                child: pw.Text(title, style: pw.TextStyle(font: font)),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Flexible(child: pw.FlutterLogo())
          ],
        );
      },
    ),
  );
  return pdf.save();
}

void generatePdf() async {
  const title = 'PDF Demo';
  await Printing.layoutPdf(onLayout: (format) => _generatePdf(format, title));
}

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreen({
    super.key,
    required this.doc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: const Text("Preview"),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: false,
        allowPrinting: true,
        canDebug: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "mydoc.pdf",
      ),
    );
  }
}

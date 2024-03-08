import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieReport extends StatefulWidget {
  @override
  _MovieReportState createState() => _MovieReportState();
}

class _MovieReportState extends State<MovieReport> {
  Map<String, int>? _movieData;
  bool _isLoading = true;
  final GlobalKey _chartKey = GlobalKey();
  late File _pdfFile;

  @override
  void initState() {
    super.initState();
    _fetchMovieData();
  }

  Future<void> _fetchMovieData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final movieData = await ApiService.fetchMovieData();
      setState(() {
        _movieData = movieData;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error here
      print('Error fetching movie data: $error');
    }
  
  }

  bool _isCreatingPdf = false;

  Future<void> _exportToPdf() async {
    setState(() {
      _isCreatingPdf = true;
    });

    try {
      final output = await getApplicationDocumentsDirectory();
      final fileName =
          'movie_sales_${DateTime.now().toString().replaceAll(' ', '_').replaceAll(':', '_')}_report_.pdf';
      final file = File('${output.path}/$fileName');
      final pdf = PdfDocument();
      final page = pdf.pages.add();

      // Dodavanje naslova na stranicu PDF-a
      final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 20);
      final PdfStringFormat titleFormat = PdfStringFormat(
        alignment: PdfTextAlignment.center,
      );
      page.graphics.drawString(
        'BROJ PRODATIH KARATA PO FILMU',
        titleFont,
        bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 40),
        format: titleFormat,
      );

      // Dodavanje datuma kreiranja fajla
      final PdfFont dateFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final DateTime now = DateTime.now();
      final String formattedDate =
          '${now.day}.${now.month}.${now.year}.  ${now.hour}:${now.minute}';
      page.graphics.drawString(
        'Datum i vrijeme kreiranja: $formattedDate',
        dateFont,
        bounds: Rect.fromLTWH(0, 40, page.getClientSize().width, 20),
      );

      // Get the RenderRepaintBoundary object
      RenderRepaintBoundary boundary =
          _chartKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // Convert boundary to image
      ui.Image chartImage = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await chartImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List chartBytes = byteData!.buffer.asUint8List();

      // Draw chart image onto PDF
      final PdfBitmap chartPdfImage = PdfBitmap(chartBytes);
      page.graphics.drawImage(chartPdfImage, Rect.fromLTWH(0, 60, 400, 300));

      // Dodavanje mjesta za potpis i ime odgovorne osobe
      final PdfFont signFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfStringFormat signFormat = PdfStringFormat(
        alignment: PdfTextAlignment.center,
      );
      page.graphics.drawString(
        '___________________________',
        signFont,
        bounds: Rect.fromLTWH(0, page.getClientSize().height - 80,
            page.getClientSize().width, 20),
        format: signFormat,
      );
      page.graphics.drawString(
        'Odgovorno lice',
        signFont,
        bounds: Rect.fromLTWH(0, page.getClientSize().height - 60,
            page.getClientSize().width, 20),
        format: signFormat,
      );

      // Save the PDF
      List<int> pdfBytes = await pdf.save();
      await file.writeAsBytes(pdfBytes);

      // Show snackbar with file creation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF fajl kreiran: $fileName, Lokacija: ${file.path}'),
        ),
      );
    } finally {
      setState(() {
        _isCreatingPdf = false;
      });
    }
  }

  Future<void> _openPdf() async {
    final filePath = _pdfFile.path;
    final fileUrl =
        Platform.isWindows ? filePath.replaceAll('/', '\\') : filePath;
    // ignore: deprecated_member_use
    if (await canLaunch(fileUrl)) {
      // ignore: deprecated_member_use
      await launch(fileUrl);
    } else {
      throw 'Could not launch $fileUrl';
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Sales Report'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _isCreatingPdf ? null : _exportToPdf,
          ),
          // IconButton(
          //   icon: Icon(Icons.folder_open),
          //   onPressed: _openPdf,
          // ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: _isLoading
                ? CircularProgressIndicator()
                : (_movieData == null || _movieData!.isEmpty)
                    ? Text('No data available')
                    : SfCartesianChart(
                        key: _chartKey,
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          ColumnSeries<MapEntry<String, int>, String>(
                            dataSource: _movieData!.entries.toList(),
                            xValueMapper: (entry, _) => entry.key,
                            yValueMapper: (entry, _) => entry.value,
                          ),
                        ],
                      ),
          ),
          if (_isCreatingPdf)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

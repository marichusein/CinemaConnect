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
import 'package:url_launcher/url_launcher_string.dart';

class ZanrReport extends StatefulWidget {
  @override
  _ZanrReportState createState() => _ZanrReportState();
}

class _ZanrReportState extends State<ZanrReport> {
  Map<String, int>? _movieData;
  bool _isLoading = true;
  final GlobalKey _chartKey = GlobalKey();
  late File _pdfFile;
  late int _totalSales;

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
      final movieData = await ApiService.fetchZanrData();
      setState(() {
        _movieData = movieData;
        _totalSales = _calculateTotalSales();
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error here
      print('Error fetching zanr data: $error');
    }
  }

  int _calculateTotalSales() {
    int total = 0;
    _movieData!.values.forEach((value) {
      total += value;
    });
    return total;
  }

  bool _isCreatingPdf = false;

  Future<void> _exportToPdf() async {
    setState(() {
      _isCreatingPdf = true;
    });

    try {
      final output = await getApplicationDocumentsDirectory();
      final fileName =
          'zanr_izvjesta_na_datum_i_vrijeme${DateTime.now().toString().replaceAll(' ', '_').replaceAll(':', '_')}.pdf';
      final file = File('${output.path}/$fileName');
      final pdf = PdfDocument();
      final page = pdf.pages.add();

      // Adding title to the PDF page
      final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 20);
      final PdfStringFormat titleFormat = PdfStringFormat(
        alignment: PdfTextAlignment.center,
      );
      page.graphics.drawString(
        'BROJ PRODATIH KARATA PO ZANRU',
        titleFont,
        bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 40),
        format: titleFormat,
      );

      // Adding creation date of the file
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

      // Adding space for signature and responsible person name
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
      await launchUrlString(fileUrl);
    } else {
      throw 'Could not launch $fileUrl';
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zanr Sales Report'),
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
                    : SfCircularChart(
                        key: _chartKey,
                        series: <CircularSeries>[
                          PieSeries<MapEntry<String, int>, String>(
                            dataSource: _movieData!.entries.toList(),
                            xValueMapper: (entry, _) => entry.key,
                            yValueMapper: (entry, _) => entry.value,
                            dataLabelMapper: (entry, _) =>
                                '${entry.key}: ${(entry.value / _totalSales * 100).toStringAsFixed(2)}%',
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
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

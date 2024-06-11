import 'dart:async';

import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/RezultatSkeniranja.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class QRScannerScreen extends StatefulWidget {
  final Map<String, String> authorizationHeader;

  QRScannerScreen({required this.authorizationHeader});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  TextEditingController idController = TextEditingController();
  final String baseUrl = ApiKonstante.baseUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Skener'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back to the initial screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'Unesite ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? id = idController.text.isNotEmpty ? idController.text : null;
          var response = await http.post(
              Uri.parse('$baseUrl/Rezervacije/PotvrdiUlazakRezervaciju=$id'),
              headers: widget.authorizationHeader);
          if (response.statusCode == 200) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(message: response.body),
              ),
            );
          } else {
            // API poziv nije uspio, prikaži poruku o grešci
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(message: '${response.body}'),
              ),
            );
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }

  StreamSubscription? _subscription;
  bool _apiCallInProgress = false;

  bool _isScanning = true; // Dodaj varijablu za praćenje stanja skeniranja
  bool _showingResultScreen = false;

  void _onQRViewCreated(QRViewController controller) {
    _subscription?.cancel(); // Prekini prethodnu pretplatu, ako postoji
    this.controller = controller;
    _subscription = controller.scannedDataStream.listen((scanData) async {
      if (!_isScanning || _apiCallInProgress || _showingResultScreen) {
        return; // Ako skeniranje nije aktivno, ako je API poziv u tijeku ili ako je rezultat već prikazan, nemoj ponovo pozivati
      }

      _isScanning = false; // Postavi skeniranje na neaktivno

      String id = scanData.code!;
      String apiUrl = '$id'; // Zamijeni s pravim URL-om API-ja

      try {
        var response = await http.post(Uri.parse(apiUrl),
            headers: widget.authorizationHeader);
        if (response.statusCode == 200) {
          // API poziv je uspješan, prikaži odgovor na sljedećem ekranu
          _showingResultScreen =
              true; // Postavi flag da prikažemo rezultat ekrana
          _isScanning = true; // Ponovo omogući skeniranje
          controller.stopCamera(); // Zaustavi kameru
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(message: response.body),
            ),
          ).then((_) {
            // Postavi flag natrag na false nakon povratka s rezultat ekrana
            _showingResultScreen = false;
            // Ponovo pokreni skeniranje QR koda
            controller.resumeCamera();
          });
        } else {
          // API poziv nije uspio, prikaži poruku o grešci
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(message: '${response.body}'),
            ),
          ).then((_) {
            _isScanning = true; // Ponovo omogući skeniranje ako nije uspelo
            controller.resumeCamera();
          });
        }
      } catch (e) {
        // Greška prilikom poziva API-ja, prikaži poruku o grešci
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(message: 'Greška: $e'),
          ),
        );
      } finally {
        _apiCallInProgress = false;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

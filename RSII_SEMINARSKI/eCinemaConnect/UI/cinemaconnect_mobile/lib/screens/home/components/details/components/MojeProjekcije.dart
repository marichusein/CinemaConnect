import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RezervacijeComponent extends StatefulWidget {
  final int userId;
  final Map<String, String> header;

  RezervacijeComponent({required this.userId, required this.header});

  @override
  _RezervacijeComponentState createState() => _RezervacijeComponentState();
}

class _RezervacijeComponentState extends State<RezervacijeComponent> {
  List<dynamic> rezervacije = [];
  final String baseUrl = ApiKonstante.baseUrl;
  bool Aktive=false;
  @override
  void initState() {
    super.initState();
    // Ovdje možete odmah učitati aktivne rezervacije
    _ucitajAktivneRezervacije();
  }

  Future<void> _ucitajAktivneRezervacije() async {
    Aktive=true;
    final response = await http.get(
        Uri.parse('$baseUrl/aktivnebykorisnik/${widget.userId}'),
        headers: widget.header);
    if (response.statusCode == 200) {
      setState(() {
        rezervacije = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load active reservations');
    }
  }

  Future<void> _ucitajNeaktivneRezervacije() async {
    Aktive=false;
    final response = await http.get(
        Uri.parse('$baseUrl/neaktivnebykorisnik/${widget.userId}'),
        headers: widget.header);
    if (response.statusCode == 200) {
      setState(() {
        rezervacije = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load inactive reservations');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vaše rezervacije'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _ucitajAktivneRezervacije,
                child: Text('Aktivne rezervacije'),
              ),
              ElevatedButton(
                onPressed: _ucitajNeaktivneRezervacije,
                child: Text('Neaktivne rezervacije'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rezervacije.length,
              itemBuilder: (context, index) {
                final rezervacija = rezervacije[index];
                return FutureBuilder(
                  future:
                      _dohvatiDetaljeProjekcije(rezervacija['projekcijaId']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final detaljiProjekcije =
                          snapshot.data as Map<String, dynamic>;
                      final datumVrijemeProjekcije =
                          detaljiProjekcije['datumVrijemeProjekcije'] as String;

                      final formattedDateTime = DateFormat('dd.MM.yyyy HH:mm')
                          .format(DateTime.parse(datumVrijemeProjekcije));

                      return ListTile(
                        onTap: () {
                          if(Aktive){
                          _prikaziQRKod(rezervacija['idrezervacije']);
                          }
                          else{
                            _greska();
                          }
                        },
                        leading: Image.memory(
                          base64Decode(detaljiProjekcije['film']['filmPlakat']),
                          width: 50,
                          height: 50,
                        ),
                        title: Text(detaljiProjekcije['film']['nazivFilma']),
                        subtitle: Text(
                          'Vrijeme i mjesto održavanja: $formattedDateTime - ${detaljiProjekcije['sala']['nazivSale']}',
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _prikaziQRKod(int projekcijaId) {
    String qrData =
        '$baseUrl/Rezervacije/PotvrdiUlazakRezervaciju=$projekcijaId'; 
    QrImageView qrCodeWidget = QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: 200.0,
    );
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      'Vaš QR kod za rezervaciju - u slučaju greške na aparatu Vaš jedinstevni broj rezervacije je $projekcijaId'),
                ),
                qrCodeWidget, // Ovdje se prikazuje QR kod
                TextButton(
                  onPressed: () {
                     Navigator.of(context).pop();
                  },
                  child: Text('Zatvori'),
                ),
              ],
            ),
          );
        },
      );
  }

  void _greska() {
    
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                      'Vrijeme prikzaivanja projekcije za vašu rezravciju je isteklo!'),
                ),
                TextButton(
                  onPressed: () {
                     Navigator.of(context).pop();
                  },
                  child: Text('Zatvori'),
                ),
              ],
            ),
          );
        },
      );
  }

  Future<Map<String, dynamic>> _dohvatiDetaljeProjekcije(
      int projekcijaId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/Projekcije/$projekcijaId'),
        headers: widget.header);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load projection details');
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:cinemaconnect_mobile/components/home_screen.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/ErrorPagePaypal.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/PaypalCancelPage.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/Rezervacija.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GrickaliceMenu extends StatefulWidget {
  final int KorisnikID;
  final List<SelektovanoSjediste> selektovanaSjedista;
  final int odabranaProjekcija;
  final double Cijena;
  final Map<String, String> header;

  const GrickaliceMenu(
      {super.key,
      required this.KorisnikID,
      required this.selektovanaSjedista,
      required this.odabranaProjekcija,
      required this.Cijena,
      required this.header});
  @override
  _GrickaliceMenuState createState() => _GrickaliceMenuState();
}

class _GrickaliceMenuState extends State<GrickaliceMenu> {
  List<Map<String, dynamic>> grickalice = [];
  int selectedItemId = 0;

  @override
  void initState() {
    super.initState();
    fetchGrickaliceMenu();
  }

  Future<void> fetchGrickaliceMenu() async {
    final String baseUrl = ApiKonstante.baseUrl;
    final response = await http.get(Uri.parse('$baseUrl/MeniGrickalica'),
        headers: widget.header);

    if (response.statusCode == 200) {
      setState(() {
        List<dynamic> grickaliceJson = json.decode(response.body);
        grickalice = grickaliceJson.cast<Map<String, dynamic>>().toList();
      });
    } else {
      throw Exception('Failed to load grickalice');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meni grickalica'),
      ),
      body: ListView.builder(
        itemCount: grickalice.length,
        itemBuilder: (context, index) {
          final grickalica = grickalice[index];
          final isSelected = selectedItemId == grickalica['idgrickalice'];

          return ListTile(
            onTap: () {
              setState(() {
                selectedItemId = grickalica['idgrickalice'];
              });
            },
            title: Text(grickalica['naziv']),
            subtitle: Text(grickalica['opis']),
            leading: Image.memory(
              base64Decode(grickalica['slika']),
              width: 60,
              height: 60,
            ),
            tileColor: isSelected ? Colors.blue : Colors.white,
          );
        },
      ),
      // ignore: unnecessary_null_comparison
      floatingActionButton: selectedItemId != null
          ? FloatingActionButton(
              onPressed: () async {
                // ignore: unnecessary_null_comparison
                if (selectedItemId != null) {
                  await startPayPalPayment();
                  ;
                  // Prvo stvorite objekt koji ćete poslati na server
                }
              },
              child: Icon(Icons.check),
            )
          : null,
    );
  }

  String paymentId = "";
  bool cancel = false;

  Future<void> startPayPalPayment() async {
    var completer = Completer<bool>();

    await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => UsePaypal(
        sandboxMode: true,
        clientId:
            "AWwW3Fuc0nmtIMp4pDMuZk5jBT-bw5xRHHKF8pgipgSp_89Tz97GLMSDwohCVDOHvglzOmLAQ2c7j-N-",
        secretKey:
            "EBIHrq8vvGtHPUNtvV0VQchBEXLApqQ32GWbed50JwqAjgg5wANsR7pejsI-zINuvRRsATHhbeySz9fv",
        returnURL: "https://samplesite.com/return",
        cancelURL: "https://samplesite.com/cancel",
        transactions: [
          {
            "amount": {
              "total": double.parse((widget.Cijena*0.55).toStringAsFixed(2)), // Promijenite ovo s vašim ukupnim iznosom
              "currency": "USD",
            },
            "description": "Payment for reservation #your_reservation_id.",
            "item_list": {
              "items": [
                {
                  "name": "Cijena",
                  "quantity": 1,
                  "price": double.parse((widget.Cijena*0.55).toStringAsFixed(2)), // Promijenite ovo s cijenom vašeg artikla
                  "currency": "USD"
                }
              ],
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          print("onSuccess: $params");
          paymentId = params['paymentId'];
          completer.complete(true);
        },
        onError: (error) {
          print("onError: $error");
          completer.complete(false);
        },
        onCancel: (params) {
          print('c a n c e l l e d: $params');
          this.cancel = true;
        },
      ),
    ));

    final result = await completer.future;
    if (cancel) {
      // ignore: use_build_context_synchronously
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CancelledPage(
            korisnikID: widget.KorisnikID,
            header: widget.header,
          ),
        ),
      );
    }
    if (result) {
      await saveReservation(context);
    } else {
      // ignore: use_build_context_synchronously
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorPage(
            korisnikID: widget.KorisnikID,
            header: widget.header,
          ),
        ),
      );
    }
  }

// Ova funkcija treba biti dio vašeg Stateful widget-a ili neke druge klase
  Future<void> saveReservation(BuildContext context) async {
    final rezervacijaObj = {
      "korisnikId": widget.KorisnikID,
      "projekcijaId": widget.odabranaProjekcija,
      "brojRezervisanihKarata": widget.selektovanaSjedista.length,
      "kupljeno": true,
      "qrCode": paymentId, // PaymentID je ovo
      "odabranaSjedista": widget.selektovanaSjedista
          .map((sjediste) => {
                "idsjedista": sjediste.idsjedista,
                "brojSjedista": sjediste.brojSjedista,
                "slobodno": sjediste.slobodno,
              })
          .toList(),
      "meniGrickalica": selectedItemId,
    };
    final String baseUrl = ApiKonstante.baseUrl;

    // Zatim pošaljite objekt na odgovarajući URL endpoint
    final response = await http.post(
      Uri.parse('$baseUrl/Rezervacije'),
      headers: widget.header,
      body: jsonEncode(rezervacijaObj),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      int idrezervacije = responseJson['idrezervacije'];

      // Ispis idrezervacije
      print('idrezervacije: $idrezervacije');
      // Ako je zahtjev uspješno izvršen, prikažite QR kod u dijalogu
      String reservationCode =
          '$baseUrl/Rezervacije/PotvrdiUlazakRezervaciju=$idrezervacije'; // Generirajte jedinstveni kod ovdje

      // Generirajte QR kod
      QrImageView qrCodeWidget = QrImageView(
        data: reservationCode,
        version: QrVersions.auto,
        size: 200.0,
      );

      // ignore: use_build_context_synchronously
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
                      'Vaš QR kod za rezervaciju - u slučaju greške na aparatu Vaš jedinstevni broj rezervacije je $idrezervacije'),
                ),
                qrCodeWidget, // Ovdje se prikazuje QR kod
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Zatvori dijalog
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          userId: widget.KorisnikID,
                          header: widget.header,
                        ),
                      ),
                    ); // Redirekcija na HomeScreen
                  },
                  child: Text('Zatvori'),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Ako zahtjev nije uspio, obradite odgovarajuću grešku
      throw Exception('Failed to create reservation');
    }
  }
}

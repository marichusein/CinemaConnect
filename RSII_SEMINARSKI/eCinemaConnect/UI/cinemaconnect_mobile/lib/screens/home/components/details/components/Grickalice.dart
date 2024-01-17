import 'dart:convert';
import 'package:cinemaconnect_mobile/components/home_screen.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/Rezervacija.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GrickaliceMenu extends StatefulWidget {
  final int KorisnikID;
  final List<SelektovanoSjediste> selektovanaSjedista;
  final int odabranaProjekcija;

  const GrickaliceMenu(
      {super.key, required this.KorisnikID, required this.selektovanaSjedista, required this.odabranaProjekcija});
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
    final response =
        await http.get(Uri.parse('https://localhost:7036/MeniGrickalica'));

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
    // Prvo stvorite objekt koji ćete poslati na server
    final rezervacijaObj = {
      "korisnikId": widget.KorisnikID,
      "projekcijaId": widget.odabranaProjekcija,
      "brojRezervisanihKarata": widget.selektovanaSjedista.length,
      "kupljeno": true,
      "qrCode": "string",
      "odabranaSjedista": widget.selektovanaSjedista.map((sjediste) => {
        "idsjedista": sjediste.idsjedista,
        "brojSjedista": sjediste.brojSjedista,
        "slobodno": sjediste.slobodno,
      }).toList(),
      "meniGrickalica": selectedItemId,
    };

    // Zatim pošaljite objekt na odgovarajući URL endpoint
    final response = await http.post(
      Uri.parse('https://localhost:7036/Rezervacije'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(rezervacijaObj),
    );

    if (response.statusCode == 200) {
      // Ako je zahtjev uspješno izvršen, navigirajte na HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(userId: widget.KorisnikID,),
        ),
      );
    } else {
      // Ako zahtjev nije uspio, obradite odgovarajuću grešku
      throw Exception('Failed to create reservation');
    }
  }
},

              child: Icon(Icons.check),
            )
          : null,
    );
  }
}

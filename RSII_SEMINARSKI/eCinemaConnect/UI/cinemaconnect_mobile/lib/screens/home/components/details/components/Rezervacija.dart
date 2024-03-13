import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/Grickalice.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ProjekcijeSjedistaKomponenta extends StatefulWidget {
  final int filmId;
  final int korisnikID;
  final Map<String, String> header;
  String NazivFilma;

  ProjekcijeSjedistaKomponenta(
      {required this.filmId,
      Key? key,
      required this.korisnikID,
      required this.header,
      required this.NazivFilma})
      : super(key: key);

  @override
  _ProjekcijeSjedistaKomponentaState createState() =>
      _ProjekcijeSjedistaKomponentaState();
}

class SelektovanoSjediste {
  final int idsjedista;
  final int brojSjedista;
  final bool slobodno;

  SelektovanoSjediste({
    required this.idsjedista,
    required this.brojSjedista,
    required this.slobodno,
  });
}

class _ProjekcijeSjedistaKomponentaState
    extends State<ProjekcijeSjedistaKomponenta> {
  List<Map<String, dynamic>> projekcije = [];
  List<Map<String, dynamic>> sjedista = [];
  List<SelektovanoSjediste> selektovanaSjedista = [];
  late String datumVrijemeProjekcije;
  late int brojSale;
  double cijenaProjekcija = 0;
  int idprojekcije = 0;
  @override
  void initState() {
    super.initState();
    // Dohvat projekcija za odabrani film prilikom inicijalizacije komponente
    fetchProjekcije(widget.filmId);
  }

  // Funkcija za dohvat dostupnih projekcija na temelju ID filma
  Future<void> fetchProjekcije(int filmId) async {
    final String baseUrl = ApiKonstante.baseUrl;
    final response = await http.get(
        Uri.parse('$baseUrl/Projekcije/film/aktivne/$filmId'),
        headers: widget.header);

    if (response.statusCode == 200) {
      setState(() {
         
        projekcije = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    }
  }

  // Funkcija za dohvat dostupnih sjedišta na temelju odabrane projekcije
  Future<void> fetchSjedista(int projekcijaId) async {
    final String baseUrl = ApiKonstante.baseUrl;
    final response = await http.get(
        Uri.parse('$baseUrl/Projekcije/sjedista/$projekcijaId'),
        headers: widget.header);

    if (response.statusCode == 200) {
      setState(() {
        sjedista = List<Map<String, dynamic>>.from(jsonDecode(response.body));
       
        //brojSale=jsonDecode(response.body)['datumVrijemeProjekcije'];
        //datumVrijemeProjekcije=jsonDecode(response.body)['sala']['idsale'];

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Odaberi projekciju i sjedište'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Prikaz dostupnih projekcija
            if (projekcije.isNotEmpty)
              Column(
                children: [
                  Text('Dostupne projekcije:'),
                  for (var projekcija in projekcije)
                    ListTile(
                      title: Text(
                        DateFormat('dd.MM.yy HH:mm').format(DateTime.parse(
                            projekcija['datumVrijemeProjekcije'])),
                      ),
                      subtitle: Text('Cijena: ${projekcija['cijenaKarte']}'),
                      onTap: () {
                        print('Detalji odabrane projekcije: ${projekcija['sala']['idsale']}');
                        fetchSjedista(projekcija['idprojekcije']);
                        cijenaProjekcija = projekcija['cijenaKarte'];
                        idprojekcije = projekcija[
                            'idprojekcije'];
                            datumVrijemeProjekcije=projekcija['datumVrijemeProjekcije'];
                            brojSale=projekcija['sala']['idsale']; // Dohvati sjedišta za odabranu projekciju
                      },
                    ),
                ],
              ),
            // Prikaz sjedišta
            if (sjedista.isNotEmpty)
              Column(
                children: [
                  Wrap(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color:
                              Colors.green, // Zelena boja za slobodna sjedišta
                          borderRadius:
                              BorderRadius.circular(10), // Dodajte zaobljenje
                        ),
                        child: Center(
                          child: Text(
                            'Slobodno',
                            style: TextStyle(
                                color: Colors.white, // Boja teksta
                                fontWeight: FontWeight.bold,
                                fontSize: 10 // Debljina teksta
                                ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey, // Siva boja za zauzeta sjedišta
                          borderRadius:
                              BorderRadius.circular(10), // Dodajte zaobljenje
                        ),
                        child: Center(
                          child: Text(
                            'Zauzeto',
                            style: TextStyle(
                                color: Colors.black, // Boja teksta
                                fontWeight: FontWeight.bold,
                                fontSize: 10 // Debljina teksta
                                ),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color:
                              Colors.yellow, // Žuta boja za označena sjedišta
                          borderRadius:
                              BorderRadius.circular(10), // Dodajte zaobljenje
                        ),
                        child: Center(
                          child: Text(
                            'Označeno',
                            style: TextStyle(
                                color: Colors.black, // Boja teksta
                                fontWeight: FontWeight.bold,
                                fontSize: 10 // Debljina teksta
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Razmak između legende i sjedišta
                  // Organizacija sjedišta u 4 reda i 5 stupaca (4x5)
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/images/platno.png', // Zamijenite 'your_image.png' s putanjom do svoje slike u asetu
                    width: double
                        .infinity, // Postavite širinu slike na punu širinu ekrana
                    fit: BoxFit.contain, // Prilagodite sliku širini ekrana
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    children: List.generate(sjedista.length, (index) {
                      final sjediste = sjedista[index];
                      final int idsjedista = sjediste['idsjedista'].toInt();
                      final int brojSjedista =
                          sjediste['brojSjedista'].toInt();

                      return GestureDetector(
                        onTap: () {
                          if (sjediste['slobodno'] &&
                              selektovanaSjedista.length < 20) {
                            setState(() {
                              selektovanaSjedista.add(SelektovanoSjediste(
                                idsjedista: idsjedista,
                                brojSjedista: brojSjedista,
                                slobodno: false,
                              ));
                              sjediste['slobodno'] = false;
                            });
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: sjediste['slobodno']
                                ? Colors
                                    .green // Zelena boja za slobodna sjedišta
                                : selektovanaSjedista
                                        .contains(idsjedista)
                                    ? Colors
                                        .yellow // Žuta boja za označena sjedišta
                                    : Colors
                                        .grey, // Siva boja za zauzeta sjedišta
                            borderRadius:
                                BorderRadius.circular(10), // Dodajte zaobljenje
                          ),
                          child: Center(
                            child: Text(
                              brojSjedista.toString(),
                              style: TextStyle(
                                color: sjediste['slobodno']
                                    ? Colors.white
                                    : Colors.black, // Boja teksta
                                fontWeight: FontWeight.bold, // Debljina teksta
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  Text(
                      'Broj označenih sjedišta: ${selektovanaSjedista.length}'),
                  Text(
                      'Cijena ukupna ${selektovanaSjedista.length * cijenaProjekcija} KM'),
                  Text("----"),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GrickaliceMenu(
                            KorisnikID: widget.korisnikID,
                            selektovanaSjedista: selektovanaSjedista,
                            odabranaProjekcija: idprojekcije,
                            Cijena:
                                selektovanaSjedista.length * cijenaProjekcija,
                            header: widget.header,
                            NazivFilma: widget.NazivFilma,
                            brojSale: brojSale,
                            datumVrijemeProjekcije: datumVrijemeProjekcije,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green, // Postavite boju pozadine na zelenu
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Postavite zaobljenje gumba
                      ),
                    ),
                    child: Text(
                      'Nastavi',
                      style: TextStyle(
                        color: Colors.white, // Postavite boju teksta na bijelu
                        fontWeight: FontWeight.bold, // Debljina teksta
                      ),
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}

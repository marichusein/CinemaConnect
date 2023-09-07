import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DodavanjeProjekcijeScreen(),
    );
  }
}

class DodavanjeProjekcijeScreen extends StatefulWidget {
  @override
  _DodavanjeProjekcijeScreenState createState() =>
      _DodavanjeProjekcijeScreenState();
}

class Sala {
  final int idsale;
  final String nazivSale;

  Sala({required this.idsale, required this.nazivSale});

  factory Sala.fromJson(Map<String, dynamic> json) {
    return Sala(
      idsale: json['idsale'],
      nazivSale: json['nazivSale'],
    );
  }
}

class Film {
  final int idfilma;
  final String nazivFilma;
  final String filmPlakat;

  Film(
      {required this.idfilma,
      required this.nazivFilma,
      required this.filmPlakat});

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      idfilma: json['idfilma'],
      nazivFilma: json['nazivFilma'],
      filmPlakat: json['filmPlakat'],
    );
  }
}

class _DodavanjeProjekcijeScreenState extends State<DodavanjeProjekcijeScreen> {
  int? selectedFilmId;
  int? selectedSalaId;
  List<Film> filmovi = [];
  List<Sala> sale = [];
  String plakatFilma = "assets/noPhoto.jpg";

  final TextEditingController datumController = TextEditingController();
  final TextEditingController cijenaController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Preuzimanje filmova i sala sa stvarnih API-ja
    preuzmiFilmove();
    preuzmiSale();
  }

  Future<void> preuzmiFilmove() async {
    final response =
        await http.get(Uri.parse('https://localhost:7036/Filmovi'));

    if (response.statusCode == 200) {
      final List<dynamic> filmoviData = json.decode(response.body);
      final List<Film> parsedFilmovi =
          filmoviData.map((item) => Film.fromJson(item)).toList();

      setState(() {
        filmovi = parsedFilmovi;
      });
    }
  }

  Future<void> preuzmiSale() async {
    final response = await http.get(Uri.parse('https://localhost:7036/Sale'));

    if (response.statusCode == 200) {
      final List<dynamic> saleData = json.decode(response.body);
      final List<Sala> parsedSale =
          saleData.map((item) => Sala.fromJson(item)).toList();

      setState(() {
        sale = parsedSale;
      });
    }
  }

  void dodajProjekciju() {
    final novaProjekcija = {
      "filmId": selectedFilmId,
      "salaId": selectedSalaId,
      "datumVrijemeProjekcije": datumController.text,
      "cijenaKarte": int.parse(cijenaController.text),
    };

    // Simulirajte slanje podataka na API za dodavanje projekcije
    // Ovdje trebate implementirati stvarnu logiku za slanje podataka na API

    // Nakon uspješnog dodavanja projekcije
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Projekcija uspješno dodana!'),
      ),
    );

    // Ispričavanje polja forme
    setState(() {
      selectedFilmId = null;
      selectedSalaId = null;
      datumController.clear();
      cijenaController.clear();
      plakatFilma = "assets/noPhoto.jpg";
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 1),
    ))!;
    if (picked != null && picked != DateTime.now()) {
      datumController.text = picked.toLocal().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Dodavanje Nove Projekcije'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Dropdown za odabir filma
              DropdownButtonFormField<int>(
                value: selectedFilmId,
                onChanged: (newValue) {
                  setState(() {
                    selectedFilmId = newValue;
                    // Pronađi plakat filma na temelju odabranog ID-a filma
                    final selectedFilm =
                        filmovi.firstWhere((film) => film.idfilma == newValue);
                    plakatFilma =
                        selectedFilm.filmPlakat ?? "assets/noPhoto.jpg";
                  });
                },
                items: filmovi.map<DropdownMenuItem<int>>((film) {
                  return DropdownMenuItem<int>(
                    value: film.idfilma,
                    child: Text(film.nazivFilma),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Film'),
              ),

              // Dropdown za odabir sale
              DropdownButtonFormField<int>(
                value: selectedSalaId,
                onChanged: (newValue) {
                  setState(() {
                    selectedSalaId = newValue;
                  });
                },
                items: sale.map<DropdownMenuItem<int>>((sala) {
                  return DropdownMenuItem<int>(
                    value: sala.idsale,
                    child: Text(sala.nazivSale),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Sala'),
              ),

              // Unos datuma
              TextFormField(
                controller: datumController,
                decoration: InputDecoration(
                  labelText: 'Datum i vrijeme projekcije',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
              ),

              // Unos cijene
              TextFormField(
                controller: cijenaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cijena karte',
                  suffixIcon: Icon(Icons.attach_money),
                ),
              ),

              // Gumb za dodavanje projekcije
              ElevatedButton(
                onPressed: dodajProjekciju,
                child: Text('Dodaj Projekciju'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

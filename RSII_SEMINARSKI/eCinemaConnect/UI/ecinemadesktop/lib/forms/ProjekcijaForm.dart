// ignore_for_file: unnecessary_null_comparison

import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  late DateTime pickedDateTimef;
  final TextEditingController pretragaController = TextEditingController();

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
    try {
      List<dynamic> filmoviData = await ApiService.preuzmiFilmove();
      setState(() {
        filmovi = filmoviData.map((item) => Film.fromJson(item)).toList();
      });
    } catch (error) {
      print('Greška prilikom preuzimanja filmova: $error');
    }
  }

  Future<void> preuzmiSale() async {
    try {
      List<dynamic> saleData = await ApiService.preuzmiSale();
      setState(() {
        sale = saleData.map((item) => Sala.fromJson(item)).toList();
      });
    } catch (error) {
      print('Greška prilikom preuzimanja sala: $error');
    }
  }

  void dodajProjekciju() async {
    if (selectedFilmId == null ||
        selectedSalaId == null ||
        datumController.text.isEmpty ||
        cijenaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sva polja su obavezna!'),
        ),
      );
      return;
    }

    final formattedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(pickedDateTimef);

// Sada možete koristiti formattedDate u vašem zahtjevu
    final novaProjekcija = {
      "filmId": selectedFilmId,
      "salaId": selectedSalaId,
      "datumVrijemeProjekcije": formattedDate,
      "cijenaKarte": int.parse(cijenaController.text),
    };

    // Konvertirajte podatke u JSON format
    try {
      await ApiService.dodajProjekciju(novaProjekcija);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Projekcija uspješno dodana!'),
        ),
      );

      setState(() {
        selectedFilmId = null;
        selectedSalaId = null;
        datumController.clear();
        cijenaController.clear();
        plakatFilma = "assets/noPhoto.jpg";
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška prilikom dodavanja projekcije: $error'),
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 1),
    ))!;

    if (pickedDate != null) {
      final TimeOfDay pickedTime = (await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      ))!;

      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        datumController.text = pickedDateTime.toLocal().toString();
        pickedDateTimef = pickedDateTime.toLocal();
      }
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
              TextField(
                controller: pretragaController,
                onChanged: (value) {
                  setState(
                      () {}); // Ovdje ćemo osvježiti widget kako bismo primijenili filtriranje
                },
                decoration: InputDecoration(
                  labelText: 'Pretraži film',
                  prefixIcon: Icon(Icons.search),
                ),
              ),

// Dropdown za odabir filma
              DropdownButtonFormField<int>(
                value: selectedFilmId,
                onChanged: (newValue) {
                  setState(() {
                    selectedFilmId = newValue;
                    // Pronađi plakat filma na temelju odabranog ID-a filma
                    final selectedFilm =
                        filmovi.firstWhere((film) => film.idfilma == newValue);
                    plakatFilma = selectedFilm.filmPlakat;
                  });
                },
                items: filmovi
                    .where((film) => film.nazivFilma
                        .toLowerCase()
                        .contains(pretragaController.text.toLowerCase()))
                    .map<DropdownMenuItem<int>>((film) {
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
              // Unos datuma
              TextFormField(
                controller: datumController,
                readOnly: true, // Onemogućuje uređivanje teksta ručno
                onTap: () {
                  _selectDate(
                      context); // Otvori DateTime picker pritiskom na polje
                },
                decoration: InputDecoration(
                  labelText: 'Datum i vrijeme projekcije',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(
                          context); // Otvori DateTime picker pritiskom na ikonu
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Datum i vrijeme su obavezni!';
                  }
                  return null;
                },
              ),

              // Unos cijene
              TextFormField(
                controller: cijenaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cijena karte',
                  suffixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Cijena karte je obavezna!';
                  }
                  final cijena = int.tryParse(value);
                  if (cijena == null) {
                    return 'Unesite ispravan broj za cijenu!';
                  } else if (cijena < 1 || cijena > 20) {
                    return 'Cijena karte mora biti broj između 1 i 20!';
                  }
                  return null;
                },
              ),

              // Gumb za dodavanje projekcije
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0), // Dodajemo razmak iznad gumba
                child: ElevatedButton(
                  onPressed: dodajProjekciju,
                  child: Text('Dodaj Projekciju'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

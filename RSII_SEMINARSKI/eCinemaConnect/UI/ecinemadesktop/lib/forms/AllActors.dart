import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GlumciScreen(),
    );
  }
}

class GlumciScreen extends StatefulWidget {
  @override
  _GlumciScreenState createState() => _GlumciScreenState();
}

class _GlumciScreenState extends State<GlumciScreen> {
  List<Glumac> glumci = [];
  List<Glumac> filteredGlumci = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController editImeController = TextEditingController();
  TextEditingController editPrezimeController = TextEditingController();
  int selectedGlumacId = -1;

  @override
  void initState() {
    super.initState();
    fetchGlumci();
  }

  Future<void> fetchGlumci() async {
    try {
      final fetchedGlumci = await ApiService.fetchGlumci();
      setState(() {
        glumci = fetchedGlumci;
        filteredGlumci = glumci;
      });
    } catch (error) {
      print('Error fetching glumci: $error');
    }
  }

  void filterGlumci(String query) {
    setState(() {
      filteredGlumci = glumci.where((glumac) {
        final imePrezime = '${glumac.ime} ${glumac.prezime}'.toLowerCase();
        return imePrezime.contains(query.toLowerCase());
      }).toList();
    });
  }

  void showEditDialog(int id) {
    final selectedGlumac = glumci.firstWhere((glumac) => glumac.id == id);
    selectedGlumacId = id;
    editImeController.text = selectedGlumac.ime;
    editPrezimeController.text = selectedGlumac.prezime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uredi glumca'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editImeController,
                decoration: InputDecoration(labelText: 'Ime'),
              ),
              TextField(
                controller: editPrezimeController,
                decoration: InputDecoration(labelText: 'Prezime'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Otkaži'),
            ),
            TextButton(
              onPressed: () {
                updateGlumac(selectedGlumacId);
                Navigator.of(context).pop();
              },
              child: Text('Spremi'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateGlumac(int id) async {
    final selectedGlumac = glumci.firstWhere((glumac) => glumac.id == id);
    final ime = editImeController.text;
    final prezime = editPrezimeController.text;

    try {
      await ApiService.updateGlumac(id, ime, prezime);

      setState(() {
        selectedGlumac.ime = ime;
        selectedGlumac.prezime = prezime;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Podaci o glumcu su ažurirani!'),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Greška prilikom ažuriranja podataka o glumcu: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Glumci'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterGlumci(value);
              },
              decoration: InputDecoration(
                labelText: 'Pretraži glumce',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Broj kartica u redu
                crossAxisSpacing: 16.0, // Razmak između kartica po horizontali
                mainAxisSpacing: 16.0, // Razmak između kartica po vertikali
                childAspectRatio:
                    5 / 3, // Omjer širine i visine kartice (50% visine)
              ),
              itemCount: filteredGlumci.length,
              itemBuilder: (context, index) {
                final glumac = filteredGlumci[index];
                return GestureDetector(
                  onTap: () {
                    showEditDialog(glumac.id);
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.memory(
                          glumac.slika.isNotEmpty
                              ? base64Decode(glumac.slika)
                              : base64Decode(base64Encode(Uint8List.fromList(File(
                                      'assets/noPhoto.jpg')
                                  .readAsBytesSync()))), // Putanja zamjenske slike
                          width: 150, // Povećana širina slike
                          height: 150, // Povećana visina slike
                        ),
                        SizedBox(height: 8.0), // Razmak između slike i teksta
                        Text(
                          '${glumac.ime} ${glumac.prezime}',
                          style: TextStyle(
                            fontSize: 18.0, // Povećana veličina teksta
                            fontWeight: FontWeight.bold, // Boldirani tekst
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

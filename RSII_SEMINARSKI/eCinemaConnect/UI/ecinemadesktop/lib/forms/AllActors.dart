import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GlumciScreen(),
    );
  }
}

class Glumac {
  final int id;
  String ime;
  String prezime;
  final String slika; // Promenljiva za sliku koja može biti null

  Glumac({required this.id, required this.ime, required this.prezime, required this.slika});
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
    final response = await http.get(Uri.parse('https://localhost:7036/Glumci'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      setState(() {
        glumci = jsonData.map((data) => Glumac(
          id: data['idglumca'],
          ime: data['ime'],
          prezime: data['prezime'],
          slika: data['slika'],
        )).toList();
        filteredGlumci = glumci;
      });
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
    final url = 'https://localhost:7036/Glumci/$id';

    final Map<String, String> headers = {
      'accept': 'text/plain',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'ime': editImeController.text,
      'prezime': editPrezimeController.text,
    };

    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      setState(() {
        selectedGlumac.ime = editImeController.text;
        selectedGlumac.prezime = editPrezimeController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Podaci o glumcu su ažurirani!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Došlo je do greške prilikom ažuriranja podataka o glumcu.'),
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filteredGlumci.length,
              itemBuilder: (context, index) {
                final glumac = filteredGlumci[index];
                return GestureDetector(
                  onTap: () {
                    showEditDialog(glumac.id);
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.memory(
  glumac.slika.isNotEmpty
      ? base64Decode(glumac.slika)
      : base64Decode(base64Encode(Uint8List.fromList(
          File('assets/noPhoto.jpg')
              .readAsBytesSync()))), // Putanja zamjenske slike
  width: 100,
  height: 100,
),
                        Text('${glumac.ime} ${glumac.prezime}'),
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

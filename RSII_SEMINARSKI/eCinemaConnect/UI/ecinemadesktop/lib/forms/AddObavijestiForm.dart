import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Obavijest Forma',
      home: ObavijestForm(korisnikId: 123), // Postavite stvaran korisnikId ovde
    );
  }
}

class ObavijestForm extends StatefulWidget {
  final int korisnikId;

  ObavijestForm({required this.korisnikId});

  @override
  _ObavijestFormState createState() => _ObavijestFormState();
}

class _ObavijestFormState extends State<ObavijestForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String naslov = '';
  String sadrzaj = '';
  XFile? selectedImage;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Forma je validna, možemo slati obavijest na server

      // Konvertujemo izabranu sliku u Base64 format
      String base64Image = '';
      if (selectedImage != null) {
        List<int> imageBytes = await selectedImage!.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      // Slanje obavijesti na server
      final response = await http.post(
        Uri.parse('https://localhost:7125/Obavijesti'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'korisnikId': widget.korisnikId,
          'naslov': naslov,
          'sadrzaj': sadrzaj,
          'datumObjave': DateTime.now().toIso8601String(),
          'slika': base64Image,
          'datumUredjivanja': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        // Obavijest je uspješno poslata
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Obavijest uspješno poslata')),
        );

        // Očistite formu
        _formKey.currentState!.reset();
        setState(() {
          selectedImage = null;
        });
      } else {
        // Greška prilikom slanja obavijesti
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Greška prilikom slanja obavijesti')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Obavijest Forma'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text('Korisnik ID: ${widget.korisnikId}'), // Prikaz korisnik ID
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Naslov',
                  prefixIcon: Icon(Icons.title), // Ikona za naslov
                ),
                onChanged: (value) {
                  setState(() {
                    naslov = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite naslov';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Sadržaj',
                  prefixIcon: Icon(Icons.description), // Ikona za sadržaj
                ),
                onChanged: (value) {
                  setState(() {
                    sadrzaj = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite sadržaj';
                  }
                  if (value.length > 2000) {
                    return 'Sadržaj može imati najviše 2000 karaktera';
                  }
                  return null;
                },
                maxLines: null, // Omogućava višelinijski unos
              ),
             ButtonBar( // Dodavanje dugmadi u horizontalnom redu
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _pickImage, // Dodavanje slike
                    child: Text('Dodaj sliku'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Pošalji obavijest'),
                  ),
                ],
              ),
              if (selectedImage != null)
                Image.file(
                  File(selectedImage!.path),
                  width: 300,
                  height: 300,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

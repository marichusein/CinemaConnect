import 'dart:io';
import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
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
      // Konvertujemo izabranu sliku u Base64 format
      String base64Image = '';
      if (selectedImage != null) {
        List<int> imageBytes = await selectedImage!.readAsBytes();
        base64Image = base64Encode(imageBytes);
      } else {
        // Prikažite poruku greške ako slika nije izabrana
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Molimo izaberite sliku')),
        );
        return;
      }

      try {
        await ApiService.posaljiObavijest(widget.korisnikId, naslov, sadrzaj, base64Image);

        // Obavijest je uspješno poslata
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Obavijest uspješno poslata')),
        );

        // Očistite formu
        _formKey.currentState!.reset();
        setState(() {
          selectedImage = null;
        });
      } catch (error) {
        // Greška prilikom slanja obavijesti
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Greška prilikom slanja obavijesti: $error')),
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
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Naslov',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
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
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Sadržaj',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
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
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Dodaj sliku'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 16.0),
                ),
              ),
              SizedBox(height: 16.0),
              selectedImage == null
                  ? Container(
                      height: 200.0,
                      width: 400.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          'Ovdje će se prikazati vaša slika kada je odaberete. Preporuka je da slika bude landscape formatu.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Image.file(
                      File(selectedImage!.path),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Pošalji obavijest'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

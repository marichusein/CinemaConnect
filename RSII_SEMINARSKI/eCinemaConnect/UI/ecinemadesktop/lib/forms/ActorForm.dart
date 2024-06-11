import 'dart:convert';
import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ActorForm extends StatefulWidget {
  @override
  _ActorFormState createState() => _ActorFormState();
}

class _ActorFormState extends State<ActorForm> {
  final TextEditingController imeController = TextEditingController();
  final TextEditingController prezimeController = TextEditingController();
  String? slikaBase64;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _odaberiSliku() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();
      setState(() {
        slikaBase64 = base64Encode(imageBytes);
      });
    }
  }

  void _dodajGlumca() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String ime = imeController.text;
    String prezime = prezimeController.text;

    if (slikaBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška! Morate odabrati sliku.')),
      );
      return;
    }

    try {
      await ApiService.dodajGlumca(ime, prezime, slikaBase64!);

      setState(() {
        imeController.clear();
        prezimeController.clear();
        slikaBase64 = null;
      });

      _formKey.currentState!.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Glumac uspješno dodan.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri dodavanju glumca: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodavanje Glumca'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: imeController,
                  decoration: InputDecoration(
                    labelText: 'Ime',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ime je obavezno!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: prezimeController,
                  decoration: InputDecoration(
                    labelText: 'Prezime',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Prezime je obavezno!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _odaberiSliku,
                  child: Text('Odaberi Sliku'),
                ),
                if (slikaBase64 != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      height: 300.0, 
                      width: 200.0, 
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(
                          base64Decode(slikaBase64!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      height: 300.0, 
                      width: 200.0, 
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  20.0), 
                          child: Text(
                            'Ovdje će se prikazati Vaša slika kada je odaberete. Preporuka je da slike bude u 16:9 formatu',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 16.0),
                InkWell(
                  onTap: _dodajGlumca,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Dodaj Glumca',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

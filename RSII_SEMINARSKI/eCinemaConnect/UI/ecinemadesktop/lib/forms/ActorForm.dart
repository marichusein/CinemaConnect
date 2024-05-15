// ignore: file_names
import 'dart:convert';
import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ActorForm extends StatefulWidget {
  @override
  _ActorFormState createState() => _ActorFormState();
}

class _ActorFormState extends State<ActorForm> {
  TextEditingController imeController = TextEditingController();
  TextEditingController prezimeController = TextEditingController();
  String? slikaBase64;
  String? poruka;

  Future<void> _odaberiSliku() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Konvertuj sliku u base64 format
      List<int> imageBytes = await pickedFile.readAsBytes();
      setState(() {
        slikaBase64 = base64Encode(imageBytes);
      });
    }
  }

  void _dodajGlumca() async {
    String ime = imeController.text;
    String prezime = prezimeController.text;

    if (ime == "") {
      setState(() {
        poruka = 'Greška! Morate unijeti ime.';
      });
      return;
    }
     if (prezime == "") {
      setState(() {
        poruka = 'Greška! Morate unijeti prezime.';
      });
      return;
    }

    if (slikaBase64 == null) {
      setState(() {
        poruka = 'Greška! Morate odabrati sliku.';
      });
      return;
    }
 
    try {
      await ApiService.dodajGlumca(ime, prezime, slikaBase64!);

      setState(() {
        poruka = 'Glumac uspješno dodan.';
        imeController.clear();
        prezimeController.clear();
        slikaBase64 = null;
      });
    } catch (error) {
      setState(() {
        poruka = 'Greška pri dodavanju glumca: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodavanje Glumca'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: imeController,
                    decoration: InputDecoration(
                      labelText: 'Ime',
                      prefixIcon: Icon(Icons.person), // Dodaj ikonicu ovdje
                    ),
                  ),
                  TextFormField(
                    controller: prezimeController,
                    decoration: InputDecoration(
                      labelText: 'Prezime',
                      prefixIcon: Icon(Icons.person), // Dodaj ikonicu ovdje
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _odaberiSliku,
                    child: Text('Odaberi Sliku'),
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
                  if (poruka != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        poruka!,
                        style: TextStyle(
                          color: poruka!.contains('Greška') ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (slikaBase64 != null)
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onHover: (_) {},
                child: Image.memory(
                  base64Decode(slikaBase64!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

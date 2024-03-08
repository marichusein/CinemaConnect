import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';



class DodajReziseraForma extends StatefulWidget {
  @override
  _DodajReziseraFormaState createState() => _DodajReziseraFormaState();
}

class _DodajReziseraFormaState extends State<DodajReziseraForma> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _imeController = TextEditingController();
  TextEditingController _prezimeController = TextEditingController();
  String _warningMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj režisera'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _imeController,
                decoration: InputDecoration(labelText: 'Ime'),
                validator: (value) {
                  if (value!.isEmpty || !value.startsWith(RegExp(r'[A-Z]'))) {
                    return 'Unesite ime počevši velikim slovom';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prezimeController,
                decoration: InputDecoration(labelText: 'Prezime'),
                validator: (value) {
                  if (value!.isEmpty || !value.startsWith(RegExp(r'[A-Z]'))) {
                    return 'Unesite prezime počevši velikim slovom';
                  }
                  return null;
                },
              ),
              Text(
                _warningMessage,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _dodajRezisera();
                  }
                },
                child: Text('Dodaj režisera'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _dodajRezisera() async {
  final ime = _imeController.text;
  final prezime = _prezimeController.text;

  try {
    String message = await ApiService.dodajRezisera(ime, prezime);

    setState(() {
      _warningMessage = message;
      _imeController.clear();
      _prezimeController.clear();
    });
  } catch (error) {
    setState(() {
      _warningMessage = 'Greška prilikom dodavanja režisera: $error';
    });
  }
}

}

void main() => runApp(MaterialApp(
      home: DodajReziseraForma(),
    ));

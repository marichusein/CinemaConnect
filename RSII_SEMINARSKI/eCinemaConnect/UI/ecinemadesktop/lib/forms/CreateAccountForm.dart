import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAccountForm extends StatefulWidget {
  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _imeController = TextEditingController();
  final TextEditingController _prezimeController = TextEditingController();
  final TextEditingController _korisnickoImeController =
      TextEditingController();
  final TextEditingController _lozinkaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();

  String _errorText = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Sva polja su validna, kreirajte objekt za registraciju
      final registrationData = {
        "ime": _imeController.text,
        "prezime": _prezimeController.text,
        "korisnickoIme": _korisnickoImeController.text,
        "lozinka": _lozinkaController.text,
        "email": _emailController.text,
        "telefon": _telefonController.text,
      };

      // Pošaljite zahtjev za registraciju koristeći RegisterService
      try {
        final response = await http.post(
          Uri.parse('https://localhost:7036/Korisnici/siginup'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(registrationData),
        );

        if (response.statusCode == 200) {
          // Uspješna registracija
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registracija uspješna!'),
            ),
          );
          // Očistite polja forme
          _imeController.clear();
          _prezimeController.clear();
          _korisnickoImeController.clear();
          _lozinkaController.clear();
          _emailController.clear();
          _telefonController.clear();
        } else if (response.statusCode == 400) {
          // Greška pri registraciji - prikaži poruku iz odgovora servera
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  response.body), // Prikazi telo odgovora kao plain text poruku
            ),
          );
        } else {
          // Drugačiji status kod, prikaži generičku poruku o grešci
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Neuspješna registracija. Pokušajte ponovo.'),
            ),
          );
        }
      } catch (error) {
        String errorMessage = 'Greška pri registraciji. Pokušajte ponovo.';

        if (error is http.ClientException) {
          errorMessage = 'Klijent greška: $error. Pokušajte ponovo.';
        } else if (error is http.Response) {
          errorMessage =
              'Server greška - status kod: ${error.statusCode}. Pokušajte ponovo.';
        } else {
          errorMessage = 'Nepredviđena greška: $error. Pokušajte ponovo.';
        }

        print(errorMessage);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _imeController,
                decoration: InputDecoration(labelText: 'Ime'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Molimo unesite ime.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prezimeController,
                decoration: InputDecoration(labelText: 'Prezime'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Molimo unesite prezime.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _korisnickoImeController,
                decoration: InputDecoration(labelText: 'Korisničko ime'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Molimo unesite korisničko ime.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lozinkaController,
                decoration: InputDecoration(labelText: 'Lozinka'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Molimo unesite lozinku.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
                  if (value!.isEmpty) {
                    return 'Molimo unesite email adresu.';
                  } else if (!emailRegex.hasMatch(value)) {
                    return 'Nevažeća email adresa.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonController,
                decoration: InputDecoration(labelText: 'Telefon'),
                validator: (value) {
                  final phoneRegex = RegExp(r'^06\d{7,8}$');
                  if (value!.isEmpty) {
                    return 'Molimo unesite broj telefona.';
                  } else if (!phoneRegex.hasMatch(value)) {
                    return 'Nevažeći broj telefona.';
                  }
                  return null;
                },
              ),
              Text(
                _errorText,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Registruj se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

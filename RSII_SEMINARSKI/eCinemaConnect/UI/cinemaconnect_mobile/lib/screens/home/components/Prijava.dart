// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController imeController = TextEditingController();
  TextEditingController prezimeController = TextEditingController();
  TextEditingController korisnickoImeController = TextEditingController();
  TextEditingController lozinkaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonController = TextEditingController();

  bool showPassword = false;

  String? imeError;
  String? prezimeError;
  String? korisnickoImeError;
  String? lozinkaError;
  String? emailError;
  String? telefonError;

  Future<void> _signup(BuildContext context) async {
    final ime = imeController.text;
    final prezime = prezimeController.text;
    final korisnickoIme = korisnickoImeController.text;
    final lozinka = lozinkaController.text;
    final email = emailController.text;
    final telefon = telefonController.text;
    final String baseUrl = ApiKonstante.baseUrl;

    setState(() {
      imeError = null;
      prezimeError = null;
      korisnickoImeError = null;
      lozinkaError = null;
      emailError = null;
      telefonError = null;
    });

    // Provjera imena
    if (ime.isEmpty || !RegExp(r'^[A-Z][a-zA-Z]*$').hasMatch(ime)) {
      setState(() {
        imeError = 'Ime je obavezno i mora počinjati velikim slovom.';
      });
      return;
    }

    // Provjera prezimena
    if (prezime.isEmpty || !RegExp(r'^[A-Z][a-zA-Z]*$').hasMatch(prezime)) {
      setState(() {
        prezimeError = 'Prezime je obavezno i mora počinjati velikim slovom.';
      });
      return;
    }

    // Provjera korisničkog imena
    if (korisnickoIme.isEmpty || korisnickoIme.length < 3 || !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(korisnickoIme)) {
      setState(() {
        korisnickoImeError = 'Korisničko ime mora imati najmanje 3 znaka i ne smije sadržavati specijalne znakove.';
      });
      return;
    }

    // Provjera ispravnog formata e-pošte
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email)) {
      setState(() {
        emailError = 'Unesite ispravnu adresu e-pošte.';
      });
      return;
    }

    // Provjera lozinke
    if (lozinka.length < 8 || (!lozinka.contains(RegExp(r'[a-zA-Z]')) && !lozinka.contains(RegExp(r'[!@#$%^&*()_+{}|:;<>,.?~]')))) {
      setState(() {
        lozinkaError = 'Lozinka mora sadržavati najmanje 8 znakova i barem jedno slovo ili specijalni znak.';
      });
      return;
    }

    // Provjera telefonskog broja
    if (!telefon.startsWith('+3876') || telefon.length != 12 ) {
      setState(() {
        telefonError = 'Telefon mora počinjati sa 06 i sadržavati ukupno 9 cifara.';
      });
      return;
    }

   final response = await http.post(
      Uri.parse('$baseUrl/Korisnici/siginup'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'ime': ime,
        'prezime': prezime,
        'korisnickoIme': korisnickoIme,
        'lozinka': lozinka,
        'email': email,
        'telefon': telefon,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uspješna registracija. Sada se možete prijaviti.'),
        ),
      );

      // Navigirajte natrag na LoginScreen
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Neuspješna registracija. Provjerite podatke i pokušajte ponovno.'),
        ),
      );
    }
  }

  bool _validateInputs() {
    return imeController.text.isNotEmpty &&
        prezimeController.text.isNotEmpty &&
        korisnickoImeController.text.isNotEmpty &&
        lozinkaController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        telefonController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registracija'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: imeController,
                decoration: InputDecoration(
                  labelText: 'Ime',
                  hintText: 'Ime (veliko slovo na početku)',
                  errorText: imeError,
                ),
              ),
              TextField(
                controller: prezimeController,
                decoration: InputDecoration(
                  labelText: 'Prezime',
                  hintText: 'Prezime (veliko slovo na početku)',
                  errorText: prezimeError,
                ),
              ),
              TextField(
                controller: korisnickoImeController,
                decoration: InputDecoration(
                  labelText: 'Korisničko ime',
                  hintText: 'Korisničko ime (najmanje 3 znaka, bez specijalnih znakova)',
                  errorText: korisnickoImeError,
                ),
              ),
              TextField(
                controller: lozinkaController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: 'Lozinka',
                  hintText: 'Lozinka (najmanje 8 znakova, jedno slovo ili specijalni znak)',
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                  errorText: lozinkaError,
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email (ispravan format)',
                  errorText: emailError,
                ),
              ),
              TextField(
                controller: telefonController,
                decoration: InputDecoration(
                  labelText: 'Telefon',
                  hintText: '+387 061 111 111',
                  errorText: telefonError,
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  if (!value.startsWith('+387')) {
                    telefonController.text = '+387' + value.replaceFirst('0', '');
                    telefonController.selection = TextSelection.fromPosition(TextPosition(offset: telefonController.text.length));
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_validateInputs()) {
                    _signup(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Morate popuniti sva polja.'),
                      ),
                    );
                  }
                },
                child: const Text('Registriraj se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SignupScreen(),
  ));
}

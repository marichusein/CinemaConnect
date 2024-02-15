import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController imeController = TextEditingController();
  TextEditingController prezimeController = TextEditingController();
  TextEditingController korisnickoImeController = TextEditingController();
  TextEditingController lozinkaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefonController = TextEditingController();

  String errorMessage = '';
  bool showPassword = false;

  Future<void> _signup(BuildContext context) async {
    final ime = imeController.text;
    final prezime = prezimeController.text;
    final korisnickoIme = korisnickoImeController.text;
    final lozinka = lozinkaController.text;
    final email = emailController.text;
    final telefon = telefonController.text;

    // Provjera ispravnog formata e-pošte
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email)) {
      errorMessage = 'Unesite ispravnu adresu e-pošte.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
      return;
    }

    // Dodajte provjeru za minimalnu duljinu lozinke i uvjet za slovo ili specijalni znak
    if (lozinka.length < 8 || (!lozinka.contains(RegExp(r'[a-zA-Z]')) && !lozinka.contains(RegExp(r'[!@#$%^&*()_+{}|:;<>,.?~]')))) {
      errorMessage = 'Lozinka mora sadržavati najmanje 8 znakova i barem jedno slovo ili specijalni znak.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('https://localhost:7125/Korisnici/siginup'),
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
      errorMessage = 'Uspješna registracija. Sada se možete prijaviti.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );

      // Navigirajte natrag na LoginScreen
      Navigator.of(context).pop();
    } else {
      errorMessage = 'Neuspješna registracija. Provjerite podatke i pokušajte ponovno.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
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
        title: Text('Registracija'),
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
                ),
              ),
              TextField(
                controller: prezimeController,
                decoration: InputDecoration(
                  labelText: 'Prezime',
                ),
              ),
              TextField(
                controller: korisnickoImeController,
                decoration: InputDecoration(
                  labelText: 'Korisničko ime',
                ),
              ),
              TextField(
                controller: lozinkaController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: 'Lozinka',
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
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: telefonController,
                decoration: InputDecoration(
                  labelText: 'Telefon',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_validateInputs()) {
                    _signup(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Morate popuniti sva polja.'),
                      ),
                    );
                  }
                },
                child: Text('Registriraj se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignupScreen(),
  ));
}

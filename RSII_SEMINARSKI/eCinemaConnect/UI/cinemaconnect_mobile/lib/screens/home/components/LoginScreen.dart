import 'dart:ui';
import 'package:cinemaconnect_mobile/components/home_screen.dart';
import 'package:cinemaconnect_mobile/screens/home/components/Prijava.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  TextEditingController korisnickoImeController = TextEditingController();
  TextEditingController lozinkaController = TextEditingController();

  String errorMessage = '';

  LoginScreen({super.key});

  Future<void> _login(BuildContext context) async {
    final korisnickoIme = korisnickoImeController.text;
    final lozinka = lozinkaController.text;

    final response = await http.post(
      Uri.parse('https://localhost:7125/Korisnici/login'),
      headers: <String, String>{
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'korisnickoIme': korisnickoIme,
        'lozinka': lozinka,
      }),
    );

    if (response.statusCode == 200) {
      // Uspješna prijava
      final jsonResponse = jsonDecode(response.body);
      // ignore: unused_local_variable
      final idKorisnika = jsonResponse['idkorisnika'];
      final ime = jsonResponse['ime'];
      final prezime = jsonResponse['prezime'];
      // ignore: unused_local_variable
      final korisnickoIme = jsonResponse['korisnickoIme'];

      errorMessage =
          'Uspješna prijava. Pijavljeni ste kao ' + ime + ' ' + prezime;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );

      // Navigirajte na sljedeći ekran (ako je potrebno)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(userId: idKorisnika),
        ),
      );
      
    } else {
      // Neuspješna prijava
      errorMessage = 'Neuspješna prijava. Provjerite korisničko ime i lozinku.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prijava'),
      ),
      body: Stack(
        children: [
          // Pozadina s efektom zamagljene pozadine
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/login.jpg'), // Postavite putanju do slike pozadine
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 5.0,
                sigmaY:
                    5.0), // Postavite intenzitet zamagljivanja prema potrebi
            child: Container(
              color: Colors.black.withOpacity(
                  0.5), // Postavite boju pozadine i nivo providnosti prema potrebi
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'CINEMACONNECT',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Postavite boju teksta prema potrebi
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: korisnickoImeController,
                  style: TextStyle(
                      color: Colors.white), // Postavite bijelu boju teksta
                  decoration: InputDecoration(
                    labelText: 'Korisničko ime',
                    labelStyle: TextStyle(
                        color: Colors.white), // Postavite bijelu boju labele
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: lozinkaController,
                  style: TextStyle(
                      color: Colors.white), // Postavite bijelu boju teksta
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Lozinka',
                    labelStyle: TextStyle(
                        color: Colors.white), // Postavite bijelu boju labele
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _login(context);
                  },
                  child: Text('Prijavi se'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                     Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => SignupScreen(),
      ),
    );


                  },
                  child: Text('Kreiraj novi račun'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}

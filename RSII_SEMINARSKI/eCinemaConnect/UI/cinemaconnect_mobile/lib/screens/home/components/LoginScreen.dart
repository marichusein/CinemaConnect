import 'dart:ui';
import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:cinemaconnect_mobile/components/home_screen.dart';
import 'package:cinemaconnect_mobile/screens/home/components/Prijava.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/AdminLoginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Map<String, String> authorizationHeader = <String, String>{};

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  TextEditingController korisnickoImeController = TextEditingController();
  TextEditingController lozinkaController = TextEditingController();
  final String baseUrl = ApiKonstante.baseUrl;

  String errorMessage = '';
  LoginScreen({super.key});

  Future<void> _login(BuildContext context) async {
    final korisnickoIme = korisnickoImeController.text;
    final lozinka = lozinkaController.text;
    
      final response = await http.post(
        Uri.parse('$baseUrl/Korisnici/login'),
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
        authorizationHeader = createHeaders();
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
            builder: (BuildContext context) =>
                HomeScreen(userId: idKorisnika, header: authorizationHeader),
          ),
        );
      } else {
        // Neuspješna prijava
        errorMessage =
            'Neuspješna prijava. Provjerite korisničko ime i lozinku.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      }
    
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Prijava'),
  //     ),
  //     body: Stack(
  //       children: [
  //         // Pozadina s efektom zamagljene pozadine
  //         Container(
  //           decoration: BoxDecoration(
  //             image: DecorationImage(
  //               image: AssetImage(
  //                   'assets/images/login.jpg'), // Postavite putanju do slike pozadine
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         BackdropFilter(
  //           filter: ImageFilter.blur(
  //               sigmaX: 5.0,
  //               sigmaY:
  //                   5.0), // Postavite intenzitet zamagljivanja prema potrebi
  //           child: Container(
  //             color: Colors.black.withOpacity(
  //                 0.5), // Postavite boju pozadine i nivo providnosti prema potrebi
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(15.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               Text(
  //                 'CINEMACONNECT',
  //                 style: TextStyle(
  //                   fontSize: 24.0,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white, // Postavite boju teksta prema potrebi
  //                 ),
  //               ),
  //               SizedBox(height: 20),
  //               TextField(
  //                 controller: korisnickoImeController,
  //                 style: TextStyle(
  //                     color: Colors.white), // Postavite bijelu boju teksta
  //                 decoration: InputDecoration(
  //                   labelText: 'Korisničko ime',
  //                   labelStyle: TextStyle(
  //                       color: Colors.white), // Postavite bijelu boju labele
  //                   border: OutlineInputBorder(),
  //                 ),
  //               ),
  //               SizedBox(height: 10),
  //               TextField(
  //                 controller: lozinkaController,
  //                 style: TextStyle(
  //                     color: Colors.white), // Postavite bijelu boju teksta
  //                 obscureText: true,
  //                 decoration: InputDecoration(
  //                   labelText: 'Lozinka',
  //                   labelStyle: TextStyle(
  //                       color: Colors.white), // Postavite bijelu boju labele
  //                   border: OutlineInputBorder(),
  //                 ),
  //               ),
  //               SizedBox(height: 20),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   _login(context);
  //                 },
  //                 child: Text('Prijavi se'),
  //               ),
  //               SizedBox(height: 10),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).push(
  //                     MaterialPageRoute(
  //                       builder: (BuildContext context) => SignupScreen(),
  //                     ),
  //                   );
  //                 },
  //                 child: Text('Kreiraj novi račun'),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prijava'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Pozadina s efektom zamagljene pozadine
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.jpg'), // Putanja do slike pozadine
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'CINEMACONNECT',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: korisnickoImeController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Korisničko ime',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: lozinkaController,
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Lozinka',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _login(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Prijavi se'),
                ),
                SizedBox(height: 15),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Admin'),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) => SignupScreen()),
                        );
                      },
                      child: Text(
                        'Kreiraj novi račun',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> createHeaders() {
    String username = korisnickoImeController.text;
    String password = lozinkaController.text;

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    print('ZAGLAVLJEE $headers');

    return headers;
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}

import 'dart:convert';
import 'dart:ui';

import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/AdminScanner.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Map<String, String> authorizationHeader= <String, String>{};

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _loading = false;
  final String baseUrl = ApiKonstante.baseUrl;

  Future<void> _login(BuildContext context) async {
    setState(() {
      _loading = true;
    });

    final username = _usernameController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse('$baseUrl/Korisnici/LoginAdmin'), // Postavite endpoint za prijavu
      headers: <String, String>{
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'korisnickoIme': username,
        'lozinka': password,
      }),
    );

    if (response.statusCode == 200) {
      authorizationHeader = createHeaders();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QRScannerScreen(authorizationHeader: authorizationHeader),
          maintainState: false, // Dodajte ovu liniju kako biste onemogućili povratak na prethodni ekran
        ),
      );
    } else {
      // Neuspješna prijava
      setState(() {
        _errorMessage = 'Neuspješna prijava. Provjerite korisničko ime i lozinku.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Prijava'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.jpg'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              color: Colors.black.withOpacity(0.5),
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
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Korisničko ime',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Lozinka',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                _loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          _login(context);
                        },
                        child: Text('Prijavi se'),
                      ),
                SizedBox(height: 10),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String> createHeaders() {
    String username =  _usernameController.text;
    String password = _passwordController.text;

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
    home: AdminLoginScreen(),
  ));
}

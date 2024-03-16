import 'package:flutter/material.dart';
import 'package:ecinemadesktop/services/services.dart';

class ModelPreporuke extends StatefulWidget {
  @override
  _ModelPreporukeState createState() => _ModelPreporukeState();
}

class _ModelPreporukeState extends State<ModelPreporuke> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utreniraj model'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Prikazuje se samo ako je _isLoading true
            : ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    _isLoading = true; // Postavljamo _isLoading na true prije treniranja modela
                  });
                  try {
                    await ApiService.trenirjaModel();
                    _showSuccessDialog(context); // Prikaži dijalog za uspješno treniranje
                  } catch (e) {
                    _showErrorDialog(context); // Prikaži dijalog za neuspješno treniranje
                    print('Greška prilikom poziva trenirjaModel(): $e');
                  } finally {
                    setState(() {
                      _isLoading = false; // Postavljamo _isLoading na false nakon treniranja modela
                    });
                  }
                },
                icon: Icon(Icons.abc), // Prilagodite ikonu prema potrebi
                label: Text('Treniraj model'), // Tekst gumba
              ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uspješno treniranje'),
          content: Text('Model je uspješno treniran.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Greška'),
          content: Text('Došlo je do greške prilikom treniranja modela.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

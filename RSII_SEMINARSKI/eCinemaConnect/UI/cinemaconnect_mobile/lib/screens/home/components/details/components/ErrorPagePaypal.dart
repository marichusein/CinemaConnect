import 'package:cinemaconnect_mobile/components/home_screen.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final int korisnikID;
  final Map<String, String> header;

  const ErrorPage({required this.korisnikID, required this.header});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Greška prilikom plaćanja'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Došlo je do greške prilikom plaćanja.',
              style: TextStyle(fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      userId: korisnikID,
                      header: header,
                    ),
                  ),
                );
              },
              child: Text('Početni ekran'),
            ),
          ],
        ),
      ),
    );
  }
}

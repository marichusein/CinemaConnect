import 'package:cinemaconnect_mobile/components/home_screen.dart';
import 'package:flutter/material.dart';

class CancelledPage extends StatelessWidget {
  final int korisnikID;
  final Map<String, String> header;

  const CancelledPage({required this.korisnikID, required this.header});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Odustali ste od plaćanja'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Odustali ste od plaćanja.',
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

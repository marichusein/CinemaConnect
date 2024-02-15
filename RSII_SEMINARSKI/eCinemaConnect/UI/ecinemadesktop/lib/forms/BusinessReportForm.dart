import 'package:ecinemadesktop/forms/MovieReport.dart';
import 'package:ecinemadesktop/forms/ZanrReport.dart';
import 'package:ecinemadesktop/forms/ZaradaFIlmova.dart';
import 'package:flutter/material.dart';

class BusinessReportForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kreiraj poslovni izvještaj'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Navigacija na formu za izvještaj o prodaji karata po filmovima
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieReport()),
                );
              },
              icon: Icon(Icons.local_movies),
              label: Text('Izvještaj o prodaji karata po filmovima'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
               // Navigacija na formu za izvještaj o prodaji karata po filmovima
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ZanrReport()),
                );
              },
              icon: Icon(Icons.category),
              label: Text('Izvještaj o prodaji po žanru'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ZaradaFilmova()),
                );
              },
              icon: Icon(Icons.person),
              label: Text('Izvještaj o zaradi po filmu'),
            ),
          ],
        ),
      ),
    );
  }
}

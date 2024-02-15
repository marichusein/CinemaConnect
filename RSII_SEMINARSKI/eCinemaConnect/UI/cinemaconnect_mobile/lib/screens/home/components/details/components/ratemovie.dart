import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RatingDialog extends StatefulWidget {
  final int movieId;
  final int korisnikID;

  RatingDialog({required this.movieId, required this.korisnikID});

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double rating = 0;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Ocijeni"),
      contentPadding: EdgeInsets.all(16),
      children: [
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 10,
          itemSize: 28,
          itemBuilder: (context, index) {
            return Icon(
              Icons.star,
              color: Colors.amber,
            );
          },
          onRatingUpdate: (newRating) {
            setState(() {
              rating = newRating;
            });
          },
        ),
        SizedBox(height: 16),
        TextField(
          controller: commentController,
          decoration: InputDecoration(labelText: 'Komentar'),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Slanje ocjene i komentara na server
            submitRating();
          },
          child: Text("Ocijeni"),
        ),
      ],
    );
  }



void submitRating() async {
  final String comment = commentController.text;
  final int userId = widget.korisnikID;
  final int movieId = widget.movieId;
  final int ratingValue = rating.round(); // Zaokruživanje ocjene na najbližu cijelu vrijednost
  final String currentDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime.now().toUtc()); // Postavite stvarni datum ovdje

  final Map<String, dynamic> data = {
    "korisnikId": userId,
    "filmId": movieId,
    "ocjena": ratingValue,
    "komentar": comment,
    "datumOcjene": currentDate,
  };

  final url = Uri.parse('https://localhost:7125/OcijeniFilm');

  final client = http.Client();

  try {
    final response = await client.post(
      url,
      headers: {
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Uspješno slanje ocjene i komentara
      // Možete dodatno obraditi odgovor servera ako je potrebno
      print("Uspješno ocijenjeno: ${response.body}");
      Navigator.pop(context, ratingValue);
    } else {
      // Neuspješan HTTP zahtjev
      print("HTTP Greška: ${response.statusCode}");
    }
  } catch (error) {
    // Obrada grešaka ako slanje ne uspije
    print("Greška prilikom slanja ocjene i komentara: $error");
  } finally {
    client.close();
  }
}
}

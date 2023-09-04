import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingDialog extends StatefulWidget {
  final int movieId;

  RatingDialog({required this.movieId});

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double rating = 0;

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
        ElevatedButton(
          onPressed: () {
            // Handle the rating submission here
            Navigator.pop(context, rating);
          },
          child: Text("Ocijeni"),
        ),
      ],
    );
  }
}

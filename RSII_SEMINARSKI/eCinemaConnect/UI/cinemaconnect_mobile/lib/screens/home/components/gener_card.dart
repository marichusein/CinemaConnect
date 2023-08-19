import 'package:cinemaconnect_mobile/const.dart';
import 'package:flutter/material.dart';

class Genres extends StatelessWidget {
  const Genres({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> genres = [
      "Akcija",
      "Horor",
      "Komedija",
      "Kriminalistički",
      "Drama",
      "Romantični",
      "Dječiji"
    ];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),

      height: 36, // Set a fixed height here
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) => GenerCard(genre: genres[index]),
      ),
    );
  }
}

class GenerCard extends StatelessWidget {
  final String genre;
  const GenerCard({Key? key, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: kDefaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        genre,
        style: TextStyle(
          color: Colors.black.withOpacity(0.8),
          fontSize: 16,
          fontFamily: 'SFUIText',
        ),
      ),
    );
  }
}

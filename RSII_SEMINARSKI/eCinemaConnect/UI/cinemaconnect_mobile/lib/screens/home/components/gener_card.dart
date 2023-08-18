import 'package:flutter/material.dart';

class Genres extends StatelessWidget {
  const Genres({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> genres = ["Akcija", "Horor", "Komedija", "Kriminalistički", "Drama", "Romantični", "Dječiji"];
    return Container(
      margin: const EdgeInsets.only(right: 15.0, top: 0.0),
      
      height: 60, // Set a fixed height here
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
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
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
        ),
      ),
    );
  }
}

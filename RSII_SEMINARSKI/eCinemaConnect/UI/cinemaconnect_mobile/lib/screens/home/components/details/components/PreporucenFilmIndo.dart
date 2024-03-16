import 'dart:convert';

import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String base64Image;
  final String title;
  final String description; // Dodana linija za opis filma

  const MovieCard({
    Key? key,
    required this.base64Image,
    required this.title,
    required this.description, // Dodana linija za opis filma
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImage(base64Image),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8), // Razmak između naslova i opisa filma
                Text(
                  description,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back), // Strelica za povratak
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String base64Image) {
    try {
      final imageBytes = base64Decode(base64Image);
      final image = MemoryImage(imageBytes);
      return Container(
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
          ),
        ),
      );
    } catch (e) {
      print('Error decoding base64 image: $e');
      return Container(
        height: 200,
        color: Colors.grey, // Placeholder color if image fails to load
      );
    }
  }
}

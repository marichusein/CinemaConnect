
import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:cinemaconnect_mobile/const.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Genres extends StatefulWidget {
  final Map<String, String> header; 
  final Function(String) onGenreSelected; // Dodajte ovu funkciju za odabir žanra

  Genres({required this.onGenreSelected, required this.header});

  @override
  _GenresState createState() => _GenresState();
}

class _GenresState extends State<Genres> {
  List<String> genres = [];
  String selectedGenre = "";
  // Dodajte ovo polje za praćenje odabranog žanra

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  Future<void> fetchGenres() async {
  final String baseUrl = ApiKonstante.baseUrl;
  
  try {
    final response = await http.get(Uri.parse('$baseUrl/Zanrovi'), headers: widget.header);
    print('Dohvacanje zanrova ${widget.header}');
    print('Api -> $baseUrl');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        genres = data.map((genre) => genre['nazivZanra'].toString()).toList();
      });
    } else {
      print(response.body);
      throw Exception('Failed to load genres');
    }
  } catch (e) {
    print('Greška prilikom dohvaćanja žanrova: $e');
    // Ovdje možete dodati logiku za prikazivanje greške korisniku, npr. prikazivanjem dijaloga ili snackbara.
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 36, // Postavite fiksnu visinu ovdje
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) => GenreCard(
          genre: genres[index],
          isSelected: genres[index] == selectedGenre, // Dodajte isSelected svojstvo
          onTap: () {
            setState(() {
              selectedGenre = genres[index];
              widget.onGenreSelected(selectedGenre); // Pozovite funkciju za odabir žanra
            });
          },
        ),
      ),
    );
  }
}

class GenreCard extends StatelessWidget {
  final String genre;
  final bool isSelected; // Dodajte isSelected svojstvo
  final VoidCallback onTap; // Dodajte funkciju za obradu dodira

  const GenreCard({
    Key? key,
    required this.genre,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Poziv funkcije za obradu dodira
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: kDefaultPadding),
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 4,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.blue : Colors.black26), // Promjena boje obruba za odabrani žanr
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          genre,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black.withOpacity(0.8), // Promjena boje teksta za odabrani žanr
            fontSize: 16,
            fontFamily: 'SFUIText',
          ),
        ),
      ),
    );
  }

  
}



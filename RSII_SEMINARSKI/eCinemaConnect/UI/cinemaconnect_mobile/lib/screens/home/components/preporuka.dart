import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:cinemaconnect_mobile/models/movie.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Preporuka extends StatefulWidget {
  final int IDKorisnika;
  final Map<String, String> header;

  const Preporuka({
    Key? key,
    required this.IDKorisnika,
    required this.header,
  }) : super(key: key);

  @override
  State<Preporuka> createState() => _PreporukaState();
}

class _PreporukaState extends State<Preporuka> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    int id = widget.IDKorisnika;
    final String baseUrl = ApiKonstante.baseUrl;
    final Uri url = Uri.parse('$baseUrl/Filmovi/preporuka?korisnikid=$id');
    final response = await http.get(url, headers: widget.header);

    if (response.statusCode == 200) {
      final List<dynamic> apiMovies = json.decode(response.body);

      setState(() {
        movies = apiMovies
            .map((apiMovie) => Movie(
                  id: apiMovie['idfilma'],
                  title: apiMovie['nazivFilma'],
                  year: apiMovie['godinaIzdanja'],
                  poster: apiMovie['filmPlakat'],
                  backdrop: "assets/images/backdrop_1.jpg",
                  plot: apiMovie['opis'],
                  genra: [],
                  numOfRatings: 0, metascoreRating: 0, criticsReview: 0, rating: 0,
                  cast: [],
                ))
            .toList();
      });
    } else {
      throw Exception('Pogreška prilikom učitavanja filmova');
    }
  }

  @override
  Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: SingleChildScrollView(
      child: Column(
        children: movies.map((movie) => buildMovieCard(context, movie)).toList(),
      ),
    ),
  );
}

Widget buildMovieCard(BuildContext context, Movie movie) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(base64Decode(movie.poster)),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Text(
          movie.title,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: 'SFUIText',
              ),
        ),
      ),
    ],
  );
}
}
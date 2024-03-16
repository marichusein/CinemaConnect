import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/PreporucenFilmIndo.dart';
import 'package:flutter/material.dart';
import 'package:cinemaconnect_mobile/const.dart';
import 'package:cinemaconnect_mobile/models/movie.dart';
//import 'package:cinemaconnect_mobile/screens/home/components/details/components/castandcrew.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/geners.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/titleinfo.dart';
import 'backdrop_rating.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class BodyD extends StatefulWidget {
  final Movie movie;
  final int KorisnikID;
  final Map<String, String> header;

  const BodyD({Key? key, required this.movie, required this.KorisnikID, required this.header})
      : super(key: key);

  @override
  _BodyDState createState() => _BodyDState();
}

class _BodyDState extends State<BodyD> {
  List<Comment> comments = [];
  List<Movie> recommendedMovies = [];

  @override
  void initState() {
    super.initState();
    loadComments();
    loadRecommendations();
  }

  Future<void> loadComments() async {
    final String baseUrl = ApiKonstante.baseUrl;
    final url =
        '$baseUrl/OcijeniFilm/film/${widget.movie.id}'; 
    final response = await http.get(Uri.parse(url), headers: widget.header);

    if (response.statusCode == 200) {
      final List<dynamic> commentData = json.decode(response.body);

      for (var data in commentData) {
        final comment = Comment.fromJson(data);
        final userUrl =
            '$baseUrl/Korisnici/${comment.korisnikId}'; 
        final userResponse = await http.get(Uri.parse(userUrl), headers: widget.header);

        if (userResponse.statusCode == 200) {
          final userData = json.decode(userResponse.body);
          final user = User.fromJson(userData);
          comment.korisnikImePrezime = '${user.ime} ${user.prezime}';
        }

        setState(() {
          comments.add(comment);
        });
      }
    }
  }

  Future<List<Movie>> fetchRecommendations(int userId) async {
    final String baseUrl = ApiKonstante.baseUrl;
    final url = '$baseUrl/Filmovi/preporuka?korisnikid=$userId';
    final response = await http.get(Uri.parse(url), headers: widget.header);

    if (response.statusCode == 200) {
      final List<dynamic> movieData = json.decode(response.body);
      return movieData.map((data) => Movie.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<void> loadRecommendations() async {
    try {
      final recommendations = await fetchRecommendations(widget.KorisnikID);
      setState(() {
        recommendedMovies = recommendations;
      });
    } catch (e) {
      print('Error loading recommendations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BackdropRating(
              size: size, movie: widget.movie, korisnikID: widget.KorisnikID, header: widget.header,),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          TitleAndBasicInfo(
            movie: widget.movie,
            KorisnikID: widget.KorisnikID,
            header: widget.header,
          ),
          Geners(movie: widget.movie),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
            child: Text(
              "SADRŽAJ FILMA",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              widget.movie.plot,
              style: const TextStyle(color: Color(0xFF737599)),
            ),
          ),
          // Prikaz komentara
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
            child: Text(
              "Komentari",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: comments.map((comment) {
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
                child: ListTile(
                  title:
                      Text(comment.korisnikImePrezime ?? 'Nepoznat korisnik'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text(comment.ocjena.toString()),
                        ],
                      ),
                      Text(comment.komentar),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          // Prikaz preporučenih filmova
         // Prikaz preporučenih filmova
Padding(
  padding: const EdgeInsets.symmetric(
      horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
  child: Text(
    "Preporučeni filmovi",
    style: Theme.of(context).textTheme.headline6,
  ),
),
recommendedMovies.isEmpty
    ? SpinKitCircle(color: Colors.blue) // Dodajte animaciju učitavanja
    : Column(
        children: recommendedMovies.map((movie) {
          return GestureDetector(
             key: ValueKey(movie.id),
            onTap: () {
              // Otvorite detalje za odabrani film
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieCard(
                    base64Image: movie.poster,
                    title: movie.title,
                    description: movie.plot,
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                  vertical: kDefaultPadding / 2),
              child: ListTile(
                title: Text(movie.title),
                // Dodajte ostale informacije o filmu ovdje
              ),
            ),
          );
        }).toList(),
      ),

          //CastAndCrew(casts: widget.movie.cast),
        ],
      ),
    );
  }
}

class Comment {
  final int idocjene;
  final int korisnikId;
  final int filmId;
  final int ocjena;
  final String komentar;
  final DateTime datumOcjene;
  String? korisnikImePrezime;

  Comment({
    required this.idocjene,
    required this.korisnikId,
    required this.filmId,
    required this.ocjena,
    required this.komentar,
    required this.datumOcjene,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      idocjene: json['idocjene'],
      korisnikId: json['korisnikId'],
      filmId: json['filmId'],
      ocjena: json['ocjena'],
      komentar: json['komentar'],
      datumOcjene: DateTime.parse(json['datumOcjene']),
    );
  }
}

class User {
  final String ime;
  final String prezime;

  User({
    required this.ime,
    required this.prezime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      ime: json['ime'],
      prezime: json['prezime'],
    );
  }
}

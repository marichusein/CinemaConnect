import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:cinemaconnect_mobile/models/movie.dart';

class MovieCarousel extends StatefulWidget {
  final String selectedGenre;
  final String searchQuery; // Dodajte searchQuery
  final int IDKorisnika;
  final Map<String, String> header;

  const MovieCarousel({
    Key? key,
    required this.selectedGenre,
    required this.searchQuery, required this.IDKorisnika,
    required this.header // Dodajte searchQuery
  }) : super(key: key);

  @override
  State<MovieCarousel> createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  late PageController _pageController;
  int initialPage = 1;
  List<Movie> movies = [];
  final String baseUrl = ApiKonstante.baseUrl;
  
  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: initialPage);
    fetchMovies(); // Dohvati filmove kada se widget inicijalizira.
  }

  String getSearchQuery() {
    // Ako je searchQuery prazan, vratite prazan string, inače vratite trenutni searchQuery
    return widget.searchQuery.isEmpty ? '' : widget.searchQuery.toLowerCase();
  }

  Future<double> fetchMovieRating(int movieId) async {
  final Uri url = Uri.parse('$baseUrl/film?id=$movieId');
  final response = await http.get(url, headers: widget.header);

  if (response.statusCode == 200) {
    final double apiRating = double.parse(response.body);

    // Provjerite je li ocjena u razumnom rasponu (0-10)
    if (apiRating >= 0 && apiRating <= 10) {
      return apiRating;
    } else {
      return 0.00; // Ako je ocjena izvan raspona, postavi je na 0.00
    }
  } else {
    throw Exception('Pogreška prilikom dohvaćanja ocjene filma');
  }
}




  Future<void> fetchMovies() async {
    final Uri url = Uri.parse('$baseUrl/Filmovi');
    final response = await http.get(url, headers: widget.header );

    if (mounted) {
      // Provjerite je li widget još uvijek montiran prije poziva setState
      if (response.statusCode == 200) {
        final List<dynamic> apiMovies = json.decode(response.body);

        // Očisti postojeću listu filmova
        movies.clear();

        for (var apiMovie in apiMovies) {
          final String filmPlakatBase64 = apiMovie['filmPlakat'];
          String poster;

          // ignore: unnecessary_null_comparison
          if (filmPlakatBase64 != null) {
            // Dekodirajte Base64 string u bajt niz
            List<int> decodedBytes = base64Decode(filmPlakatBase64);

            // Kreirajte Image.memory widget sa dekodiranim bajt nizom
            poster = 'data:image/jpeg;base64,${base64Encode(decodedBytes)}';
          } else {
            // Ako filmPlakatBase64 nije dostupan, koristite rezervnu sliku
            poster = "assets/images/poster_5.jpg";
          }
          final double ratingF = await fetchMovieRating(apiMovie['idfilma']);
          final Movie movie = Movie(
            id: apiMovie['idfilma'],
            title: apiMovie['nazivFilma'],
            year: apiMovie['godinaIzdanja'],
            poster: poster,
            backdrop:
                "assets/images/backdrop_1.jpg", // Možete postaviti ovo prema potrebi
            numOfRatings:
                apiMovie['trajanje'], // Možete postaviti ovo prema potrebi
            rating: ratingF, // Možete postaviti ovo prema potrebi
            criticsReview: 0, // Možete postaviti ovo prema potrebi
            metascoreRating: 0, // Možete postaviti ovo prema potrebi
            genra: [apiMovie['zanr']['nazivZanra']],
            plot: apiMovie['opis'],
            cast: [], // Možete postaviti ovo prema potrebi
          );

          // Provjeri je li odabrani žanr prazan ili odgovara žanru filma
          // Provjeri je li pretraga prazna ili sadrži naziv filma
          if ((widget.selectedGenre.isEmpty ||
                  movie.genra.contains(widget.selectedGenre)) &&
              (getSearchQuery().isEmpty ||
                  movie.title.toLowerCase().contains(getSearchQuery()))) {
            movies.add(movie);
          }
        }

        if (mounted) {
          // Dodatna provjera mounted prije poziva setState
          setState(
              () {}); // Pokreni ponovnu izgradnju nakon što se podaci dobave.
        }
      } else {
        if (mounted) {
          // Dodatna provjera mounted prije bacanja iznimke
          throw Exception('Pogreška prilikom učitavanja filmova');
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: AspectRatio(
        aspectRatio: 0.85,
        child: PageView.builder(
          onPageChanged: (value) {
            setState(() {
              initialPage = value;
            });
          },
          controller: _pageController,
          physics: const ClampingScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (context, index) => buildMovieSlider(index),
        ),
      ),
    );
  }

  Widget buildMovieSlider(int index) => AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 0;
          if (_pageController.position.haveDimensions &&
              _pageController.page != null) {
            value = index - _pageController.page!;
            value = (value * 0.038).clamp(-1, 1);
          }
          return Transform.rotate(
            angle: math.pi * value,
            child: MovieCard(movie: movies[index], KorisnikID: widget.IDKorisnika, header: widget.header,),
          );
        },
      );
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  final int KorisnikID;
  final Map<String, String> header;
  const MovieCard({Key? key, required this.movie, required this.KorisnikID, required this.header});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(movie: movie, KorisnikID: KorisnikID, header: header,),
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        offset: const Offset(0, 2),
        blurRadius: 5,
        spreadRadius: 5,
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(50),
    child: Image.memory(
      base64Decode(movie.poster.split(',').last),
      fit: BoxFit.fill,
    ),
  ),
),

            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                movie.title,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SFUIText',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/icons/star_fill.svg",
                  height: 20,
                ),
                const SizedBox(
                  width: 4.0,
                ),
                Text(
                  "${movie.rating}",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SFUIText',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10, // Dodajte razmak između plakata i projekcija
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: fetchProjections(movie.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Pogreška prilikom dohvaćanja projekcija: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Projekcije još uvijek nisu dostupne');
                  } else {
                    final projections = snapshot.data!;

                    return ListView.builder(
                      itemCount: projections.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              projections[index],
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> fetchProjections(int movieId) async {
     final String baseUrl = ApiKonstante.baseUrl;
    final Uri url =
        Uri.parse('$baseUrl/Projekcije/film/$movieId');
    final response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      final List<dynamic> apiProjections = json.decode(response.body);
      List<String> projections = [];

      for (var apiProjection in apiProjections) {
        final DateTime projectionDateTime =
            DateTime.parse(apiProjection['datumVrijemeProjekcije']);
         String formattedProjectionDateTime =
            '${projectionDateTime.day.toString().padLeft(2, '0')}.${projectionDateTime.month.toString().padLeft(2, '0')}.${projectionDateTime.year.toString().substring(2)} '
            '${projectionDateTime.hour}:${projectionDateTime.minute} ${projectionDateTime.hour < 12 ? 'AM' : 'PM'}';
            double cijena=apiProjection['cijenaKarte'];
            formattedProjectionDateTime=formattedProjectionDateTime+" - "+cijena.toString()+" KM";
            if(apiProjection['sala']['idsale'] == 2){
              formattedProjectionDateTime=formattedProjectionDateTime + " - 3D ";
            }
        projections.add(formattedProjectionDateTime);
      }

      return projections;
    } else {
      throw Exception('Pogreška prilikom dohvaćanja projekcija');
    }
  }
}

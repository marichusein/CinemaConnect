import 'package:cinemaconnect_mobile/screens/home/components/details/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:cinemaconnect_mobile/models/movie.dart';

class MovieCarousel extends StatefulWidget {
  final String selectedGenre;

  const MovieCarousel({Key? key, required this.selectedGenre}) : super(key: key);

  @override
  State<MovieCarousel> createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  late PageController _pageController;
  int initialPage = 1;
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: initialPage);
    fetchMovies(); // Dohvati filmove kada se widget inicijalizira.
  }

  Future<void> fetchMovies() async {
    final Uri url = Uri.parse('https://localhost:7036/Filmovi');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> apiMovies = json.decode(response.body);

      // Očisti postojeću listu filmova
      movies.clear();

      for (var apiMovie in apiMovies) {
        final String filmPlakatBase64 = apiMovie['filmPlakat'];
        String poster;

        if (filmPlakatBase64 != null) {
          // Dekodirajte Base64 string u bajt niz
          List<int> decodedBytes = base64Decode(filmPlakatBase64);

          // Kreirajte Image.memory widget sa dekodiranim bajt nizom
          poster = 'data:image/jpeg;base64,${base64Encode(decodedBytes)}';
        } else {
          // Ako filmPlakatBase64 nije dostupan, koristite rezervnu sliku
          poster = "assets/images/poster_5.jpg";
        }

        final Movie movie = Movie(
          id: apiMovie['idfilma'],
          title: apiMovie['nazivFilma'],
          year: apiMovie['godinaIzdanja'],
          poster: poster,
          backdrop: "assets/images/backdrop_1.jpg", // Možete postaviti ovo prema potrebi
          numOfRatings: apiMovie['trajanje'], // Možete postaviti ovo prema potrebi
          rating: 0.0, // Možete postaviti ovo prema potrebi
          criticsReview: 0, // Možete postaviti ovo prema potrebi
          metascoreRating: 0, // Možete postaviti ovo prema potrebi
          genra: [apiMovie['zanr']['nazivZanra']],
          plot: apiMovie['opis'],
          cast: [], // Možete postaviti ovo prema potrebi
        );

        // Provjeri je li odabrani žanr prazan ili odgovara žanru filma
        if (widget.selectedGenre.isEmpty || movie.genra.contains(widget.selectedGenre)) {
          movies.add(movie);
        }
      }
      setState(() {}); // Pokreni ponovnu izgradnju nakon što se podaci dobave.
    } else {
      throw Exception('Pogreška prilikom učitavanja filmova');
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
        child: MovieCard(movie: movies[index]),
      );
    },
  );
}

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({Key? key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(movie: movie),
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
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(movie.poster),
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

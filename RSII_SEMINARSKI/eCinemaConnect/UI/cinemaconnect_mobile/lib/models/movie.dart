// // Our movie model
// class Movie {
//   final int id, year, numOfRatings, criticsReview, metascoreRating;
//   final double rating;
//   final List<String> genra;
//   final String plot, title, poster, backdrop;
//   final List<Map> cast;

//   Movie({
//     required this.poster,
//     required this.backdrop,
//     required this.title,
//     required this.id,
//     required this.year,
//     required this.numOfRatings,
//     required this.criticsReview,
//     required this.metascoreRating,
//     required this.rating,
//     required this.genra,
//     required this.plot,
//     required this.cast,
//   });
// }

// // our demo data movie data
// List<Movie> movies = [
//     Movie(
//     id: 6,
//     title: "Lleida - zimski ak.2023/24",
//     year: 2023,
//     poster: "assets/images/poster3.png",
//     backdrop: "assets/images/backdrop_1.jpg",
//     numOfRatings: 150212,
//     rating: 9.3,
//     criticsReview: 50,
//     metascoreRating: 97,
//     genra: ["Erasmus +", "IT", "Mašinstvo"],
//     plot: "Nominovati se može samo stalno uposleno nastavno osoblje Univerziteta najmanje u zvanju docenta. Oblasti za koje je moguće aplicirati su IT, mašinstvo, hemijski inžinjering i zaštita okoliša. Kvota je jedan.",
//     cast: [
//       {
//         "orginalName": "Mirsada Behram",
//         "movieName": "IROUNMO",
//         "image": "assets/images/actor_11.jpg",
//       },
//       {
//         "orginalName": "Husein Marić",
//         "movieName": "IROUNMO",
//         "image": "assets/images/profile_picture.jpg",
//       },
//       {
//         "orginalName": "Emina Junuz",
//         "movieName": "FIT",
//         "image": "assets/images/actor_10.jpg",
//       },
//       {
//         "orginalName": "Rijad Novaković",
//         "movieName": "IROUNMO",
//         "image": "assets/images/actor_12.jpg",
//       },
//     ],
//   ),
//   Movie(
//     id: 5,
//     title: "The Nun : Dio 2",
//     year: 2023,
//     poster: "assets/images/poster_5.jpg",
//     backdrop: "assets/images/backdrop_1.jpg",
//     numOfRatings: 150212,
//     rating: 9.3,
//     criticsReview: 50,
//     metascoreRating: 97,
//     genra: ["Horror"],
//     plot: "1956. - Francuska. Svećenik je ubijen. Zlo se širi. Nastavak svjetskog hita prati sestru Irene dok se ponovno suočava s Valakom, demonskom časnom sestrom.",
//     cast: [
//       {
//         "orginalName": "Taissa Farmiga",
//         "movieName": "Sister Irene",
//         "image": "assets/images/actor_5.jpg",
//       },
//       {
//         "orginalName": "Bonnie Aarons",
//         "movieName": "The Nun",
//         "image": "assets/images/actor_6.jpg",
//       },
//       {
//         "orginalName": "Jonas Bloquet",
//         "movieName": "Frenchie",
//         "image": "assets/images/actor_7.jpg",
//       },
//       {
//         "orginalName": "Anna Popplewell",
//         "movieName": "Marcella",
//         "image": "assets/images/actor_8.jpg",
//       },
//        {
//         "orginalName": "Katelyn Rose Downey",
//         "movieName": "Sophie",
//         "image": "assets/images/actor_9.jpg",
//       },
//     ],
//   ),
//   Movie(
//     id: 4,
//     title: "MEG 2",
//     year: 2023,
//     poster: "assets/images/poster_4.jpg",
//     backdrop: "assets/images/backdrop_1.jpg",
//     numOfRatings: 150212,
//     rating: 8.4,
//     criticsReview: 50,
//     metascoreRating: 86,
//     genra: ["Action", "Drama"],
//     plot: "Zaronite u neistražene vode s Jasonom Stathamom i globalnom akcijskom ikonom Wu Jingom dok vode odvažni istraživački tim ronioca u najveće dubine oceana. Njihovo putovanje ubrzo postaje kaos kada zlonamjerna rudarska kompanija zaprijeti njihovoj misiji i natjera ih na bitku za preživljavanje s visokim ulozima.",
//     cast: [
//       {
//         "orginalName": "James Mangold",
//         "movieName": "Director",
//         "image": "assets/images/actor_1.png",
//       },
//       {
//         "orginalName": "Matt Damon",
//         "movieName": "Carroll",
//         "image": "assets/images/actor_2.png",
//       },
//       {
//         "orginalName": "Christian Bale",
//         "movieName": "Ken Miles",
//         "image": "assets/images/actor_3.png",
//       },
//       {
//         "orginalName": "Caitriona Balfe",
//         "movieName": "Mollie",
//         "image": "assets/images/actor_4.png",
//       },
//     ],
//   ),
//   Movie(
//     id: 3,
//     title: "Bloodshot",
//     year: 2020,
//     poster: "assets/images/poster_1.jpg",
//     backdrop: "assets/images/backdrop_1.jpg",
//     numOfRatings: 150212,
//     rating: 7.3,
//     criticsReview: 50,
//     metascoreRating: 76,
//     genra: ["Action", "Drama"],
//     plot: plotText,
//     cast: [
//       {
//         "orginalName": "James Mangold",
//         "movieName": "Director",
//         "image": "assets/images/actor_1.png",
//       },
//       {
//         "orginalName": "Matt Damon",
//         "movieName": "Carroll",
//         "image": "assets/images/actor_2.png",
//       },
//       {
//         "orginalName": "Christian Bale",
//         "movieName": "Ken Miles",
//         "image": "assets/images/actor_3.png",
//       },
//       {
//         "orginalName": "Caitriona Balfe",
//         "movieName": "Mollie",
//         "image": "assets/images/actor_4.png",
//       },
//     ],
//   ),
//   Movie(
//     id: 2,
//     title: "Ford v Ferrari ",
//     year: 2019,
//     poster: "assets/images/poster_2.jpg",
//     backdrop: "assets/images/backdrop_2.jpg",
//     numOfRatings: 150212,
//     rating: 8.2,
//     criticsReview: 50,
//     metascoreRating: 76,
//     genra: ["Action", "Biography", "Drama"],
//     plot: plotText,
//     cast: [
//       {
//         "orginalName": "James Mangold",
//         "movieName": "Director",
//         "image": "assets/images/actor_1.png",
//       },
//       {
//         "orginalName": "Matt Damon",
//         "movieName": "Carroll",
//         "image": "assets/images/actor_2.png",
//       },
//       {
//         "orginalName": "Christian Bale",
//         "movieName": "Ken Miles",
//         "image": "assets/images/actor_3.png",
//       },
//       {
//         "orginalName": "Caitriona Balfe",
//         "movieName": "Mollie",
//         "image": "assets/images/actor_4.png",
//       },
//     ],
//   ),
//   Movie(
//     id: 1,
//     title: "Onward",
//     year: 2020,
//     poster: "assets/images/poster_3.jpg",
//     backdrop: "assets/images/backdrop_3.jpg",
//     numOfRatings: 150212,
//     rating: 7.6,
//     criticsReview: 50,
//     metascoreRating: 79,
//     genra: ["Action", "Drama"],
//     plot: plotText,
//     cast: [
//       {
//         "orginalName": "James Mangold",
//         "movieName": "Director",
//         "image": "assets/images/actor_1.png",
//       },
//       {
//         "orginalName": "Matt Damon",
//         "movieName": "Carroll",
//         "image": "assets/images/actor_2.png",
//       },
//       {
//         "orginalName": "Christian Bale",
//         "movieName": "Ken Miles",
//         "image": "assets/images/actor_3.png",
//       },
//       {
//         "orginalName": "Caitriona Balfe",
//         "movieName": "Mollie",
//         "image": "assets/images/actor_4.png",
//       },
//     ],
//   ),
// ];

// String plotText =
//     "American car designer Carroll Shelby and driver Kn Miles battle corporate interference and the laws of physics to build a revolutionary race car for Ford in order.";


// // import 'dart:convert';
// // import 'package:http/http.dart' as http;

// // class Movie {
// //   final int id, year, metascoreRating;
// //   final String title, poster, plot;
// //   final double rating;
// //   final List<Map> cast;
// //   final List<String> genra;

// //   Movie({
// //     required this.id,
// //     required this.title,
// //     required this.year,
// //     required this.poster,
// //     required this.metascoreRating,
// //     required this.rating,
// //     required this.plot,
// //     required this.cast,
// //     required this.genra,
// //   });

// //   factory Movie.fromJson(Map<String, dynamic> json) {
// //     return Movie(
// //       id: json['idfilma'],
// //       title: json['nazivFilma'],
// //       year: json['godinaIzdanja'],
// //       poster: json['plakatFilma'],
// //       plot: json['opis'],
// //       metascoreRating: 87,
// //       rating: 7.4,
// //       genra: json['zanr.nazivZanra'],
// //       cast: [
// //       {
// //         "orginalName": "Taissa Farmiga",
// //         "movieName": "Sister Irene",
// //         "image": "assets/images/actor_5.jpg",
// //       },
// //       {
// //         "orginalName": "Bonnie Aarons",
// //         "movieName": "The Nun",
// //         "image": "assets/images/actor_6.jpg",
// //       },
// //       {
// //         "orginalName": "Jonas Bloquet",
// //         "movieName": "Frenchie",
// //         "image": "assets/images/actor_7.jpg",
// //       },
// //       {
// //         "orginalName": "Anna Popplewell",
// //         "movieName": "Marcella",
// //         "image": "assets/images/actor_8.jpg",
// //       },
// //        {
// //         "orginalName": "Katelyn Rose Downey",
// //         "movieName": "Sophie",
// //         "image": "assets/images/actor_9.jpg",
// //       },
// //     ],
// //     );
// //   }
// // }

// // List<Movie> movies = [];

// // Future<void> fetchMoviesFromApi() async {
// //   try {
// //     final response = await http.get(Uri.parse('https://localhost:7036/Filmovi'));
// //     if (response.statusCode == 200) {
// //       final List<dynamic> jsonData = json.decode(response.body);
// //       movies = jsonData.map((json) => Movie.fromJson(json)).toList();
// //     } else {
// //       throw Exception('Failed to fetch movies from API');
// //     }
// //   } catch (e) {
// //     throw Exception('Failed to fetch movies: $e');
// //   }
// // }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class Movie {
  final int id, year, numOfRatings, criticsReview, metascoreRating;
  final double rating;
  final List<String> genra;
  final String plot, title, poster, backdrop;
  final List<Map> cast;

  Movie({
    required this.poster,
    required this.backdrop,
    required this.title,
    required this.id,
    required this.year,
    required this.numOfRatings,
    required this.criticsReview,
    required this.metascoreRating,
    required this.rating,
    required this.genra,
    required this.plot,
    required this.cast,
  });

  
  factory Movie.fromJson(Map<String, dynamic> json) {
    final String poster = json['filmPlakat'] ?? "assets/images/poster_5.jpg";

    return Movie(
      id: json['idfilma'],
          title: json['nazivFilma'],
          year: json['godinaIzdanja'],
          poster: poster,
          backdrop: "assets/images/backdrop_1.jpg", // You can set this as needed
          numOfRatings: 0, // You can set this as needed
          rating: 0.0, // You can set this as needed
          criticsReview: 0, // You can set this as needed
          metascoreRating: 0, // You can set this as needed
          genra: [json['zanr']['nazivZanra']],
          plot: json['opis'],
          cast: [], // You can set this as nee
    );
  }
}

List<Movie> movies = [];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final Uri url = Uri.parse('https://localhost:7036/Filmovi');
  final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> apiMovies = json.decode(response.body);

      // Clear the existing movies list
      movies.clear();

      for (var apiMovie in apiMovies) {
        final String poster = apiMovie['filmPlakat'] ?? "assets/images/poster_5.jpg";

        final Movie movie = Movie(
          id: apiMovie['idfilma'],
          title: apiMovie['nazivFilma'],
          year: apiMovie['godinaIzdanja'],
          poster: poster,
          backdrop: "assets/images/backdrop_1.jpg", // You can set this as needed
          numOfRatings: 0, // You can set this as needed
          rating: 0.0, // You can set this as needed
          criticsReview: 0, // You can set this as needed
          metascoreRating: 0, // You can set this as needed
          genra: [apiMovie['zanr']['nazivZanra']],
          plot: apiMovie['opis'],
          cast: [], // You can set this as needed
        );

        movies.add(movie);
      }
    } else {
      throw Exception('Failed to load movies');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Movie App'),
        ),
        body: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(movies[index].title),
              subtitle: Text(movies[index].year.toString()),
              leading: Image.network(movies[index].poster), // Display movie poster
              onTap: () {
                // Handle movie tap
              },
            );
          },
        ),
      ),
    );
  }
}


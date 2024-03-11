import 'dart:convert';
import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<dynamic> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    final fetchedMovies = await ApiService.fetchMovies();
    setState(() {
      movies = fetchedMovies;
      isLoading = false;
    });
  }

  Future<void> _toggleMovieStatus(int movieId, bool isActive) async {
    await ApiService.toggleMovieStatus(movieId, isActive);
    _fetchMovies();
  }

  Future<void> _searchMovies(String query) async {
    // Implement search functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie List'),
      ),
      body: isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 50.0,
              ),
            )
          : Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by title...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    _searchMovies(value);
                  },
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Card(
                        elevation: 4.0,
                        child: InkWell(
                          onTap: () {
                            // Handle tap on movie card
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: movie['filmPlakat'] != null &&
                                        movie['filmPlakat'].isNotEmpty
                                    ? Image.memory(
                                        base64Decode(movie['filmPlakat']),
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        color: movie['aktivan']
                                            ? null
                                            : Colors
                                                .black, // Dodajte ovo kako biste postavili crno-bijelu boju ako film nije aktivan
                                        colorBlendMode: movie['aktivan']
                                            ? null
                                            : BlendMode
                                                .saturation, // Ovo je samo primjer kako biste crno-bijelu boju primijenili na sliku, možete prilagoditi ovisno o vašim potrebama
                                      )
                                    : Icon(Icons.image_not_supported),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  movie['nazivFilma'],
                                  style: TextStyle(
                                      color: movie['aktivan']
                                          ? Colors.black
                                          : Colors.grey),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  movie['aktivan']
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: movie['aktivan']
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                onPressed: () {
                                  _toggleMovieStatus(
                                      movie['idfilma'], movie['aktivan']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

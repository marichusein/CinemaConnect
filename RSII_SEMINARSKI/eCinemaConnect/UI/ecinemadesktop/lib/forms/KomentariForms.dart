// ignore_for_file: use_build_context_synchronously

import 'package:ecinemadesktop/services/services.dart';

import 'package:flutter/material.dart';
import 'dart:convert';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late List<Comment> comments;
  late Map<int, Moviee> movies;
  late Map<int, User> users;
  bool isLoading = true; 

  Future<void> fetchData() async {
    isLoading=true;
    comments = await ApiService.fetchComments();
    final movieIds = comments.map((comment) => comment.filmId).toSet();
    final userIds = comments.map((comment) => comment.korisnikId).toSet();

    final movieFutures = movieIds.map((id) => ApiService.fetchMovie(id));
    final userFutures = userIds.map((id) => ApiService.fetchUser(id));

    final movieResponses = await Future.wait(movieFutures);
    final userResponses = await Future.wait(userFutures);

    movies = Map.fromEntries(
        movieResponses.map((movie) => MapEntry(movie.idFilma, movie)));
    users = Map.fromEntries(
        userResponses.map((user) => MapEntry(user.idKorisnika, user)));

    setState(() {
      isLoading =
          false; 
    });
  }

  Future<void> deleteComment(int idOcjene) async {
    bool success = await ApiService.deleteComment(idOcjene);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(success
            ? 'Komentar uspješno obrisan!'
            : 'Neuspješno brisanje komentara!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Komentari'),
      ),
      body: isLoading // Provjerava se je li podaci učitani
          ? Center(
              child:
                  CircularProgressIndicator()) // Prikaži animaciju učitavanja
          : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                final movie = movies[comment.filmId];
                final user = users[comment.korisnikId];

                return ListTile(
                  leading: (movie!.filmPlakat != "")
                      ? Image.memory(
                          base64Decode(movie
                              .filmPlakat), // Dekodiranje slike iz base64 formata
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.image_not_supported),
                  title: Text(movie.nazivFilma),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment.komentar),
                      SizedBox(height: 4), // Optional space between lines
                      Text('User: ${user!.ime} ${user.prezime}'), 
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteComment(comment.idOcjene),
                  ),
                );
              },
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CommentsScreen(),
  ));
}

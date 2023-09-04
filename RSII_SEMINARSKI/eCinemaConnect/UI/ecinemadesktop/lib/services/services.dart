import 'dart:convert';
import 'package:ecinemadesktop/models/models-all.dart';
import 'package:http/http.dart' as http;


class MovieService {
  final String baseUrl = 'https://localhost:7036';

  Future<void> addMovie(Movie movie) async {
    final url = Uri.parse('$baseUrl/Filmovi');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(movie.toJson()),
    );

    if (response.statusCode == 200) {
      // Movie added successfully
    } else {
      // Handle error
    }
  }

  Future<List<Genre>> fetchGenres() async {
  final url = Uri.parse('$baseUrl/Zanrovi');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Genre.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch genres');
  }
}

Future<List<Director>> fetchDirectors() async {
  final url = Uri.parse('$baseUrl/Reziseri');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Director.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch directors');
  }
}

Future<List<Actor>> fetchActors() async {
  final url = Uri.parse('$baseUrl/Glumci');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Actor.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch actors');
  }
}


}


import 'dart:convert';
import 'package:ecinemadesktop/models/models-all.dart';
import 'package:http/http.dart' as http;

class MovieService {
  final String baseUrl = 'https://localhost:7125';

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

class LoginService {
  final String baseUrl = 'https://localhost:7125';

  Future<Map<String, dynamic>> login(Map<String, String> loginData) async {
    final url = Uri.parse('$baseUrl/Korisnici/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData),
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      return userData;
    } else {
      throw Exception('Neuspjela prijava');
    }
  }

  Future<Map<String, dynamic>> register(
      Map<String, dynamic> registrationData) async {
    final url = Uri.parse('$baseUrl/Korisnici/signup');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registrationData),
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      return userData;
    } else {
      throw Exception('Neuspješna registracija');
    }
  }
}

class ProfileService {
  final String baseUrl = 'https://localhost:7125';

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    final url = Uri.parse('$baseUrl/Korisnici/${profileData["idkorisnika"]}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profileData),
    );

    if (response.statusCode == 200) {
      // Profil je uspješno ažuriran
    } else {
      // Tretirajte grešku
      throw Exception('Neuspješno ažuriranje profila');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(int idkorisnika) async {
  final url = Uri.parse('$baseUrl/Korisnici/$idkorisnika');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Neuspješno dohvaćanje profila korisnika');
  }
}
}

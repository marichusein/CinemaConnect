import 'dart:convert';
import 'package:ecinemadesktop/api-konstante.dart';
import 'package:ecinemadesktop/models/models-all.dart';
import 'package:http/http.dart' as http;
//import 'package:syncfusion_flutter_charts/charts.dart';

Map<String, String> zaglavlje = <String, String>{};

class MovieService {
  final String baseUrl = ApiKonstante.baseUrl;

  Future<void> addMovie(Movie movie) async {
    final url = Uri.parse('$baseUrl/Filmovi');

    final response = await http.post(
      url,
      headers: zaglavlje,
      body: jsonEncode(movie.toJson()),
    );

    if (response.statusCode == 200) {
      // Movie added successfully
    } else {
      // Handle error
    }
  }

  Future<List<Genre>> fetchGenres(Map<String, String> header) async {
    final url = Uri.parse('$baseUrl/Zanrovi');
    print('u pozivu $zaglavlje');

    final response = await http.get(url, headers: zaglavlje);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch genres');
    }
  }

  Future<List<Director>> fetchDirectors(Map<String, String> header) async {
    final url = Uri.parse('$baseUrl/Reziseri');
    final response = await http.get(url, headers: zaglavlje);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Director.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch directors');
    }
  }

  Future<List<Actor>> fetchActors(Map<String, String> header) async {
    final url = Uri.parse('$baseUrl/Glumci');
    final response = await http.get(url, headers: zaglavlje);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Actor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch actors');
    }
  }
}

class LoginService {
  final String baseUrl = ApiKonstante.baseUrl;

  Future<Map<String, dynamic>> login(Map<String, String> loginData) async {
    final url = Uri.parse('$baseUrl/Korisnici/loginAdmin');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData),
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      zaglavlje = createHeaders(loginData);
      return {'userData': userData, 'headers': createHeaders(loginData)};
    } else if (response.statusCode == 204) {
      throw Exception('Nemate prava korisiti desktop aplikaciju');
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
  final String baseUrl = ApiKonstante.baseUrl;

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

final String baseUrl = ApiKonstante.baseUrl;
class ApiService {
  

  static Future<List<dynamic>> preuzmiFilmove() async {
    
    final response = await http.get(Uri.parse('$baseUrl/Filmovi'), headers: zaglavlje);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<List<dynamic>> preuzmiSale() async {
    final response = await http.get(Uri.parse('$baseUrl/Sale'), headers: zaglavlje);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load halls');
    }
  }

  static Future<void> dodajProjekciju(Map<String, dynamic> novaProjekcija) async {
    final jsonBody = jsonEncode(novaProjekcija);

    

    final response = await http.post(
      Uri.parse('$baseUrl/Projekcije'),
      headers: zaglavlje,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      // Uspješno dodana projekcija
      return;
    } 
    else if(response.statusCode == 400){
      throw Exception('Nemoguće dodati projekciju sala je zazeta za taj period');
    }
      else {
      throw Exception('Failed to add projection');
    }
  }

  static Future<List<Glumac>> fetchGlumci() async {
    final response = await http.get(Uri.parse('$baseUrl/Glumci'), headers: zaglavlje);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      return jsonData.map((data) => Glumac(
        id: data['idglumca'],
        ime: data['ime'],
        prezime: data['prezime'],
        slika: data['slika'],
      )).toList();
    } else {
      throw Exception('Failed to load glumci');
    }
  }

  static Future<void> updateGlumac(int id, String ime, String prezime) async {
    final url = '$baseUrl/Glumci/$id';

    final body = {
      'ime': ime,
      'prezime': prezime,
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: zaglavlje,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to update glumac');
      }
    } catch (error) {
      throw Exception('Error updating glumac: $error');
    }
  }

  static Future<void> dodajGlumca(String ime, String prezime, String slikaBase64) async {
    try {
      final glumacData = {
        'ime': ime,
        'prezime': prezime,
        'slika': slikaBase64,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/Glumci'),
        headers: zaglavlje,
        body: jsonEncode(glumacData),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to add actor');
      }
    } catch (error) {
      throw Exception('Error adding actor: $error');
    }
  }

  static Future<void> posaljiObavijest(int korisnikId, String naslov, String sadrzaj, String base64Image) async {
    try {
      final response = await http.post(
        Uri.parse('$base64Url/Obavijesti'),
        headers: zaglavlje,
        body: jsonEncode({
          'korisnikId': korisnikId,
          'naslov': naslov,
          'sadrzaj': sadrzaj,
          'datumObjave': DateTime.now().toIso8601String(),
          'slika': base64Image,
          'datumUredjivanja': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to send notification');
      }
    } catch (error) {
      throw Exception('Error sending notification: $error');
    }
  }

  static Future<String> dodajRezisera(String ime, String prezime) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Reziseri'),
        headers: zaglavlje,
        body: jsonEncode(<String, String>{
          'ime': ime,
          'prezime': prezime,
        }),
      );

      if (response.statusCode == 200) {
        return 'Režiser uspješno dodan';
      } else {
        throw Exception('Greška prilikom dodavanja režisera');
      }
    } catch (error) {
      throw Exception('Greška prilikom slanja zahtjeva: $error');
    }
  }

  static Future<Map<String, int>> fetchMovieData() async {
    final url = Uri.parse('$baseUrl/Rezervacije/brojkarata');
    final response = await http.get(url, headers: zaglavlje);

    if (response.statusCode == 200) {
      return Map<String, int>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie data');
    }
  }

  static Future<Map<String, int>> fetchZanrData() async {
    final url = Uri.parse('$baseUrl/Rezervacije/kartePoZanru');
    final response = await http.get(url, headers: zaglavlje);

    if (response.statusCode == 200) {
      return Map<String, int>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load zanr data');
    }
  }

  static Future<Map<String, int>> fetchZaradaData() async {
    final url = Uri.parse('$baseUrl/Rezervacije/zardaFilma');
    final response = await http.get(url, headers: zaglavlje);

    if (response.statusCode == 200) {
      return Map<String, int>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load zarada data');
    }
  }

  static Future<List<Comment>> fetchComments() async {
    final commentResponse = await http.get(
      Uri.parse('$baseUrl/OcijeniFilm'),
      headers: zaglavlje
    );
    final List<dynamic> commentData = json.decode(commentResponse.body);

    return commentData.map((comment) => Comment(
      idOcjene: comment['idocjene'],
      filmId: comment['filmId'],
      korisnikId: comment['korisnikId'],
      komentar: comment['komentar'],
      datumOcjene: DateTime.parse(comment['datumOcjene']),
    )).toList();
  }
  
  static Future<bool> deleteComment(int idOcjene) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/OcijeniFilm/$idOcjene'),
      headers: zaglavlje
    );
    final bool success = json.decode(response.body);
    return success;
    // Možete dodati logiku za prikazivanje dijaloga ili obavijesti o uspješnom ili neuspješnom brisanju komentara.
  }

  static Future<Moviee> fetchMovie(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/Filmovi/$movieId'), headers: zaglavlje);
    final movieData = json.decode(response.body);
    return Moviee(
      idFilma: movieData['idfilma'],
      nazivFilma: movieData['nazivFilma'],
      filmPlakat: movieData['filmPlakat'],
    );
  }

  static Future<User> fetchUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/Korisnici/$userId'), headers: zaglavlje);
    final userData = json.decode(response.body);
    return User(
      idKorisnika: userData['idkorisnika'],
      ime: userData['ime'],
      prezime: userData['prezime'],
    );
  }

  static Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final response =
        await http.get(Uri.parse("$baseUrl/Obavijesti"), headers: zaglavlje);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  static Future<Map<String, dynamic>> fetchUserNotification(int userId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/Korisnici/$userId"), headers: zaglavlje);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  static Future<List<dynamic>> fetchMovies() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/Filmovi/sve"), headers: zaglavlje);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  static Future<void> toggleMovieStatus(int movieId, bool isActive) async {
    try {
      final url = isActive
          ? "$baseUrl/Filmovi/$movieId"
          : "$baseUrl/Filmovi/aktiviraj/$movieId";
      final response = isActive
          ? await http.delete(Uri.parse(url), headers: zaglavlje)
          : await http.put(Uri.parse(url), headers: zaglavlje);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to toggle movie status');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> editMovie(int movieId, String newName, String newDescription, int newDuration, String newPoster) async {
  final response = await http.put(
    Uri.parse('$baseUrl/Filmovi/$movieId'),
    headers: zaglavlje,
    body: jsonEncode({
      "nazivFilma": newName,
      "opis": newDescription,
      "trajanje": newDuration,
      "filmPlakat": newPoster,
    }),
  );

  if (response.statusCode == 200) {
    print('Film updated successfully');
  } else {
    throw Exception('Failed to update film ${response.body}');
  }
}

  static Future<void> editObavijest(int obavijestId, Map<String, dynamic> obavijest) async{
      final response = await http.put(
    Uri.parse('$baseUrl/Obavijesti/$obavijest'),
    headers: zaglavlje,
    body: jsonEncode({
      obavijest
    }),
  );

  if (response.statusCode == 200) {
    print('Obavijest updated successfully');
  } else {
    throw Exception('Failed to update obavijest ${response.body}');
  }


  }


}


Map<String, String> createHeaders(Map<String, String> loginData) {
  String username = loginData['korisnickoIme'] ?? "";
  String password = loginData['lozinka'] ?? "";
  String basicAuth =
      "Basic ${base64Encode(utf8.encode('$username:$password'))}";

  var headers = {
    "Content-Type": "application/json",
    "Authorization": basicAuth
  };
  return headers;
}



//KLASE

class Glumac {
  final int id;
  String ime;
  String prezime;
  final String slika;

  Glumac({required this.id, required this.ime, required this.prezime, required this.slika});
}

class Moviee {
  final int idFilma;
  final String nazivFilma;
  final String filmPlakat;

  Moviee({
    required this.idFilma,
    required this.nazivFilma,
    required this.filmPlakat,
  });
}

class User {
  final int idKorisnika;
  final String ime;
  final String prezime;

  User({
    required this.idKorisnika,
    required this.ime,
    required this.prezime,
  });
}


class Comment {
  final int idOcjene;
  final int filmId;
  final int korisnikId;
  final String komentar;
  final DateTime datumOcjene;

  Comment({
    required this.idOcjene,
    required this.filmId,
    required this.korisnikId,
    required this.komentar,
    required this.datumOcjene,
  });
}
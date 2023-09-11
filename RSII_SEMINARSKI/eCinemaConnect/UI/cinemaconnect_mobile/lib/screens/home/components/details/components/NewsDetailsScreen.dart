import 'package:flutter/material.dart';
import 'package:cinemaconnect_mobile/const.dart';
import 'package:cinemaconnect_mobile/models/news.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Comment {
  final String korisnikIme;
  final String korisnikPrezime;
  final String tekstKomentara;

  Comment({
    required this.korisnikIme,
    required this.korisnikPrezime,
    required this.tekstKomentara,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      korisnikIme:
          json['ime'], // Adjust these field names based on your API response
      korisnikPrezime: json[
          'prezime'], // Adjust these field names based on your API response
      tekstKomentara: json['tekstKomentara'],
    );
  }
}

class NewsDetailsScreen extends StatefulWidget {
  final News news;
  final int KorisnikID;

  const NewsDetailsScreen(
      {Key? key, required this.news, required this.KorisnikID})
      : super(key: key);

  @override
  _NewsDetailsScreenState createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  List<Comment> comments = [];
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  Future<String> getUserName(int userId) async {
  try {
    final response = await http.get(Uri.parse('https://localhost:7036/Korisnici/$userId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      final String userName = '${userData['ime']} ${userData['prezime']}';
      return userName;
    } else {
      throw Exception('Failed to get user name: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Failed to get user name: $error');
  }
}

Future<void> loadComments() async {
  try {
    final response = await http.get(Uri.parse('https://localhost:7036/KomentariObavijesti/obavijesti/${widget.news.id}'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonComments = json.decode(response.body);

      final List<Comment> loadedComments = [];

      for (final jsonComment in jsonComments) {
        final String userName = await getUserName(jsonComment['korisnikId']);
        final Comment comment = Comment(
          korisnikIme: userName,
          korisnikPrezime: '',
          tekstKomentara: jsonComment['tekstKomentara'],
        );
        loadedComments.add(comment);
      }

      setState(() {
        comments = loadedComments;
      });
    } else {
      throw Exception('Failed to load comments: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Failed to load comments: $error');
  }
}








  Future<void> postComment() async {
    final commentText = commentController.text;
    final now = DateTime.now().toUtc();
    final formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(now);

    final commentData = {
      "obavijestId": widget.news.id,
      "korisnikId": widget.KorisnikID,
      "tekstKomentara": commentText,
      "datumKomentara": formattedDate,
    };

    final response = await http.post(
        Uri.parse('https://localhost:7036/KomentariObavijesti'),
        body: json.encode(commentData),
        headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      // Komentar je uspešno poslat, osvežite listu komentara.
      loadComments();
      // Očistite unos za komentar.
      commentController.clear();
    } else {
      throw Exception('Failed to post comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalji novosti"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.news.slika),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.news.naslov,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${widget.news.autorIme} ${widget.news.autorPrezime}",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat('dd.MM.yyyy')
                        .format(widget.news.datumObjave.toLocal()),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "SADRŽAJ NOVOSTI",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.news.sadrzaj,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    
                  ),
                ],
              ),
              
            ),
            Padding( padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   Text(
                    "KOMENTARI",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  ]
                  )
            ),
 
           
            ListView.builder(
              shrinkWrap: true,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  title: Text(
                    "${comment.korisnikIme} ${comment.korisnikPrezime}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(comment.tekstKomentara),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: 'Dodajte komentar...',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      postComment();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

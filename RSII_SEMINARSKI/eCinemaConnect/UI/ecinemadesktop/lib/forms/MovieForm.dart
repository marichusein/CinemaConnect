import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecinemadesktop/models/models-all.dart';
import 'package:ecinemadesktop/services/services.dart';
import 'dart:io';

// ignore: must_be_immutable
class MovieFormWithFutureBuilder extends StatelessWidget {
  //final MovieService _movieService = MovieService();
  Map<String, String> header={};

  MovieFormWithFutureBuilder({required this.header});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return MovieForm(header: header);
        }
      },
    );
  }

  Future<void> _fetchData() async {
    // Fetch your data here
    try {
      // Fetch genres, directors, and actors asynchronously
      // print('Header $header');
      // final List<Genre> genres = await _movieService.fetchGenres(header);
      // final List<Director> directors = await _movieService.fetchDirectors(header);
      // final List<Actor> actors = await _movieService.fetchActors(header);

      // Do something with the fetched data if needed
    } catch (e) {
      // Handle errors
    }
  }
}

class MovieForm extends StatefulWidget {
  final Map<String, String> header; // Dodajte polje za zaglavlje

  MovieForm({required this.header}); // Konstruktor za zaglavlje

  @override
  _MovieFormState createState() => _MovieFormState();
}
class _MovieFormState extends State<MovieForm> {
  final _formKey = GlobalKey<FormState>();
  final MovieService _movieService = MovieService();

  Movie _newMovie = Movie(
    nazivFilma: '',
    zanrId: 0,
    opis: '',
    trajanje: 0,
    godinaIzdanja: 0,
    reziserId: 0,
    plakatFilma: '',
    filmPlakat: '',
    glumciUFlimu: [],
  );

  List<Genre> _genres = [];
  List<Director> _directors = [];
  List<Actor> _actors = [];

  Genre? _selectedGenre;
  Director? _selectedDirector;
  List<Actor> _selectedActors = [];

  XFile? _selectedImage;

  String _message = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      print('Header ${widget.header}');
      final List<Genre> genres = await _movieService.fetchGenres(widget.header);
      final List<Director> directors = await _movieService.fetchDirectors(widget.header);
      final List<Actor> actors = await _movieService.fetchActors(widget.header);

      setState(() {
        _genres = genres;
        _directors = directors;
        _actors = actors;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodajte novi film'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Naslov filma'),
                onSaved: (value) => _newMovie.nazivFilma = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite naslov filma';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Genre>(
                value: _selectedGenre,
                items: _genres.map((genre) {
                  return DropdownMenuItem<Genre>(
                    value: genre,
                    child: Text(genre.nazivZanra),
                  );
                }).toList(),
                onChanged: (selectedGenre) {
                  setState(() {
                    _selectedGenre = selectedGenre;
                    _newMovie.zanrId = selectedGenre?.idzanra ?? 0;
                  });
                },
                decoration: InputDecoration(labelText: 'Žanr'),
              ),
              DropdownButtonFormField<Director>(
                value: _selectedDirector,
                items: _directors.map((director) {
                  return DropdownMenuItem<Director>(
                    value: director,
                    child: Text('${director.ime} ${director.prezime}'),
                  );
                }).toList(),
                onChanged: (selectedDirector) {
                  setState(() {
                    _selectedDirector = selectedDirector;
                    _newMovie.reziserId = selectedDirector?.idrezisera ?? 0;
                  });
                },
                decoration: InputDecoration(labelText: 'Režiser'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Opis'),
                onSaved: (value) => _newMovie.opis = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite opis';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Trajanje (u minutama)'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _newMovie.trajanje = int.parse(value ?? '0'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite trajanje';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Godina izdanja'),
                keyboardType: TextInputType.number,
                onSaved: (value) =>
                    _newMovie.godinaIzdanja = int.parse(value ?? '0'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite godinu izdanja';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Actor>(
                value: null,
                items: _actors.map((actor) {
                  return DropdownMenuItem<Actor>(
                    value: actor,
                    child: Text('${actor.ime} ${actor.prezime}'),
                  );
                }).toList(),
                onChanged: (selectedActor) {
                  setState(() {
                    if (selectedActor != null) {
                      _selectedActors.add(selectedActor);
                    }
                  });
                },
                decoration: InputDecoration(labelText: 'Odaberite glumce'),
                isDense: true,
                isExpanded: true,
              ),
              Text('Odabrani glumci:'),
              Wrap(
                children: _selectedActors.map((actor) {
                  return Chip(
                    label: Text('${actor.ime} ${actor.prezime}'),
                    onDeleted: () {
                      setState(() {
                        _selectedActors.remove(actor);
                      });
                    },
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Odaberite poster filma'),
              ),
              if (_selectedImage != null)
                Image.file(File(_selectedImage!.path), width: 100, height: 100),
              // Prikaz poruke nakon spremanja filma
              if (_message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text(
                        _message,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _addMovie();
                  }
                },
                child: Text('Dodajte film'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addMovie() async {
  _newMovie.glumciUFlimu = _selectedActors;

  if (_selectedImage != null) {
    try {
      final imageBytes = await File(_selectedImage!.path).readAsBytes();
      final base64Image = base64Encode(imageBytes);
      _newMovie.filmPlakat = base64Image;
    } catch (e) {
      print('Error encoding image: $e');
      setState(() {
        _message = 'Greška prilikom spremanja filma.';
      });
      return;
    }
  }

  try {
    await _movieService.addMovie(_newMovie);
    setState(() {
      _message = 'Film je uspješno spremljen!';
    });
    
    // Očistite formu nakon uspješnog unosa
    _formKey.currentState!.reset();
    _selectedGenre = null;
    _selectedDirector = null;
    _selectedActors.clear();
    _selectedImage = null;
  } catch (e) {
    print('API error: $e');
    setState(() {
      _message = 'Greška prilikom spremanja filma.';
    });
  }
}

}

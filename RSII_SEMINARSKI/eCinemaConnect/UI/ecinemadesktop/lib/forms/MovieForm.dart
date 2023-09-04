import 'package:flutter/material.dart';
import 'package:ecinemadesktop/models/models-all.dart';
import 'package:ecinemadesktop/services/services.dart';

class MovieFormWithFutureBuilder extends StatelessWidget {
  final MovieService _movieService = MovieService();

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
          return MovieForm();
        }
      },
    );
  }

  Future<void> _fetchData() async {
    // Fetch your data here
    try {
      // Fetch genres, directors, and actors asynchronously
      final List<Genre> genres = await _movieService.fetchGenres();
      final List<Director> directors = await _movieService.fetchDirectors();
      final List<Actor> actors = await _movieService.fetchActors();

      // Do something with the fetched data if needed

    } catch (e) {
      // Handle errors
    }
  }
}

class MovieForm extends StatefulWidget {
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
    glumciUFlimu: [],
  );

  List<Genre> _genres = [];
  List<Director> _directors = [];
  List<Actor> _actors = [];

  Genre? _selectedGenre;
  Director? _selectedDirector;
  List<Actor> _selectedActors = [];

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
    _fetchData();
  }

 Future<void> _fetchData() async {
  try {
    final List<Genre> genres = await _movieService.fetchGenres();
    final List<Director> directors = await _movieService.fetchDirectors();
    final List<Actor> actors = await _movieService.fetchActors();

    setState(() {
      _genres = genres;
      _directors = directors;
      _actors = actors;
    });
  } catch (e) {
    print('Error fetching data: $e');
    // Handle error
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Movie Title'),
                onSaved: (value) => _newMovie.nazivFilma = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
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
                decoration: InputDecoration(labelText: 'Genre'),
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
                decoration: InputDecoration(labelText: 'Director'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _newMovie.opis = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Duration (in minutes)'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _newMovie.trajanje = int.parse(value ?? '0'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Release Year'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _newMovie.godinaIzdanja = int.parse(value ?? '0'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the release year';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Actor>(
                value: null, // Initially, no actor is selected
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
                decoration: InputDecoration(labelText: 'Select Actors'),
                isDense: true, // Reduce the dropdown's height
                isExpanded: true, // Allow the dropdown to take up available horizontal space
              ),
              // Display the selected actors
              Text('Selected Actors:'),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _addMovie();
                  }
                },
                child: Text('Add Movie'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addMovie() async {
    _newMovie.glumciUFlimu = _selectedActors;

    try {
      await _movieService.addMovie(_newMovie);
      // Movie added successfully, you can show a success message or navigate to another screen
    } catch (e) {
      // Handle API error, display an error message
    }
  }
}

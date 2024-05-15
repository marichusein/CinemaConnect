import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecinemadesktop/models/models-all.dart';
import 'package:ecinemadesktop/services/services.dart';
import 'dart:io';

class MovieFormWithFutureBuilder extends StatelessWidget {
  final Map<String, String> header;

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
    try {
      // Fetch your data here
    } catch (e) {
      // Handle errors
    }
  }
}

class MovieForm extends StatefulWidget {
  final Map<String, String> header;

  MovieForm({required this.header});

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
      final List<Genre> genres = await _movieService.fetchGenres(widget.header);
      final List<Director> directors =
          await _movieService.fetchDirectors(widget.header);
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
      body: SingleChildScrollView(
        child: Padding(
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
                SizedBox(height: 10),
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
                  validator: (value) {
                    if (value == null) {
                      return 'Odaberite žanr';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
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
                  validator: (value) {
                    if (value == null) {
                      return 'Odaberite režisera';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Opis'),
                  maxLines: 6,
                  onSaved: (value) => _newMovie.opis = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Unesite opis';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Trajanje (u minutama)'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                      _newMovie.trajanje = int.parse(value ?? '0'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Unesite trajanje';
                    }
                    final intValue = int.tryParse(value);
                    if (intValue == null) {
                      return 'Unesite ispravan broj';
                    }
                    if (intValue < 30 || intValue > 350) {
                      return 'Trajanje filma mora biti između 30 i 350 minuta';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Godina izdanja'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) =>
                      _newMovie.godinaIzdanja = int.parse(value ?? '0'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Unesite godinu izdanja';
                    }
                    final intValue = int.tryParse(value);
                    if (intValue == null) {
                      return 'Unesite ispravan broj';
                    }
                    if (intValue < 1900 || intValue > DateTime.now().year) {
                      return 'Godina izdanja mora biti između 1900 i trenutne godine';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
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
                  validator: (value) {
                    if (_selectedActors.isEmpty) {
                      return 'Odaberite barem jednog glumca';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Odaberite poster filma'),
                ),
                if (_selectedImage != null)
                  Image.file(File(_selectedImage!.path),
                      width: 100, height: 100),
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
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: Text('Dodajte film'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedGenre == null ||
          _selectedDirector == null ||
          _selectedActors.isEmpty ||
          _selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Molimo popunite sva polja'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _addMovie();
    }
  }

  void _addMovie() async {
    _newMovie.glumciUFlimu = _selectedActors;

    try {
      if (_selectedImage != null) {
        final imageBytes = await File(_selectedImage!.path).readAsBytes();
        final base64Image = base64Encode(imageBytes);
        _newMovie.filmPlakat = base64Image;
      }

      await _movieService.addMovie(_newMovie);
      setState(() {
        _message = 'Film je uspješno spremljen!';
      });

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

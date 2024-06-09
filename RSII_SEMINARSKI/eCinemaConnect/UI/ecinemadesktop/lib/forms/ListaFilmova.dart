import 'dart:convert';
import 'dart:io';
import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<dynamic> movies = [];
  List<dynamic> allmovies = [];

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
      allmovies = fetchedMovies;
      isLoading = false;
    });
  }

  Future<void> _toggleMovieStatus(int movieId, bool isActive) async {
    await ApiService.toggleMovieStatus(movieId, isActive);
    _fetchMovies();
  }

  Future<void> _searchMovies(String query) async {
    setState(() {
      isLoading = true;
    });

    if (query.isEmpty) {
      setState(() {
        isLoading = false;
        movies = allmovies;
      });
      return;
    }

    final List<dynamic> searchResults = allmovies
        .where((movie) =>
            movie['nazivFilma'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      isLoading = false;
      movies = searchResults;
    });
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
                            _editMovie(movie['idfilma']);
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
                                            : Colors.black,
                                        colorBlendMode: movie['aktivan']
                                            ? null
                                            : BlendMode.saturation,
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

  Future<void> _editMovie(int movieId) async {
    var movie = movies.firstWhere((element) => element['idfilma'] == movieId);
    await _showEditDialog(
      movieId,
      movie['nazivFilma'],
      movie['opis'],
      movie['trajanje'],
      movie['filmPlakat'],
    );
  }

  Future<void> _showEditDialog(
    int movieId,
    String currentName,
    String currentDescription,
    int currentDuration,
    String currentPoster,
  ) async {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController descriptionController =
        TextEditingController(text: currentDescription);
    TextEditingController durationController =
        TextEditingController(text: currentDuration.toString());

    XFile? newImage;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Movie'),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (newImage != null)
                        Image.file(
                          File(newImage!.path),
                         width: 400,
                          height: 300,
                        )
                      else if (currentPoster.isNotEmpty)
                        Image.memory(
                          base64Decode(currentPoster),
                          width: 400,
                          height: 300,
                        ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final imagePicker = ImagePicker();
                          final XFile? pickedImage = await imagePicker.pickImage(
                              source: ImageSource.gallery);

                          if (pickedImage != null) {
                            setState(() {
                              newImage = pickedImage;
                            });
                          }
                        },
                        child: Text('Pick Poster Image'),
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name ne može biti prazno';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description ne može biti prazna';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: durationController,
                        decoration: InputDecoration(labelText: 'Duration (minutes)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Morate unijeti neku vrijednost';
                          }
                          final intValue = int.tryParse(value);
                          if (intValue == null || intValue < 30 || intValue > 360) {
                            return 'Trajanje mora biti broj i to između 30 i 360 minuta';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Odustani'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Spasi'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        String? base64Image;
                        if (newImage != null) {
                          final imageBytes = await File(newImage!.path).readAsBytes();
                          base64Image = base64Encode(imageBytes);
                        } else {
                          base64Image = currentPoster;
                        }

                        await ApiService.editMovie(
                          movieId,
                          nameController.text,
                          descriptionController.text,
                          int.parse(durationController.text),
                          base64Image,
                        );

                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Film se uspješno uredio')),
                        );
                        _fetchMovies(); // Ponovno učitajte filmove nakon uređivanja
                      } catch (e) {
                        print('Error editing movie: $e');
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

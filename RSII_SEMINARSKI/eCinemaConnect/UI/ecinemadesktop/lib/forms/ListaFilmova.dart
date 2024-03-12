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

  Future<void> _editMovie(int movieId) async {
    // Pronađite film koji se uređuje
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
      String currentPoster) async {
    TextEditingController nameController =
        TextEditingController(text: currentName);
    TextEditingController descriptionController =
        TextEditingController(text: currentDescription);
    TextEditingController durationController =
        TextEditingController(text: currentDuration.toString());


    XFile? newImage;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Movie'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentPoster.startsWith(
                        'data:image')) // Prikaz postojećeg postera iz base64 formata
                      Image.memory(
                        base64Decode(currentPoster.split(',').last),
                        width: 100,
                        height: 100,
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
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 11,
                    ),
                    TextField(
                      controller: durationController,
                      decoration: InputDecoration(labelText: 'Duration'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () async {
                    try {

                      if (newImage != null) {
                      
                            
                        final imageBytes = await File(newImage!.path).readAsBytes();
                        final base64Image = base64Encode(imageBytes);
                         await ApiService.editMovie(
                        movieId,
                        nameController.text,
                        descriptionController.text,
                        int.parse(durationController.text),
                        base64Image,
                      );

                      }

                     
                      Navigator.of(context).pop();
                      _fetchMovies(); // Ponovno učitajte filmove nakon uređivanja
                    } catch (e) {
                      // Handle error
                      print('Error editing movie: $e');
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

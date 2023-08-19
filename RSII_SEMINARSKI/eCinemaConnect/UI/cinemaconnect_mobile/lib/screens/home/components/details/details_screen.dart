import 'package:cinemaconnect_mobile/models/movie.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/bodyD.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Movie movie;
  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BodyD(movie: movie,),);
  }
}
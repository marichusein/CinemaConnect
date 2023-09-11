import 'package:cinemaconnect_mobile/models/movie.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/bodyD.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final Movie movie;
  final int KorisnikID;
  const DetailsScreen({super.key, required this.movie, required this.KorisnikID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BodyD(movie: movie, KorisnikID: KorisnikID,),);
  }
}
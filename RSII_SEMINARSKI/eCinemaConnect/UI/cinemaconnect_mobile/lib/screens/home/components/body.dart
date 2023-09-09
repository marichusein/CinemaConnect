import 'package:cinemaconnect_mobile/const.dart';
import 'package:cinemaconnect_mobile/models/movie.dart';
import 'package:cinemaconnect_mobile/screens/home/components/gener_card.dart';
import 'package:cinemaconnect_mobile/screens/home/components/moviecarousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Categories.dart';
import 'dart:math' as math;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String selectedGenre = "";
  bool isLoading = false; // Dodajte varijablu za praćenje stanja učitavanja

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Category(),
          Genres(
            onGenreSelected: (genre) {
              setState(() {
                selectedGenre = genre;
                isLoading = true; // Postavite isLoading na true pri promjeni žanra
              });
              Future.delayed(Duration(milliseconds: 1500), () {
                setState(() {
                  isLoading = false; // Postavite isLoading na false nakon što se podaci učitaju
                });
              });
            },
          ),
          SizedBox(
            height: kDefaultPadding,
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : MovieCarousel(
                  key: Key(selectedGenre),
                  selectedGenre: selectedGenre,
                ),
        ],
      ),
    );
  }
}

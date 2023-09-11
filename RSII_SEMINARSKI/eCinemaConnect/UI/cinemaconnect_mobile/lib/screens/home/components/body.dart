import 'package:cinemaconnect_mobile/const.dart';
import 'package:cinemaconnect_mobile/screens/home/components/categories.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/NewsCards.dart';
import 'package:cinemaconnect_mobile/screens/home/components/gener_card.dart';
import 'package:cinemaconnect_mobile/screens/home/components/moviecarousel.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final String searchQuery;
  final int KorisnikID;

  const Body({Key? key, required this.searchQuery, required this.KorisnikID}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String selectedGenre = "";
  String selectedCategory = "Trenutno u kinu";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Category(
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
          ),
          if (selectedCategory == "Trenutno u kinu")
            Genres(
              onGenreSelected: (genre) {
                setState(() {
                  selectedGenre = genre;
                  isLoading = true;
                });
                Future.delayed(const Duration(milliseconds: 1500), () {
                  setState(() {
                    isLoading = false;
                  });
                });
              },
            ),
          if (selectedCategory == "Trenutno u kinu")
            const SizedBox(
              height: kDefaultPadding,
            ),
          if (selectedCategory == "Trenutno u kinu")
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : MovieCarousel(
                    key: Key(selectedGenre + widget.searchQuery),
                    selectedGenre: selectedGenre,
                    searchQuery: widget.searchQuery,
                    IDKorisnika: widget.KorisnikID, // Dodajte searchQuery
                  ),
          if (selectedCategory == "Novosti")
            NewsCarousel(
              key: Key('news_${widget.searchQuery}'),
                searchQuery: widget.searchQuery,
                KorisnikID: widget.KorisnikID), // Dodajte searchQuery
        ],
      ),
    );
  }
}

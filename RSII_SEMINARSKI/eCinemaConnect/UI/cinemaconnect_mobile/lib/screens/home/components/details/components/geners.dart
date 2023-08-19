import 'package:cinemaconnect_mobile/const.dart';
import 'package:cinemaconnect_mobile/models/movie.dart';
import 'package:cinemaconnect_mobile/screens/home/components/gener_card.dart';
import 'package:flutter/material.dart';

class Geners extends StatelessWidget {
  final Movie movie;
  const Geners({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: movie.genra.length,
                itemBuilder: (context, index) =>
                    GenerCard(genre: movie.genra[index])),
          ),
        );
  }
}
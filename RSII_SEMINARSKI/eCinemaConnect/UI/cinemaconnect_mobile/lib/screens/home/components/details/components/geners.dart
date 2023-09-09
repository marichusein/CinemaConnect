import 'package:cinemaconnect_mobile/const.dart';
import 'package:cinemaconnect_mobile/models/movie.dart';
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
            child: Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: kDefaultPadding),
      padding:  const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        movie.genra.first,
        style: TextStyle(
          color: Colors.black.withOpacity(0.8),
          fontSize: 16,
          fontFamily: 'SFUIText',
        ),
      ),
    )
          ),
        );
  }
}
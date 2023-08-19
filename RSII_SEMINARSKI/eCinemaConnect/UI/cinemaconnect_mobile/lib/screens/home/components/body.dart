import 'package:cinemaconnect_mobile/const.dart';
import 'package:cinemaconnect_mobile/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'categories.dart';
import 'gener_card.dart';
import 'moviecarousel.dart';
import 'dart:math' as math;

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Category(),
          Genres(),
          SizedBox(
            height: kDefaultPadding,
          ),
          MovieCarousel()
        ],
      ),
    );
  }
}

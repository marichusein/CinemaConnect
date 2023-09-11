import 'package:flutter/material.dart';
import 'package:cinemaconnect_mobile/const.dart';
import 'package:cinemaconnect_mobile/models/movie.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/castandcrew.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/geners.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/titleinfo.dart';
import 'backdrop_rating.dart';

class BodyD extends StatelessWidget {
  final Movie movie;
  final int KorisnikID;
  const BodyD({super.key, required this.movie, required this.KorisnikID});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BackdropRating(size: size, movie: movie, korisnikID: KorisnikID,),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          TitleAndBasicInfo(movie: movie),
          Geners(movie: movie),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2, 
              horizontal: kDefaultPadding
            ),
            child: Text(
              "SADRŽAJ FILMA", 
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              movie.plot, 
              style: const TextStyle(color: Color(0xFF737599)),
            ),
          ),
          CastAndCrew(casts: movie.cast),
        ],
      ),
    );
  }
}

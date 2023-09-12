import 'package:cinemaconnect_mobile/const.dart';
import 'package:cinemaconnect_mobile/models/movie.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/Rezervacija.dart';
import 'package:flutter/material.dart';

class TitleAndBasicInfo extends StatelessWidget {
  final Movie movie;
  final int KorisnikID;

  const TitleAndBasicInfo(
      {super.key, required this.movie, required this.KorisnikID});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: kDefaultPadding / 2),
                Row(
                  children: <Widget>[
                    Text(
                      '${movie.year}',
                      style: const TextStyle(
                        color: kTextLightColor,
                        fontFamily: 'SFUIText',
                      ),
                    ),
                    const SizedBox(
                      width: kDefaultPadding,
                    ),
                    const Text(
                      "PG-13",
                      style: TextStyle(color: kTextLightColor),
                    ),
                    const SizedBox(
                      width: kDefaultPadding,
                    ),
                    Text(
                      "${movie.numOfRatings} min",
                      style: TextStyle(color: kTextLightColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 64,
            width: 64,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProjekcijeSjedistaKomponenta(filmId: movie.id, korisnikID: KorisnikID,),
        ),
      );
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 225, 218, 85), // Set the text color here
              ),
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}

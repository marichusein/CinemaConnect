import 'package:cinemaconnect_mobile/models/movie.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/ratemovie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinemaconnect_mobile/const.dart';

class BackdropRating extends StatelessWidget {
  final Size size;
  final Movie movie;
  const BackdropRating({super.key, required this.size, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.4,
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.4 - 50,
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(50)),
                image: DecorationImage(
                    fit: BoxFit.cover, image: AssetImage(movie.poster))),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size.width * 0.9,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 5),
                      blurRadius: 50,
                      color: const Color(0xFF12153D).withOpacity(0.2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset("assets/icons/star_fill.svg"),
                      const SizedBox(height: kDefaultPadding / 4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFUIText',
                          ),
                          children: [
                            TextSpan(
                              text: "${movie.rating}/10.0",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset("assets/icons/star.svg"),
                      const SizedBox(
                        height: kDefaultPadding / 4,
                      ),
                      GestureDetector(
                        onTap: () async {
                          double userRating = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RatingDialog(movieId: movie.id);
                            },
                          );

                          if (userRating != null) {
                            // Handle the user's rating here, for example, you can send it to a backend API
                            print(
                                "User rated movie ${movie.id} with $userRating stars");
                          }
                        },
                        child: Text(
                          "Ocijeni",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: const Color(0xFF51CF66),
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          "${movie.metascoreRating}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'SFUIText',
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: kDefaultPadding / 4),
                      const Text(
                        "IMDB",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SFUIText',
                        ),
                      ),
                      const Text(
                        "65 kritika",
                        style: TextStyle(color: kTextLightColor),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SafeArea(child: BackButton())
        ],
      ),
    );
  }
}

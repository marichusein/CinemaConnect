import 'package:flutter/material.dart';
import 'package:cinemaconnect_mobile/const.dart';
import 'package:cinemaconnect_mobile/models/news.dart';
import 'package:intl/intl.dart';


class NewsDetailsScreen extends StatelessWidget {
  final News news;
  const NewsDetailsScreen({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalji novosti"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: size.width,
              height: size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(news.slika), // Prikaz slike novosti
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    news.naslov,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  Text(
                    "${news.autorIme} ${news.autorPrezime}",
                    style: TextStyle(
                      color: kTextLightColor,
                    ),
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  Text(
  DateFormat('dd.MM.yyyy').format(news.datumObjave.toLocal()),
  style: TextStyle(
    color: kTextLightColor,
  ),
),
                  SizedBox(height: kDefaultPadding),
                  Text(
                    "SADRŽAJ NOVOSTI",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  Text(
                    news.sadrzaj, // Prikaz sadržaja novosti
                    style: TextStyle(
                      color: kTextLightColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

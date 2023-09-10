import 'dart:convert';

import 'package:cinemaconnect_mobile/models/news.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/NewsDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class NewsCarousel extends StatefulWidget {
  @override
  State<NewsCarousel> createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<NewsCarousel> {
  late PageController _pageController;
  List<News> news = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    fetchNews(); // Dohvati novosti kada se widget inicijalizira.
  }

  Future<void> fetchNews() async {
    final Uri url = Uri.parse('https://localhost:7036/Obavijesti');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> apiNews = json.decode(response.body);

      // Očisti postojeću listu novosti
      news.clear();

      for (var apiNewsItem in apiNews) {
        final String slikaBase64 = apiNewsItem['slika'];
        String slika;

        // Dekodirajte Base64 string u bajt niz
        List<int> decodedBytes = base64Decode(slikaBase64);

        // Kreirajte Image.memory widget sa dekodiranim bajt nizom
        slika = 'data:image/jpeg;base64,${base64Encode(decodedBytes)}';

        final News newsItem = News(
          id: apiNewsItem['idobavijesti'],
          korisnikId: apiNewsItem['korisnikId'],
          naslov: apiNewsItem['naslov'],
          sadrzaj: apiNewsItem['sadrzaj'],
          datumObjave: DateTime.parse(apiNewsItem['datumObjave']),
          slika: slika,
          datumUredjivanja: DateTime.parse(apiNewsItem['datumUredjivanja']),
          autorIme: '', // Postavit ćemo autorovo ime kasnije
          autorPrezime: '', // Postavit ćemo autorovo prezime kasnije
        );

        // Dohvatite detalje o korisniku (autoru)
        await fetchAuthorDetails(newsItem);

        news.add(newsItem);
      }
      setState(() {}); // Pokreni ponovnu izgradnju nakon što se podaci dobave.
    } else {
      throw Exception('Pogreška prilikom učitavanja novosti');
    }
  }

  Future<void> fetchAuthorDetails(News newsItem) async {
    final Uri url = Uri.parse('https://localhost:7036/Korisnici/${newsItem.korisnikId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> authorData = json.decode(response.body);
      newsItem.autorIme = authorData['ime'];
      newsItem.autorPrezime = authorData['prezime'];
    } else {
      throw Exception('Pogreška prilikom dohvata detalja o autoru');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: AspectRatio(
        aspectRatio: 0.85,
        child: PageView.builder(
          controller: _pageController,
          physics: const ClampingScrollPhysics(),
          itemCount: news.length,
          itemBuilder: (context, index) => buildNewsSlider(index),
        ),
      ),
    );
  }

  Widget buildNewsSlider(int index) {
    final News newsItem = news[index];

    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0;
        if (_pageController.position.haveDimensions &&
            _pageController.page != null) {
          value = index - _pageController.page!;
          value = (value * 0.038).clamp(-1, 1);
        }
        return Transform.rotate(
          angle: math.pi * value,
          child: NewsCard(news: newsItem),
        );
      },
    );
  }
}

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({Key? key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailsScreen(news: news),
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(0, 2),
                      blurRadius: 5,
                      spreadRadius: 5,
                    ),
                  ],
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(news.slika),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                news.naslov,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SFUIText',
                    ),
              ),
            ),
            Text(
              '${news.autorIme} ${news.autorPrezime}',
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SFUIText',
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

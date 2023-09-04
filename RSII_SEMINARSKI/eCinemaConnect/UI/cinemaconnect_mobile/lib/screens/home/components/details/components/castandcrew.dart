import 'package:cinemaconnect_mobile/screens/home/components/details/components/castcards.dart';
import 'package:flutter/material.dart';
import 'package:cinemaconnect_mobile/const.dart';



class CastAndCrew extends StatelessWidget {
  final List casts;

  const CastAndCrew({  Key? key, required this.casts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Glumci",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: kDefaultPadding),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: casts.length,
              itemBuilder: (context, index) => CastCard(cast: casts[index]),
            ),
          )
        ],
      ),
    );
  }
}

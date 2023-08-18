import 'package:cinemaconnect_mobile/screens/home/components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar(){
    return AppBar(
        backgroundColor: Color.fromARGB(31, 194, 186, 95),
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/menu12.svg"),
          onPressed: () {},
        ),
        actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {},
        ),
      ],
      );
  }
}

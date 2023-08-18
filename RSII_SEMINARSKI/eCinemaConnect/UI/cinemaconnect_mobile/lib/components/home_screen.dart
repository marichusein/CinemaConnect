import 'package:cinemaconnect_mobile/screens/home/components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: const Body(),
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
         title: const Text(
        "Cinema Connect", 
        style: TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold, 
          fontFamily: "SFUIText",
          color: Colors.black87,
        ),
      ),
      centerTitle: true, 
        actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {},
        ),
      ],
      );
  }
}
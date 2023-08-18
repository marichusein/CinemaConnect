import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cinemaconnect_mobile/screens/home/components/body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      drawer: buildDrawer(),
      body: SingleChildScrollView(
        child: Body(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(31, 194, 186, 95),
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu12.svg"),
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer(); // Open the side menu
        },
      ),
      title: _isSearching
          ? TextField(
              // Add your text field properties here
              onChanged: (query) {
                // Handle search query
              },
            )
          : Text(
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
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
            });
          },
        ),
      ],
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              "Husein Marić",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "SFUIText",
                color: Colors.black87,
              ),
            ), // Replace with the user's name
            accountEmail: Text(
              "husein.maric@edu.fit.ba",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "SFUIText",
                color: Colors.black87,
              ),
            ), // Replace with the user's email
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                  "assets/images/profile_picture.jpg"), // Replace with the user's profile picture
            ),
            decoration: BoxDecoration(
              color: Color.fromARGB(31, 194, 186, 95),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Moj profil',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "SFUIText",
                color: Colors.black87,
              ),
            ),
            onTap: () {
              // Handle navigation to profile or any other action
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              'Moje rezervacije',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "SFUIText",
                color: Colors.black87,
              ),
            ),
            onTap: () {
              // Handle navigation to reservations or any other action
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text(
              'Preporuka',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "SFUIText",
                color: Colors.black87,
              ),
            ),
            onTap: () {
              // Handle navigation to recommendations or any other action
              Navigator.pop(context); // Close the drawer
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Podešavanja',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "SFUIText",
                color: Colors.black87,
              ),
            ),
            onTap: () {
              // Handle navigation to settings or any other action
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

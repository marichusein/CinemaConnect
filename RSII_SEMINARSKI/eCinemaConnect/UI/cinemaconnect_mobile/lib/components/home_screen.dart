import 'dart:convert';
import 'package:cinemaconnect_mobile/api-konstante.dart';
import 'package:cinemaconnect_mobile/screens/home/components/LoginScreen.dart';
import 'package:cinemaconnect_mobile/screens/home/components/body.dart';
import 'package:cinemaconnect_mobile/screens/home/components/details/components/MojeProjekcije.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final int userId;
  final Map<String, String> header;

  const HomeScreen({Key? key, required this.userId, required this.header})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  late String firstName = "";
  late String lastName = "";
  late String email = "";
  late String newPassword = "";
  late String username = "";
  late String telefon = "";


  final String baseUrl = ApiKonstante.baseUrl;
  

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final response = await http.get(
      Uri.parse('$baseUrl/Korisnici/${widget.userId}'),
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      setState(() {
        firstName = userData['ime'];
        lastName = userData['prezime'];
        email = userData['email'];
        username=userData['korisnickoIme'];
        telefon=userData['telefon'];
        
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> updateUserData() async {
    final response = await http.put(
      Uri.parse('$baseUrl/Korisnici/${widget.userId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ime': firstName,
        'prezime': lastName,
        'telefon': telefon,
        'korisnickoIme': username,
        'email': email,
        'lozinika': newPassword, // Ažurirajte lozinku prema potrebi
      }),
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop(); // Zatvaranje forme
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Podaci su uspješno ažurirani' + widget.userId.toString())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ažuriranje podataka nije uspjelo')),
      );
    }
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
              controller: searchController,
              onChanged: (query) {
                filterResults(query);
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
              "$firstName $lastName",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "SFUIText",
                color: Colors.black87,
              ),
            ),
            accountEmail: Text(
              email,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "SFUIText",
                color: Colors.black87,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile_picture1.jpg"),
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
              // Otvorite formu za uređivanje profila
              openEditProfileForm();
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
               Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => RezervacijeComponent(userId: widget.userId, header: widget.header), // Primjer userId i headera
              ),
            ); 
            }
          ),
      
          ListTile(
            // Dodani dio za odjavu
            leading: Icon(Icons.logout),
            title: Text(
              'Odjavi se',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "SFUIText",
                color: Colors.black87,
              ),
            ),
            onTap: () {
              
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(),
                ),
                (Route<dynamic> route) =>
                    false, // Da biste uklonili sve prethodne ekrane iz stoga
              );
            },
          ),
        ],
      ),
    );
  }

void openEditProfileForm() {
  // Kontroleri za input polja
  final firstNameController = TextEditingController(text: firstName);
  final lastNameController = TextEditingController(text: lastName);
  final usernameController = TextEditingController(text: username);
  final telefonController = TextEditingController(text: telefon);
  final emailController = TextEditingController(text: email);
  final newPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Uredi profil'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        firstName = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Ime',
                      errorText: firstName.isEmpty ? 'Polje ne smije biti prazno' : null,
                    ),
                    controller: firstNameController,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        lastName = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Prezime',
                      errorText: lastName.isEmpty ? 'Polje ne smije biti prazno' : null,
                    ),
                    controller: lastNameController,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Username',
                      errorText: username.isEmpty ? 'Polje ne smije biti prazno' : null,
                    ),
                    controller: usernameController,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        telefon = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Telefon',
                      errorText: telefon.isEmpty ? 'Polje ne smije biti prazno' : null,
                    ),
                    controller: telefonController,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: email.isEmpty ? 'Polje ne smije biti prazno' : null,
                    ),
                    controller: emailController,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        newPassword = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Nova lozinka'),
                    obscureText: true, // Skrivanje unesene lozinke
                    controller: newPasswordController,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Refresh UI to show error messages
                      if (firstName.isNotEmpty && lastName.isNotEmpty && username.isNotEmpty && telefon.isNotEmpty && email.isNotEmpty) {
                        updateUserData();
                        Navigator.of(context).pop(); // Zatvori dijalog nakon uspješne validacije
                      }
                    },
                    child: Text('Spasi promjene'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Zatvori'),
              ),
            ],
          );
        },
      );
    },
  );
}




  void filterResults(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      drawer: buildDrawer(),
      body: SingleChildScrollView(
        child: Body(
          searchQuery: searchQuery,
          KorisnikID: widget.userId,
          header: widget.header,
        ),
      ),
    );
  }
}

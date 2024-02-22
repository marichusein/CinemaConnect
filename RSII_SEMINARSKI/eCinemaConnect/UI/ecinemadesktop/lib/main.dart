import 'package:ecinemadesktop/forms/ActorForm.dart';
import 'package:ecinemadesktop/forms/AllActors.dart';
import 'package:ecinemadesktop/forms/BusinessReportForm.dart';
import 'package:ecinemadesktop/forms/CreateAccountForm.dart';
import 'package:ecinemadesktop/forms/DirectorForm.dart';
import 'package:ecinemadesktop/forms/EditProfile.dart';
import 'package:ecinemadesktop/forms/MovieForm.dart';
import 'package:ecinemadesktop/forms/AddObavijestiForm.dart';
import 'package:ecinemadesktop/forms/PregeldObavijesti.dart';
import 'package:ecinemadesktop/forms/ProjekcijaForm.dart';
import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinema Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _performLogin(BuildContext context) async {
    String enteredUsername = _usernameController.text;
    String enteredPassword = _passwordController.text;

    // Stvorite objekt s podacima za prijavu
    final loginData = {
      "korisnickoIme": enteredUsername,
      "lozinka": enteredPassword,
    };

    try {
      // Pošaljite zahtjev za prijavu koristeći LoginService
      final userData = await LoginService().login(loginData);

      // Ako je prijava uspješna, prikažite korisničko ime i prezime na ekranu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Prijavljeni ste kao ${userData['ime']} ${userData['prezime']}"),
        ),
      );

      // Navigirajte na ekran UserDashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserDashboard(
            idkorisnika: userData['idkorisnika'],
            Username: userData['ime'] + ' ' + userData['prezime'],
          ),
        ),
      );
    } catch (error) {
      // U slučaju pogreške, prikažite poruku
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Neuspjela prijava. Provjerite korisničko ime i lozinku. ${LoginService().baseUrl}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.movie,
                    size: 80,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () =>
                        _performLogin(context), // Pass context to _performLogin
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/cinema1.png',
                    height: 250,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CreateAccountForm(),
                        ),
                      );
                    },
                    icon: Icon(Icons.person_add),
                    label: Text('Create New Account'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to add user screen
                    },
                    icon: Icon(Icons.person_add_alt),
                    label: Text('Add User'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserDashboard extends StatelessWidget {
  final int idkorisnika;
  final String Username;

  const UserDashboard(
      {super.key, required this.idkorisnika, required this.Username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CINEMA CONNECT'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Uredi profil') {
                // Navigirajte na ekran za uređivanje profila
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfileForm(idkorisnika: idkorisnika),
                  ),
                );
              } else if (value == 'Odjava') {
                // Odjava korisnika i povratak na ekran za prijavu
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return ['Uredi profil', 'Odjava'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    this.Username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildNavItem(Icons.movie, 'Dodaj film', context,
                          MovieForm()), // Pass MovieForm as the destination
                      _buildNavItem(Icons.person, 'Dodaj glumca', context,
                          ActorForm() /* Add Actor screen here */), // Add Actor destination
                      // Add more navigation items as needed
                      _buildNavItem(Icons.person_2_outlined, 'Pregled glumaca',
                          context, GlumciScreen()),
                      _buildNavItem(Icons.person_add, 'Dodaj režisera', context,
                          DodajReziseraForma()),
                      _buildNavItem(
                          Icons.newspaper,
                          'Dodaj obavijest',
                          context,
                          ObavijestForm(
                            korisnikId: idkorisnika,
                          )),
                      _buildNavItem(Icons.newspaper_rounded,
                          'Pregled obavijesti', context, NotificationScreen()),
                      _buildNavItem(Icons.movie_edit, 'Nova projekcija',
                          context, DodavanjeProjekcijeScreen()),
                      _buildNavItem(
                        Icons.insert_chart_outlined, // Ikona za izvještaje
                        'Kreiraj izvještaj poslovanja', // Tekst za dugme
                        context,
                        BusinessReportForm(), // Destinacija je BusinessReportForm
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'CINEMACONNECT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Add your content for the dashboard here
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, BuildContext context, Widget destination) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        // Navigate to the specified destination widget
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => destination,
          ),
        );
      },
    );
  }
}

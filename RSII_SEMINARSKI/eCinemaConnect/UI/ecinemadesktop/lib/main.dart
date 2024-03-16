import 'package:ecinemadesktop/forms/ActorForm.dart';
import 'package:ecinemadesktop/forms/Add-Edit-meni.dart';
import 'package:ecinemadesktop/forms/AllActors.dart';
import 'package:ecinemadesktop/forms/BusinessReportForm.dart';
import 'package:ecinemadesktop/forms/CreateAccountForm.dart';
import 'package:ecinemadesktop/forms/DirectorForm.dart';
import 'package:ecinemadesktop/forms/EditProfile.dart';
import 'package:ecinemadesktop/forms/KomentariForms.dart';
import 'package:ecinemadesktop/forms/KomentariObavijestiForms.dart';
import 'package:ecinemadesktop/forms/ListaFilmova.dart';
import 'package:ecinemadesktop/forms/ModelPrepruke.dart';
import 'package:ecinemadesktop/forms/MovieForm.dart';
import 'package:ecinemadesktop/forms/AddObavijestiForm.dart';
import 'package:ecinemadesktop/forms/PregeldMenija.dart';
import 'package:ecinemadesktop/forms/PregeldObavijesti.dart';
import 'package:ecinemadesktop/forms/PregledProjekcija.dart';
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
      final userDatas = await LoginService().login(loginData);
      final headers = userDatas['headers'];
      final userData = userDatas['userData'];
      // Ako je prijava uspješna, prikažite korisničko ime i prezime na ekranu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Prijavljeni ste kao ${userData['ime']} ${userData['prezime']}"),
        ),
      );

      print('ID korisnika: ${userData['idkorisnika'] ?? 1}');
      print('Korisničko ime: ${userData['ime']} ${userData['prezime']}');
      print('Zaglavlje: $headers');

      // Navigirajte na ekran UserDashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserDashboard(
            idkorisnika: userData['idkorisnika'] ?? 1,
            Username: userData['ime'] + ' ' + userData['prezime'],
            header: headers,
          ),
        ),
      );
    } catch (error) {
      // U slučaju pogreške, prikažite poruku
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Neuspjela prijava. Provjerite korisničko ime i lozinku'),
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
                      backgroundColor: Colors.blue,
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
                    label: Text('Create New Admin Account'),
                  ),
                  SizedBox(height: 20),
                 
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
  final Map<String, String> header;

  const UserDashboard(
      {Key? key,
      required this.idkorisnika,
      required this.Username,
      required this.header})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CINEMA CONNECT'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Uredi profil') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfileForm(idkorisnika: idkorisnika),
                  ),
                );
              } else if (value == 'Odjava') {
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
            child: SingleChildScrollView(
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
                        ExpansionTile(
                          title: Text('Filmovi'),
                          leading: Icon(Icons.movie),
                          children: [
                            _buildNavItem(
                              Icons.movie,
                              'Dodaj film',
                              context,
                              MovieForm(
                                header: header,
                              ),
                            ),
                            _buildNavItem(
                              Icons.movie_filter,
                              'Pregled filmova',
                              context,
                              MovieListPage(),
                            ),
                            _buildNavItem(
                              Icons.movie_edit,
                              'Nova projekcija',
                              context,
                              DodavanjeProjekcijeScreen(),
                            ),
                            _buildNavItem(
                              Icons.movie_creation_sharp,
                              'Uredi postojeće projekcije',
                              context,
                              ProjekcijeScreen(),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Glumci'),
                          leading: Icon(Icons.person),
                          children: [
                            _buildNavItem(
                              Icons.person,
                              'Dodaj glumca',
                              context,
                              ActorForm(),
                            ),
                            _buildNavItem(
                              Icons.person_2_outlined,
                              'Pregled glumaca',
                              context,
                              GlumciScreen(),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Obavijesti', selectionColor: Colors.white),
                          leading: Icon(Icons.newspaper),
                          children: [
                            _buildNavItem(
                              Icons.newspaper,
                              'Dodaj obavijest',
                              context,
                              ObavijestForm(
                                korisnikId: idkorisnika,
                              ),
                            ),
                            _buildNavItem(
                              Icons.newspaper_rounded,
                              'Pregled obavijesti',
                              context,
                              NotificationScreen(),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Brisanje komentara', selectionColor: Colors.white),
                          leading: Icon(Icons.comment_bank_outlined),
                          children: [
                            _buildNavItem(
                              Icons.comment_bank,
                              'Pregled i brisanje komentara filmova',
                              context,
                              CommentsScreen(),
                            ),
                            _buildNavItem(
                              Icons.comment_bank,
                              'Pregled i brisanje komentara obavijesti',
                              context,
                              CommentListWidget(),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text('Menu Kina', selectionColor: Colors.white),
                          leading: Icon(Icons.food_bank_sharp),
                          children: [
                            _buildNavItem(
                              Icons.food_bank,
                              'Dodaj menu',
                              context,
                              MenuItemForm(),
                            ),
                            _buildNavItem(
                              Icons.food_bank_outlined,
                              'Pregled menija',
                              context,
                              MenusList(),
                            ),
                          ],
                        ),
                        _buildNavItem(
                          Icons.person_add,
                          'Dodaj režisera',
                          context,
                          DodajReziseraForma(),
                        ),
                        _buildNavItem(
                          Icons.insert_chart_outlined,
                          'Kreiraj izvještaj poslovanja',
                          context,
                          BusinessReportForm(),
                        ),
                        _buildNavItem(
                          Icons.insert_chart_outlined,
                          'Utreniraj model preporuke',
                          context,
                          ModelPreporuke(),
                          
                        ),
                      ],
                    ),
                  ],
                ),
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => destination,
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ecinemadesktop/services/services.dart';

class EditProfileForm extends StatefulWidget {
  final int idkorisnika;

  EditProfileForm({required this.idkorisnika});

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final userData = await ProfileService().getUserProfile(widget.idkorisnika);
      setState(() {
        _firstNameController.text = userData['ime'] ?? '';
        _lastNameController.text = userData['prezime'] ?? '';
      });
    } catch (error) {
      // Handle error
    }
  }

  void _updateProfile(BuildContext context) async {
    String enteredFirstName = _firstNameController.text;
    String enteredLastName = _lastNameController.text;
    String enteredPassword = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Provjerite podudaranje lozinke i potvrde lozinke
    if (enteredPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lozinke se ne podudaraju."),
        ),
      );
      return;
    }

    // Provjerite regex za lozinku
    RegExp passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#\$&*~]).{8,}$');
    if (!passwordRegex.hasMatch(enteredPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lozinka mora sadržavati najmanje 8 znakova, 1 veliko slovo i 1 specijalni znak."),
        ),
      );
      return;
    }

    // Stvorite objekt s podacima za ažuriranje profila
    final profileData = {
      "idkorisnika": widget.idkorisnika,
      "ime": enteredFirstName,
      "prezime": enteredLastName,
      "lozinka": enteredPassword,
    };

    try {
      // Pošaljite zahtjev za ažuriranje profila koristeći servis
      await ProfileService().updateProfile(profileData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profil je uspješno ažuriran."),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Došlo je do pogreške prilikom ažuriranja profila."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uredi profil"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: "Ime"),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: "Prezime"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: "Nova lozinka",
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  child: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: "Potvrdi lozinku",
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  child: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _updateProfile(context),
              child: Text("Ažuriraj profil"),
            ),
          ],
        ),
      ),
    );
  }
}

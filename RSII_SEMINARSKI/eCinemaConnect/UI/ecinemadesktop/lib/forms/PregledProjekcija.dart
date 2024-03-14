import 'dart:convert';
import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projekcije',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProjekcijeScreen(),
    );
  }
}

class ProjekcijeScreen extends StatefulWidget {
  @override
  _ProjekcijeScreenState createState() => _ProjekcijeScreenState();
}

class _ProjekcijeScreenState extends State<ProjekcijeScreen> {
  List<Projekcija> projekcije = [];

  @override
  void initState() {
    super.initState();
    _fetchProjekcije();
  }

  Future<void> _fetchProjekcije() async {
  try {
    final List<Projekcija> fetchedProjekcije = await ApiService.fetchProjekcije();
    setState(() {
      projekcije = fetchedProjekcije;
    });
  } catch (e) {
    print('Error fetching projekcije: $e');
    // handle error as needed
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projekcije'),
      ),
      body: ListView.builder(
        itemCount: projekcije.length,
        itemBuilder: (context, index) {
          return ProjekcijaCard(projekcija: projekcije[index]);
        },
      ),
    );
  }
}


class ProjekcijaCard extends StatefulWidget {
  final Projekcija projekcija;

  ProjekcijaCard({required this.projekcija});

  @override
  _ProjekcijaCardState createState() => _ProjekcijaCardState();
}

class _ProjekcijaCardState extends State<ProjekcijaCard> {
  late DateTime _editedDatumVrijemeProjekcije;
  late double _editedCijenaKarte;

  @override
  void initState() {
    super.initState();
    _editedDatumVrijemeProjekcije = widget.projekcija.datumVrijemeProjekcije;
    _editedCijenaKarte = widget.projekcija.cijenaKarte;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.memory(
          base64Decode(widget.projekcija.film.filmPlakat),
          width: 100,
          height: 150,
          fit: BoxFit.cover,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.projekcija.film.nazivFilma,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Datum i vrijeme: ${_editedDatumVrijemeProjekcije}',
            ),
            Text(
              'Cijena karte: ${_editedCijenaKarte}',
            ),
            Text(
              'Sala: ${widget.projekcija.sala.nazivSale}',
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            _showEditDialog(context);
          },
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uredi projekciju'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Novo vrijeme projekcije'),
                  initialValue: _editedDatumVrijemeProjekcije.toString(),
                  onChanged: (value) {
                    setState(() {
                      _editedDatumVrijemeProjekcije = DateTime.parse(value);
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nova cijena karte'),
                  initialValue: _editedCijenaKarte.toString(),
                  onChanged: (value) {
                    setState(() {
                      _editedCijenaKarte = double.parse(value);
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Potvrdi'),
              onPressed: () {
                _editProjekcija();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editProjekcija() async {
  try {
    await ApiService.editProjekcija(widget.projekcija, _editedDatumVrijemeProjekcije, _editedCijenaKarte);
    // handle successful edit as needed
  } catch (e) {
    print('Error editing projekcija: $e');
    // handle error as needed
  }
}

}

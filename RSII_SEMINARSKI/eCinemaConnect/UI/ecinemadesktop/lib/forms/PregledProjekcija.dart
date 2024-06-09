import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ecinemadesktop/services/services.dart';

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
          return ProjekcijaCard(
            projekcija: projekcije[index],
            onEditSuccess: _fetchProjekcije,
          );
        },
      ),
    );
  }
}

class ProjekcijaCard extends StatefulWidget {
  final Projekcija projekcija;
  final VoidCallback onEditSuccess;

  ProjekcijaCard({required this.projekcija, required this.onEditSuccess});

  @override
  _ProjekcijaCardState createState() => _ProjekcijaCardState();
}

class _ProjekcijaCardState extends State<ProjekcijaCard> {
  late DateTime _editedDatumVrijemeProjekcije;
  late double _editedCijenaKarte;
  final _formKey = GlobalKey<FormState>();
  final _datumController = TextEditingController();
  final _cijenaController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _editedDatumVrijemeProjekcije = widget.projekcija.datumVrijemeProjekcije;
    _datumController.text = _editedDatumVrijemeProjekcije.toString();
    _editedCijenaKarte = widget.projekcija.cijenaKarte;
    _cijenaController.text = _editedCijenaKarte.toString();
  }

  @override
  void dispose() {
    _datumController.dispose();
    _cijenaController.dispose();
    super.dispose();
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
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: _datumController,
                    readOnly: true,
                    decoration: InputDecoration(labelText: 'Novo vrijeme projekcije'),
                    onTap: () async {
                      final selectedDate = await _selectDateTime(context);
                      if (selectedDate != null) {
                        setState(() {
                          _editedDatumVrijemeProjekcije = selectedDate;
                          _datumController.text = _editedDatumVrijemeProjekcije.toString();
                        });
                      }
                    },
                    validator: (value) {
                      if (_editedDatumVrijemeProjekcije.isBefore(DateTime.now())) {
                        return 'Datum i vrijeme ne smiju biti u prošlosti';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cijenaController,
                    decoration: InputDecoration(labelText: 'Nova cijena karte'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _editedCijenaKarte = double.tryParse(value) ?? 0;
                      });
                    },
                    validator: (value) {
                      final parsedValue = double.tryParse(value ?? '');
                      if (parsedValue == null || parsedValue < 1 || parsedValue > 20) {
                        return 'Cijena mora biti broj između 1 i 20';
                      }
                      return null;
                    },
                  ),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Potvrdi'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _editProjekcija();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _editedDatumVrijemeProjekcije,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_editedDatumVrijemeProjekcije),
      );
      if (pickedTime != null) {
        return DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
    return null;
  }

  Future<void> _editProjekcija() async {
    try {
      await ApiService.editProjekcija(widget.projekcija, _editedDatumVrijemeProjekcije, _editedCijenaKarte);
      widget.onEditSuccess();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Projekcija uspješno spremljena')));
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error editing projekcija: $e';
      });
    }
  }
}

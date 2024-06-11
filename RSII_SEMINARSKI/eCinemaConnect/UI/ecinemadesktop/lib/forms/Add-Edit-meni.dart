import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MenuItemForm extends StatefulWidget {
  final int? menuItemId;

  MenuItemForm({this.menuItemId});

  @override
  _MenuItemFormState createState() => _MenuItemFormState();
}

class _MenuItemFormState extends State<MenuItemForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nazivController = TextEditingController();
  TextEditingController _opisController = TextEditingController();
  TextEditingController _cijenaController = TextEditingController();
  XFile? _imageFile;
  bool _imageNotSelectedError = false;

  @override
  void initState() {
    super.initState();
    if (widget.menuItemId != null) {
      // If editing existing menu item, fetch its details and populate the form
      _fetchMenuItemDetails();
    }
  }

  Future<void> _fetchMenuItemDetails() async {
    try {
      var data = await ApiService.fetchMenuItemDetails(widget.menuItemId!);
      Uint8List imageData = base64Decode(data['slika']);
      String tempPath = (await getTemporaryDirectory()).path;
      String filePath =
          '$tempPath/menu_item_image_${DateTime.now().millisecondsSinceEpoch}.png';
      File imageFile = File(filePath);
      await imageFile.writeAsBytes(imageData);
      setState(() {
        _nazivController.text = data['naziv'];
        _opisController.text = data['opis'];
        _cijenaController.text = data['cijena'].toString();
        _imageFile = XFile(filePath);
      });
    } catch (e) {
      print('Failed to fetch menu item details: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = XFile(pickedFile.path);
        _imageNotSelectedError = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        setState(() {
          _imageNotSelectedError = true;
        });
        return;
      }

      // Convert image to base64
      Uint8List? imageBytes = await _imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Prepare data
      var data = {
        "naziv": _nazivController.text,
        "opis": _opisController.text,
        "cijena": double.parse(_cijenaController.text),
        "slika": base64Image,
      };

      try {
        await ApiService.submitMenuItem(data, widget.menuItemId);
        // Handle success
        print(
            'Menu item ${widget.menuItemId != null ? 'updated' : 'added'} successfully');
        _showSuccessMessage();
        _clearForm();
      } catch (e) {
        // Handle error
        print(
            'Failed to ${widget.menuItemId != null ? 'update' : 'add'} menu item: $e');
      }
    }
  }

  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(
              'Menu item ${widget.menuItemId != null ? 'updated' : 'added'} successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _nazivController.clear();
    _opisController.clear();
    _cijenaController.clear();
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.menuItemId != null ? 'Uredi Meni' : 'Dodaj Meni Grickalica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nazivController,
                decoration: InputDecoration(labelText: 'Naziv'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite naziv';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _opisController,
                decoration: InputDecoration(labelText: 'Opis'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite opis';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cijenaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Cijena'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Unesite cijenu';
                  }
                  double? cijena = double.tryParse(value);
                  if (cijena == null || cijena <= 0 || cijena >= 25) {
                    return 'Cijena mora biti broj veći od 0 i manji od 25';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_imageFile == null && _imageNotSelectedError)
                Text(
                  'Nema odabrane slike',
                  style: TextStyle(color: Colors.red),
                ),
              if (_imageFile != null)
                Image.file(
                  File(_imageFile!.path),
                  fit: BoxFit.fitHeight,
                  width: 300,
                  height: 300,
                ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Odaberi sliku'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                    widget.menuItemId != null ? 'Uredi Meni' : 'Dodaj Meni'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MenuItemForm(),
  ));
}

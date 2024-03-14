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
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
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
      } catch (e) {
        // Handle error
        print(
            'Failed to ${widget.menuItemId != null ? 'update' : 'add'} menu item: $e');
      }
    }
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
                  return null;
                },
              ),
              SizedBox(height: 20),
              _imageFile == null
                  ? Text('Nema odabrane slike')
                  : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
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

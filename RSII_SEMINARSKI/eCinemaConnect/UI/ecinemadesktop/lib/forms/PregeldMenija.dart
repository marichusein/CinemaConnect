import 'dart:convert';
import 'package:ecinemadesktop/forms/Add-Edit-meni.dart';
import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';

class MenusList extends StatefulWidget {
  @override
  _MenusListState createState() => _MenusListState();
}

class _MenusListState extends State<MenusList> {
  late Future<List<dynamic>> _menusFuture;

  @override
  void initState() {
    super.initState();
    _menusFuture = _menusFuture = ApiService.fetchMenus();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pregled Menija'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _menusFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var menu = snapshot.data![index];
                var base64Image = menu['slika'] as String;
                return ListTile(
                  leading: Image.memory(base64Decode(base64Image), width: 100, height: 100),
                  title: Text(menu['naziv']),
                  subtitle: Text(menu['opis']),
                  trailing: Text('${menu['cijena']} KM'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuItemForm(menuItemId: menu['idgrickalice'])),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
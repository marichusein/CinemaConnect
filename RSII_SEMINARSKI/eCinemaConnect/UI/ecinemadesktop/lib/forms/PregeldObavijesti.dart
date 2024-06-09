// ignore_for_file: invalid_use_of_protected_member

import 'dart:io';
import 'dart:typed_data';
import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  String filterDate = "";
  String filterTitle = "";

  Future<void> fetchNotifications() async {
    notifications = await ApiService.fetchNotifications();
    setState(() {
      // Ažuriranje stanja s novim obavijestima
    });
  }

  Future<Map<String, dynamic>> fetchUser(int userId) async {
    return await ApiService.fetchUserNotification(userId);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        filterDate =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Obavijesti"),
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Filter by Title'),
                    onChanged: (value) {
                      setState(() {
                        filterTitle = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Filter by Date',
                      suffixIcon: IconButton(
                        onPressed: () => _selectDate(context),
                        icon: Icon(Icons.calendar_today),
                      ),
                    ),
                    controller: TextEditingController(text: filterDate),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Implement filter functionality here
                      // You can use filterTitle and filterDate for filtering notifications
                    });
                  },
                  child: Text("Apply Filters"),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filterTitle = "";
                      filterDate = "";
                      fetchNotifications();
                    });
                  },
                  child: Text("Reset Filters"),
                ),
              ],
            ),
          ),

          Expanded(
            child: NotificationGrid(
              notifications: notifications,
              filterTitle: filterTitle,
              filterDate: filterDate,
              fetchUser: fetchUser,
              showNotificationDetails: _showNotificationDetails,
              fetchNotifications: fetchNotifications, // Pass fetchNotifications
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(
      BuildContext context, Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(notification['naslov']),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Image.memory(
                  base64Decode(notification['slika']),
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(notification['sadrzaj'] ?? 'No content'),
                    SizedBox(height: 16),
                    FutureBuilder<Map<String, dynamic>>(
                      future: fetchUser(notification['korisnikId']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                              "Error fetching author data: ${snapshot.error}");
                        } else if (snapshot.hasData) {
                          final authorData = snapshot.data!;
                          return Text(
                              "Autor: ${authorData['ime']} ${authorData['prezime']}");
                        } else {
                          return Text("N/A");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Zatvori dijalog
              },
              child: Text("Zatvori"),
            ),
          ],
        );
      },
    );
  }
}

class NotificationGrid extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;
  final String filterTitle;
  final String filterDate;
  final Future<Map<String, dynamic>> Function(int userId) fetchUser;
  final void Function(BuildContext context, Map<String, dynamic> notification)
      showNotificationDetails;
  final VoidCallback fetchNotifications; // Add fetchNotifications parameter

  NotificationGrid({
    required this.notifications,
    required this.filterTitle,
    required this.filterDate,
    required this.fetchUser,
    required this.showNotificationDetails,
    required this.fetchNotifications, // Initialize fetchNotifications
  });

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = notifications.where((notification) {
      final titleMatches = filterTitle.isEmpty ||
          notification['naslov']
              .toLowerCase()
              .contains(filterTitle.toLowerCase());
      final dateMatches = filterDate.isEmpty ||
          notification['datumObjave'].startsWith(filterDate);
      return titleMatches && dateMatches;
    }).toList();

    if (filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No notifications found.'),
            SizedBox(height: 16),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.1,
      ),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return NotificationCard(
          notification: notification,
          fetchUser: fetchUser,
          showNotificationDetails: () =>
              showNotificationDetails(context, notification),
          fetchNotifications: fetchNotifications, // Pass fetchNotifications
        );
      },
    );
  }
}

class NotificationCard extends StatefulWidget {
  final Map<String, dynamic> notification;
  final Future<Map<String, dynamic>> Function(int userId) fetchUser;
  final VoidCallback showNotificationDetails;
  final VoidCallback fetchNotifications; // Add fetchNotifications parameter

  NotificationCard({
    required this.notification,
    required this.fetchUser,
    required this.showNotificationDetails,
    required this.fetchNotifications, // Initialize fetchNotifications
  });

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  Map<String, dynamic>? authorData;

  @override
  void initState() {
    super.initState();
    fetchAuthorData();
  }

  Future<void> fetchAuthorData() async {
    final userId = widget.notification['korisnikId'];
    try {
      final userData = await widget.fetchUser(userId);
      setState(() {
        authorData = userData;
      });
    } catch (e) {
      print("Error fetching author data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.showNotificationDetails();
      },
      child: Card(
        margin: EdgeInsets.all(9),
        child: ListView(
          children: [
            Image.memory(
              base64Decode(widget.notification['slika']),
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.notification['naslov'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.notification['sadrzaj'].length > 40
                        ? widget.notification['sadrzaj'].substring(0, 40) +
                            '...'
                        : widget.notification['sadrzaj'] ?? 'No content',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Autor: ${authorData != null ? '${authorData!['ime']} ${authorData!['prezime']}' : 'N/A'}",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditNotificationScreen(
                      notification: widget.notification,
                      obavijestID: widget.notification['idobavijesti'],
                      fetchNotifications: widget.fetchNotifications,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditNotificationScreen extends StatefulWidget {
  final Map<String, dynamic> notification;
  final int obavijestID;
  final VoidCallback fetchNotifications;

  EditNotificationScreen({
    required this.notification,
    required this.obavijestID,
    required this.fetchNotifications,
  });

  @override
  _EditNotificationScreenState createState() => _EditNotificationScreenState();
}

class _EditNotificationScreenState extends State<EditNotificationScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? titleError;
  String? contentError;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.notification['naslov'];
    contentController.text = widget.notification['sadrzaj'] ?? '';
    _loadImage();
  }

  Future<void> _loadImage() async {
    if (widget.notification.containsKey('slika')) {
      Uint8List imageData = base64Decode(widget.notification['slika']);
      String tempPath = (await getTemporaryDirectory()).path;
      String filePath =
          '$tempPath/image_${DateTime.now().millisecondsSinceEpoch}.png';
      File imageFile = File(filePath);
      await imageFile.writeAsBytes(imageData);
      setState(() {
        _imageFile = XFile(filePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Notification'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_imageFile != null)
              Image.file(
                File(_imageFile!.path),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _pickImage();
              },
              child: Text('Upload New Image'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                errorText: titleError,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                errorText: contentError,
              ),
              maxLines: null, // Omogućava višelinijsko tekstualno polje
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateNotification();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _updateNotification() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      setState(() {
        titleError = titleController.text.isEmpty ? 'Title is required' : null;
        contentError =
            contentController.text.isEmpty ? 'Content is required' : null;
      });
      return;
    }

    try {
      // Konvertujemo sliku u base64 format
      String imageBase64 = '';
      if (_imageFile != null) {
        List<int> imageBytes = File(_imageFile!.path).readAsBytesSync();
        imageBase64 = base64Encode(imageBytes);
      }

      // Konvertujemo datum u string u formatu ISO 8601
      String dateTimeNow = DateTime.now().toIso8601String();

      // Formiramo JSON objekat za slanje na API
      Map<String, dynamic> requestData = {
        "naslov": titleController.text,
        "sadrzaj": contentController.text,
        "slika": imageBase64,
        "datumUredjivanja": dateTimeNow
      };

      // Pozivamo API servis za uređivanje obavijesti
      await ApiService.editObavijest(widget.obavijestID, requestData);

      // Ako izvršenje dođe do ovde, obavijest je uspješno ažurirana
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Obavijest je uspješno ažurirana')),
      );

      // Vraćamo se na prethodnu stranicu i osvježavamo obavijesti
      widget.fetchNotifications(); // Osvježi obavijesti nakon uređivanja
      Navigator.pop(context, true);
    } catch (e) {
      // Ako se izuzetak dogodi, prikazujemo odgovarajuću poruku korisniku
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Došlo je do greške prilikom ažuriranja obavijesti: $e')),
      );
    }
  }
}

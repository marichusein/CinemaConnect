import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final response =
        await http.get(Uri.parse("https://localhost:7036/Obavijesti"));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      setState(() {
        notifications = responseData.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<Map<String, dynamic>> fetchUser(int userId) async {
    final response =
        await http.get(Uri.parse("https://localhost:7036/Korisnici/$userId"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
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
              ],
            ),
          ),

          Expanded(
            child: NotificationGrid(
              notifications: notifications,
              filterTitle: filterTitle,
              filterDate: filterDate,
              fetchUser: fetchUser,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationGrid extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;
  final String filterTitle;
  final String filterDate;
  final Future<Map<String, dynamic>> Function(int userId) fetchUser;

  NotificationGrid({
    required this.notifications,
    required this.filterTitle,
    required this.filterDate,
    required this.fetchUser,
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

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Broj kolona
        childAspectRatio: 1.2, // Omjer visine i širine
      ),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return NotificationCard(
          notification: notification,
          fetchUser: fetchUser,
        );
      },
    );
  }
}

class NotificationCard extends StatefulWidget {
  final Map<String, dynamic> notification;
  final Future<Map<String, dynamic>> Function(int userId) fetchUser;

  NotificationCard({required this.notification, required this.fetchUser});

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
    return Card(
      margin: EdgeInsets.all(8),
      child: ListView( // Dodali smo ListView oko sadržaja kartice
        children: [
          Image.memory(
            base64Decode(
                widget.notification['slika']), // Decode the base64 image data
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.notification['sadrzaj'] != null &&
                          widget.notification['sadrzaj'].length > 40
                      ? widget.notification['sadrzaj'].substring(0, 40) + "..."
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
        ],
      ),
    );
  }
}

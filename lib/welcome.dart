import 'package:flutter/material.dart';
import 'home.dart';
import 'info.dart';
import 'gallery.dart';
import 'login.dart';
import 'notification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  final String username;

  const WelcomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  String username = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _pages = [
      HomeScreen(username: username),
      const InfoScreen(),
      const GalleryScreen(),
    ];
  }

  Future<void> _fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      final response = await http.get(Uri.parse(
          'https://praktikum-cpanel-unbin.com/solev/lugowo/profile_koichi.php?id=$userId'));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == true && result['data'].isNotEmpty) {
          setState(() {
            username = result['data'][0]['username'];
            _pages[0] = HomeScreen(username: username);
          });
        }
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: isDarkMode
            ? Colors.black
            : const Color.fromARGB(255, 171, 171, 171),
        foregroundColor: const Color.fromARGB(255, 255, 214, 64),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.5),
        leading: IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Show a confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        child: const Text('No'),
                        style: TextButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 255, 208, 0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        style: TextButton.styleFrom(
                          foregroundColor: Color.fromARGB(255, 255, 208, 0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Navigate back to the LoginScreen
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 255, 214, 64),
        unselectedItemColor: isDarkMode ? Colors.grey[600] : Colors.black,
        backgroundColor: isDarkMode
            ? Colors.black
            : const Color.fromARGB(255, 171, 171, 171),
        onTap: _onItemTapped,
      ),
    );
  }
}

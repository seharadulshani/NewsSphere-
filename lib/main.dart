import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pavani/screens/book_mark.dart';
import 'package:pavani/screens/fav_screen.dart';
import 'package:pavani/screens/home_screen.dart';
import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:pavani/screens/headlines_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      return const GetMaterialApp(
        title: 'Headline Hive',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Index to keep track of the selected tab
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();


  // Handle the tab change
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Update the selected tab
    });
  }

  // List of screens that correspond to each tab
  final List<Widget> _screens = [
    HomeScreen(),
    SearchNews(),
    FavScreen(),
    BookmarkedArticlesScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],  // Display the selected screen here

      // Bottom Navigation Bar (CrystalNavigationBar or BottomNavigationBar)
      bottomNavigationBar: DotCurvedBottomNav(
        hideOnScroll: true,
        indicatorColor: Colors.blue,
        scrollController: _scrollController,
        backgroundColor: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.ease,
        selectedIndex: _selectedIndex,
        indicatorSize: 5,
        borderRadius: 25,
        height: 70,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: [
          Icon(
            Icons.home,
            color: _selectedIndex == 0 ? Colors.blue : Colors.white,
          ),
          Icon(
            Icons.view_headline,
            color: _selectedIndex == 1 ? Colors.blue : Colors.white,
          ),
          Icon(
            Icons.date_range,
            color: _selectedIndex == 2 ? Colors.blue : Colors.white,
          ),
          Icon(
            Icons.download_done,
            color: _selectedIndex == 3 ? Colors.blue : Colors.white,
          ),
        ],
      ),
    );
  }
}
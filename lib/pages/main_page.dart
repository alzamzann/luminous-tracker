import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminous_tracker/pages/dashboard_page.dart';
import 'package:luminous_tracker/pages/view_order_page.dart';
import 'package:luminous_tracker/pages/add_order_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _children = [
    DashboardPage(),
    ViewOrderPage(),
  ]; //0 Dashboard, 1 List Order
  int currIndex = 0;

  void onPressed(int index) {
    setState(() {
      currIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currIndex],
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFE9BA55),
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 16,
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFE9BA55).withOpacity(0.9),
                const Color(0xFFE9BA55),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => onPressed(0),
                icon: Icon(
                  Icons.home,
                  color: currIndex == 0 ? Colors.brown : Colors.brown[300],
                  size: 28,
                ),
              ),
              SizedBox(width: 20),
              IconButton(
                onPressed: () => onPressed(1),
                icon: Icon(
                  Icons.shopping_cart,
                  color: currIndex == 1 ? Colors.brown : Colors.brown[300],
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

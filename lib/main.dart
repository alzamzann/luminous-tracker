import 'package:flutter/material.dart';
import 'package:luminous_tracker/pages/main_page.dart';
import 'package:luminous_tracker/pages/login.dart';
import 'package:luminous_tracker/pages/view_order_page.dart';
import 'package:luminous_tracker/pages/add_order_page.dart';
import 'package:luminous_tracker/pages/dashboard_page.dart';
import 'package:luminous_tracker/pages/add_paket_page.dart';
import 'package:luminous_tracker/pages/view_paket_page.dart';
import 'package:luminous_tracker/pages/add_coupon_page.dart';
import 'package:luminous_tracker/pages/view_coupon_page.dart';

void main() {  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Luminous Design',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/main': (context) => const MainPage(),
        '/home': (context) => const ViewOrderPage(), // List Order
        '/dashboard': (context) => const DashboardPage(),
        '/order': (context) => const AddOrderPage(),
        '/add-paket': (context) => const AddPaketPage(),
        '/view-paket': (context) => const ViewPaketPage(),
        '/coupon': (context) => const AddCouponPage(),
        '/view-coupon': (context) => const ViewCouponPage(),
      },
    );
  }
}

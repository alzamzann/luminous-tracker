import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luminous_tracker/container/dashboard_text.dart';
import 'package:luminous_tracker/container/button.dart';
import 'package:luminous_tracker/pages/add_coupon_page.dart';
import 'package:luminous_tracker/pages/view_order_page.dart';
import 'package:luminous_tracker/pages/main_page.dart';
import 'package:luminous_tracker/pages/add_order_page.dart';
import 'package:luminous_tracker/pages/add_paket_page.dart';
import 'package:luminous_tracker/pages/view_coupon_page.dart';
import 'package:luminous_tracker/pages/view_paket_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List dataOrder = [];
  List dataCoupon = [];
  List dataService = [];
  int totalOrders = 0;
  int onProgressCount = 0;
  int completedCount = 0;
  int totalCoupons = 0;
  int totalServices = 0;

  @override
  void initState() {
    super.initState();
    getData();
    getCoupons();
    getServices();
  }

  Future<void> getData() async {
    try {
      String url = "http://localhost/api_luminous/readOrders.php";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          dataOrder = jsonDecode(response.body);
          totalOrders = dataOrder.length;

          // Hitung jumlah orders berdasarkan status
          onProgressCount =
              dataOrder.where((order) => order['status'] == '1').length;
          completedCount =
              dataOrder.where((order) => order['status'] == '0').length;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> getCoupons() async {
    try {
      String url = "http://localhost/api_luminous/readCoupon.php";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          dataCoupon = jsonDecode(response.body);
          totalCoupons = dataCoupon.length;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> getServices() async {
    try {
      String url = "http://localhost/api_luminous/readService.php";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          dataService = jsonDecode(response.body);
          totalServices = dataService.length;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9BA55),
      appBar: AppBar(
        title: Text(
          "Admin",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.brown,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/login", (route) => false);
            },
            icon: Icon(Icons.logout, color: Colors.white),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFE9BA55),
          ),
          child: Column(
            children: [
              // Dashboard Container
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DashboardText(
                      keyword: "Total Orders",
                      value: totalOrders.toString(),
                      textColor: Colors.white,
                    ),
                    Divider(color: Colors.white.withOpacity(0.2)),
                    DashboardText(
                      keyword: "On Progress",
                      value: onProgressCount.toString(),
                      textColor: Colors.white,
                    ),
                    Divider(color: Colors.white.withOpacity(0.2)),
                    DashboardText(
                      keyword: "Completed",
                      value: completedCount.toString(),
                      textColor: Colors.white,
                    ),
                    Divider(color: Colors.white.withOpacity(0.2)),
                    DashboardText(
                      keyword: "Total Paket Layanan",
                      value: totalServices.toString(),
                      textColor: Colors.white,
                    ),
                    Divider(color: Colors.white.withOpacity(0.2)),
                    DashboardText(
                      keyword: "Total Kupon",
                      value: totalCoupons.toString(),
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),

              // Admin Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: HomeButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewPaketPage()),
                              );
                            },
                            name: "Paket Layanan",
                            color: Colors.brown,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: HomeButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewCouponPage()),
                              );
                            },
                            name: "Coupons",
                            color: Colors.brown,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

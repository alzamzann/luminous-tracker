import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:luminous_tracker/pages/add_coupon_page.dart';

class ViewCouponPage extends StatefulWidget {
  const ViewCouponPage({super.key});

  @override
  State<ViewCouponPage> createState() => ViewCouponPageState();
}

class ViewCouponPageState extends State<ViewCouponPage> {
  List dataCoupon = [];

  Future<void> getData() async {
    try {
      String url = "http://localhost/api_luminous/readCoupon.php";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          dataCoupon = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9BA55),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Daftar Kupon",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.brown,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFE9BA55),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard Kupon
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.card_giftcard,
                                  color: const Color(0xFFE9BA55),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Kupon",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    dataCoupon.length.toString(),
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        height: 80,
                        width: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddCouponPage()),
                            ).then((_) => getData());
                          },
                          child: Icon(Icons.add, color: Colors.white, size: 30),
                        ),
                      ),
                    ],
                  ),
                ),

                // Text Daftar Kupon
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Daftar Kupon",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),

                // List Kupon
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dataCoupon.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.brown[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.card_giftcard,
                              color: Colors.brown,
                            ),
                          ),
                          title: Text(
                            dataCoupon[index]['kode'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          subtitle: Text(
                            'Potongan: ${dataCoupon[index]['potongan']}%',
                            style: TextStyle(
                              color: const Color(0xFFE9BA55),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.brown),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Hapus Kupon'),
                                  content:
                                      Text('Yakin ingin menghapus kupon ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Batal',
                                          style: TextStyle(
                                              color: Colors.brown[300])),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteData(
                                            dataCoupon[index]['id_coupon']);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Hapus',
                                          style:
                                              TextStyle(color: Colors.brown)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteData(String id) async {
    try {
      final response = await http.post(
          Uri.parse("http://localhost/api_luminous/deleteCoupon.php"),
          body: {
            "id_coupon": id,
          });

      if (response.statusCode == 200) {
        getData(); // Refresh data setelah hapus
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kupon berhasil dihapus')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus kupon')),
      );
    }
  }
}

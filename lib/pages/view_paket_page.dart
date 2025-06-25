import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:luminous_tracker/pages/add_paket_page.dart';

class ViewPaketPage extends StatefulWidget {
  const ViewPaketPage({super.key});

  @override
  State<ViewPaketPage> createState() => ViewPaketPageState();
}

class ViewPaketPageState extends State<ViewPaketPage> {
  List dataPaket = [];

  Future<void> getData() async {
    try {
      String url = "http://localhost/api_luminous/readService.php";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          dataPaket = jsonDecode(response.body);
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
          "Daftar Paket Layanan",
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
                // Dashboard Paket
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
                                color: Colors.black.withOpacity(0.4),
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
                                child: Icon(Icons.design_services,
                                    color: const Color(0xFFE9BA55)),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Paket",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(dataPaket.length.toString(),
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white, fontSize: 14)),
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
                                  builder: (context) => AddPaketPage()),
                            ).then((_) => getData());
                          },
                          child: Icon(Icons.add, color: Colors.white, size: 30),
                        ),
                      ),
                    ],
                  ),
                ),

                // Text Daftar Paket
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Daftar Paket",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),

                // List Paket
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dataPaket.length,
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
                              Icons.design_services,
                              color: Colors.brown,
                            ),
                          ),
                          title: Text(
                            dataPaket[index]['nama'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          subtitle: Text(
                            'Harga: Rp ${NumberFormat('#,###').format(int.parse(dataPaket[index]['harga']))}',
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
                                  title: Text('Hapus Paket'),
                                  content:
                                      Text('Yakin ingin menghapus paket ini?'),
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
                                            dataPaket[index]['id_service']);
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
          Uri.parse("http://localhost/api_luminous/deletePaket.php"),
          body: {
            "id_service": id,
          });

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success']) {
          getData(); // Refresh data setelah hapus
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
        }
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus paket')),
      );
    }
  }
}

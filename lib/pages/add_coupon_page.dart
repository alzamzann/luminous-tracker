import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:luminous_tracker/pages/main_page.dart';
import 'package:luminous_tracker/pages/view_coupon_page.dart';

class AddCouponPage extends StatefulWidget {
  const AddCouponPage({super.key});

  @override
  State<AddCouponPage> createState() => _AddCouponPageState();
}

class _AddCouponPageState extends State<AddCouponPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _potonganController = TextEditingController();

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
          "Tambah Kupon",
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _kodeController,
                      decoration: InputDecoration(
                        labelText: "Kode Kupon",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                        labelStyle: TextStyle(color: Colors.brown),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Kode kupon tidak boleh kosong";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _potonganController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Potongan (%)",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                        labelStyle: TextStyle(color: Colors.brown),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Potongan tidak boleh kosong";
                        }
                        if (int.tryParse(value) == null) {
                          return "Potongan harus berupa angka";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            insertCoupon();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void insertCoupon() async {
    try {
      final response = await http.post(
          Uri.parse("http://localhost/api_luminous/insertCoupon.php"),
          body: {
            'kode': _kodeController.text,
            'potongan': _potonganController.text,
          });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kupon berhasil ditambahkan')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewCouponPage()),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }
}

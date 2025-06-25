import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:luminous_tracker/pages/view_order_page.dart';
import 'package:luminous_tracker/pages/main_page.dart';
import 'dart:convert';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  String _nama = "";
  String? _selectedPaket;
  bool isProgress = true;
  List<String> listOrder = [];
  late String dropDownValue = '';

  TextEditingController dateController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getServices();
  }

  Future<void> getServices() async {
    try {
      final response = await http
          .get(Uri.parse("http://localhost/api_luminous/readService.php"));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          listOrder = data.map((item) => item['nama'].toString()).toList();
          if (listOrder.isNotEmpty) {
            dropDownValue = listOrder.first;
            _selectedPaket = listOrder.first;
          }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Tambah Order",
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
                    // Status Switch
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status Order:",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                isProgress ? "Progress" : "Done",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Switch(
                                value: isProgress,
                                onChanged: (bool value) {
                                  setState(() {
                                    isProgress = value;
                                  });
                                },
                                activeColor: const Color(0xFFE9BA55),
                                activeTrackColor: Colors.brown[300],
                                inactiveThumbColor: const Color(0xFFE9BA55),
                                inactiveTrackColor: Colors.brown[300],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Form Fields
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Nama Pemesan",
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
                          return "Nama Pemesan tidak boleh kosong";
                        }
                        _nama = value;
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    Text(
                      "Pilih Paket",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Dropdown
                    DropdownButtonFormField<String>(
                      value: listOrder.isEmpty ? null : dropDownValue,
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.brown),
                        ),
                      ),
                      items: listOrder.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPaket = value;
                          dropDownValue = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Date Fields
                    TextField(
                      readOnly: true,
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: "Tanggal Order",
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
                        suffixIcon:
                            Icon(Icons.calendar_today, color: Colors.brown),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.brown,
                                  onPrimary: Colors.white,
                                  surface: const Color(0xFFE9BA55),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          dateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        }
                      },
                    ),
                    SizedBox(height: 16),

                    TextField(
                      readOnly: true,
                      controller: deadlineController,
                      decoration: InputDecoration(
                        labelText: "Deadline",
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
                        suffixIcon:
                            Icon(Icons.calendar_today, color: Colors.brown),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Colors.brown,
                                  onPrimary: Colors.white,
                                  surface: const Color(0xFFE9BA55),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          deadlineController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        }
                      },
                    ),
                    SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            insertData(
                              _nama,
                              _selectedPaket ?? "",
                              dateController.text,
                              isProgress,
                              deadlineController.text,
                              context,
                            );
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
}

void insertData(String nama, String paket, String tanggal, bool isProgress,
    String deadline, BuildContext context) async {
  try {
    final response = await http.post(
        Uri.parse("http://localhost/api_luminous/insertOrders.php"),
        body: {
          'data_nama': nama,
          'data_paket': paket,
          'data_orderDate': tanggal,
          'data_status': isProgress ? '1' : '0',
          'data_deadline': deadline
        });

    if (response.statusCode == 200) {
      // Kembali ke HomePage dan refresh
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ViewOrderPage()),
      ).then((_) {
        // Memastikan data ter-refresh
        if (context.mounted) {
          final homeState = context.findAncestorStateOfType<ViewOrderPageState>();
          homeState?.getData();
        }
      });
    }
  } catch (e) {
    print(e);
  }
}

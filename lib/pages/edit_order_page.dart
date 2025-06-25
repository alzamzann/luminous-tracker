import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:luminous_tracker/pages/view_order_page.dart';
import 'package:luminous_tracker/pages/main_page.dart';

class EditOrderPage extends StatefulWidget {
  final String id;
  final String nama;
  final String paket;
  final String orderDate;
  final String deadline;
  final String status;

  const EditOrderPage({
    Key? key,
    required this.id,
    required this.nama,
    required this.paket,
    required this.orderDate,
    required this.deadline,
    required this.status,
  }) : super(key: key);

  @override
  State<EditOrderPage> createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late String _selectedPaket;
  late bool isProgress;
  late TextEditingController dateController;
  late TextEditingController deadlineController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai awal
    _namaController = TextEditingController(text: widget.nama);
    _selectedPaket = widget.paket;
    isProgress = widget.status == '1';
    dateController = TextEditingController(text: widget.orderDate);
    deadlineController = TextEditingController(text: widget.deadline);
  }

  List<String> listOrder = [
    'Logo Basic',
    'Logo Standar',
    'Logo Premium',
    'Vector Basic',
    'Vector Standar',
    'Bundle 2-In',
    'Bundle All-In'
  ];
  late String dropDownValue = listOrder.first;

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
          "Edit Order",
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

                    // Nama Pemesan Field
                    TextFormField(
                      controller: _namaController,
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

                    // Dropdown Paket
                    DropdownButtonFormField<String>(
                      value: dropDownValue,
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
                      onChanged: (String? value) {
                        setState(() {
                          _selectedPaket = value!;
                          dropDownValue = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Tanggal Order Field
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

                    // Deadline Field
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

                    // Update Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            updateData();
                          }
                        },
                        child: Text(
                          "Update",
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

  void updateData() async {
    try {
      final response = await http.post(
          Uri.parse("http://localhost/api_luminous/updateOrder.php"),
          body: {
            'id_order': widget.id,
            'data_nama': _namaController.text,
            'data_paket': _selectedPaket,
            'data_orderDate': dateController.text,
            'data_deadline': deadlineController.text,
            'data_status': isProgress ? '1' : '0',
          });

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ViewOrderPage()),
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

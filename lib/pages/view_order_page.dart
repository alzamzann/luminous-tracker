import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:luminous_tracker/pages/edit_order_page.dart';
import 'package:luminous_tracker/pages/add_order_page.dart';
import 'package:luminous_tracker/pages/main_page.dart';

class ViewOrderPage extends StatefulWidget {
  const ViewOrderPage({super.key});

  @override
  State<ViewOrderPage> createState() => ViewOrderPageState();
}

class ViewOrderPageState extends State<ViewOrderPage> {
  List dataOrder = [];

  Future<void> getData() async {
    try {
      String url = "http://localhost/api_luminous/readOrders.php";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          dataOrder = jsonDecode(response.body);
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
    // int ongoingCount = 0;
    // int completedCount = 0;

    // for (var order in dataOrder) {
    //   if (order['status'] == '1') {
    //     ongoingCount++;
    //   } else {
    //     completedCount++;
    //   }
    // }

    return Scaffold(
      backgroundColor: const Color(0xFFE9BA55),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainPage()),
            );
          }
        ),
        // automaticallyImplyLeading: false,
        title: Text(
          "Orders",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                //Dashboard Order
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
                                child: Icon(Icons.receipt_long,
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
                                    "Total Order",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(dataOrder.length.toString(),
                                      style: TextStyle(
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
                                  builder: (context) => AddOrderPage()),
                            ).then((_) => getData());
                          },
                          child: Icon(Icons.add, color: Colors.white, size: 30),
                        ),
                      ),
                    ],
                  ),
                ),

                // List Orders
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),

                // List view dengan background semi-transparan
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dataOrder.length,
                    itemBuilder: (context, index) {
                      final order = dataOrder[index];
                      final orderDate = DateTime.parse(order['orderDate']);
                      final deadline = DateTime.parse(order[
                          'deadline']); // Menggunakan deadline dari database
                      final isOverdue = order['status'] == '1' &&
                          DateTime.now().isAfter(deadline);

                      return Card(
                        elevation: 10,
                        child: ListTile(
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // TODO: Implement delete
                                    showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Hapus Order'),
                                      content:
                                          Text('Yakin ingin menghapus order ini?'),
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
                                                dataOrder[index]['id_order']);
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
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditOrderPage(
                                        id: dataOrder[index]['id_order'],
                                        nama: dataOrder[index]['nama'],
                                        paket: dataOrder[index]['paket'],
                                        orderDate: dataOrder[index]
                                            ['orderDate'],
                                        deadline: dataOrder[index]['deadline'],
                                        status: dataOrder[index]['status'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          title: Text(dataOrder[index]['nama'] ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dataOrder[index]['paket'] ?? ''),
                              Text(
                                  'Tanggal Order: ${DateFormat('dd/MM/yyyy').format(orderDate)}'),
                              if (dataOrder[index]['status'] == '1')
                                Text(
                                  'Deadline: ${DateFormat('dd/MM/yyyy').format(deadline)}',
                                  style: TextStyle(
                                      color: isOverdue
                                          ? Colors.red
                                          : Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                            ],
                          ),
                          leading: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: dataOrder[index]['status'] == '1'
                                  ? (isOverdue
                                      ? Colors.red[100]
                                      : Colors.orange[100])
                                  : Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              dataOrder[index]['status'] == '1'
                                  ? Icons.timelapse
                                  : Icons.check,
                              color: dataOrder[index]['status'] == '1'
                                  ? (isOverdue ? Colors.red : Colors.orange)
                                  : Colors.green,
                            ),
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

  void deleteData(String a) async {
    String uri = "http://localhost/api_luminous/deleteOrder.php";
    http.post(Uri.parse(uri), body: {
      "data_id_order": a,
    });
    getData();
  }
}

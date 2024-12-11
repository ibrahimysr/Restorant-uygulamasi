import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';

class PastOrderPage extends StatefulWidget {
  const PastOrderPage({super.key});

  @override
  _PastOrderPageState createState() => _PastOrderPageState();
}

class _PastOrderPageState extends State<PastOrderPage> {
  List<Map<String, dynamic>> pastOrder = [];

  @override
  void initState() {
    super.initState();
    _fetchPastOrder();
  }

  Future<void> _fetchPastOrder() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Kullanıcılar')
          .doc(user.uid)
          .get();
      setState(() {
        pastOrder =
            List<Map<String, dynamic>>.from(userDoc['Geçmiş Siparişler']);
        pastOrder = pastOrder.reversed.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor,
      appBar: AppBar(
        backgroundColor: appcolor,
        title: Text("Geçmiş Siparişler",
            style: TextStyleClass.mainTitle.copyWith(fontSize: 25)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: textColor,
            )),
      ),
      body: ListView.builder(
        itemCount: pastOrder.length,
        itemBuilder: (context, index) {
          final order = pastOrder[index];
          final sepet = List<Map<String, dynamic>>.from(order['sepet']);
          final tarih = order['tarih'].toDate();
          final formattedDate =
              "${tarih.year}-${_formatTwoDigits(tarih.month)}-${_formatTwoDigits(tarih.day)} - ${_formatTwoDigits(tarih.hour)}:${_formatTwoDigits(tarih.minute)}"; // Tarihi istenen formatta formatla
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: appcolor2,
              ),
              child: ExpansionTile(
                trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_drop_down_sharp,
                      color: textColor,
                    )),
                backgroundColor: enabledColor,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Tarih: - $formattedDate",
                      style: TextStyleClass.mainContent,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Text(
                        "Konum: ${order['konum']}",
                        style: TextStyleClass.mainContent,
                      ),
                    ),
                  ],
                ),
                children: sepet.map((item) {
                  return Column(
                    children: [
                      Container(
                        color: enabledColor,
                        child: ListTile(
                          title: Text(
                            item['isim'],
                            style: TextStyleClass.mainContent,
                          ),
                          subtitle: Text("Fiyat: ${item['fiyat']} ₺",
                              style: TextStyleClass.mainContent),
                          leading: item['url'] != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(item['url']),
                                )
                              : null,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTwoDigits(int num) {
    return num.toString().padLeft(2, '0');
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:food_menu/service/card_service.dart';
import 'package:food_menu/views/location.dart';
import 'package:provider/provider.dart';
import 'package:food_menu/service/food_service.dart';
import 'package:food_menu/service/user_service.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:food_menu/views/details_page.dart';

class CardStreamBuilder extends StatelessWidget {
  const CardStreamBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final FoodService foodService = FoodService();
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    final cartProvider = Provider.of<CartProvider>(context);
    var sepet;

    return Scaffold(
      backgroundColor: appcolor,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: foodService.getCardStream(currentUser!.uid.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("Bir Bilgi Bulunamadı"));
                } else {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  sepet =
                      List<Map<String, dynamic>>.from(userData['sepet'] ?? []);

                  if (sepet.isEmpty) {
                    return const Center(child: Text("Bir Bilgi Bulunamadı"));
                  }

                  return ListView.builder(
                    itemCount: sepet.length,
                    itemBuilder: (context, index) {
                      final food = sepet[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(food),
                              ),
                            );
                          },
                          child: Card(
                            color: appcolor2,
                            child: ListTile(
                              title: Text(
                                food["isim"],
                                style: TextStyleClass.mainContent.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  foodService.deleteCard(
                                    context,
                                    userProvider.currentUser!,
                                    food,
                                  );
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(food["url"]),
                                radius: 30,
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    food["fiyat"].toString(),
                                    style: TextStyleClass.mainContent,
                                  ),
                                  const Text(
                                    " ₺",
                                    style: TextStyle(
                                        color: enabledColor, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fiyat",
                      style: TextStyle(color: Color(0xffA99A97), fontSize: 18),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartProvider.totalPrice.toString(),
                          style: TextStyleClass.mainContent,
                        ),
                        const Text(
                          " ₺",
                          style: TextStyle(color: enabledColor, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: enabledColor,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Location(
                            sepet: sepet,
                          ),
                        ));
                  },
                  child: Text(
                    "Sepeti Onayla",
                    style: TextStyleClass.mainTitle.copyWith(fontSize: 18),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

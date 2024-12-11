import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FoodService {

  Stream<QuerySnapshot> getFoodsStream(String selectCategory) {
    final CollectionReference foodCollection =
        FirebaseFirestore.instance.collection(selectCategory);

    return foodCollection.snapshots();
  }
    Stream<DocumentSnapshot> getCardStream(String userId) {
    final DocumentReference userDoc = FirebaseFirestore.instance
        .collection('Kullanıcılar')
        .doc(userId);

    return userDoc.snapshots();
  }

  List<Map<String, dynamic>> searchFood(
    List<Map<String, dynamic>> foods, String query) {
    String lowercaseQuery = query.toLowerCase();

    return foods.where((food) {
      String foodName = food['isim'].toLowerCase();
      return foodName.contains(lowercaseQuery);
    }).toList();
  }

  Future<void> addToCart(BuildContext context, String userId, String isim, String detay, String fiyat, String url) async {
    try {
      final cartItem = {
        "isim": isim,
        "detay": detay,
        "fiyat": fiyat,
        "url": url,
      };

      await FirebaseFirestore.instance
          .collection('Kullanıcılar')
          .doc(userId)
          .update({
        "sepet": FieldValue.arrayUnion([cartItem])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ürün Sepete Eklendi")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }
   Future<void> deleteCard(BuildContext context, User user,
      Map<String, dynamic> task) async {
    try {
      String userId = user.uid;

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("Kullanıcılar").doc(userId);

      await userDoc.update({
        "sepet": FieldValue.arrayRemove([task])
      });
    } catch (e) {
      debugPrint("Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.");
    }
  }

  Future<void> placeOrder(BuildContext context, String userId, String location, List<Map<String, dynamic>> sepet) async {
  try {
    Timestamp now = Timestamp.now();

    // Yeni bir sipariş dokümanı oluştur
    Map<String, dynamic> orderData = {
      'userId': userId,
      'konum': location,
      'sepet': sepet,
      'tarih': now,
    };

    // Siparişler koleksiyonuna yeni sipariş ekleyin
    await FirebaseFirestore.instance
        .collection('Siparişler')
        .add(orderData);

          await FirebaseFirestore.instance
          .collection('Kullanıcılar')
          .doc(userId)
          .update({
        "Geçmiş Siparişler": FieldValue.arrayUnion([orderData])
      });

 

    // Sepeti temizleme (isteğe bağlı)
    await clearCart(userId);

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sipariş verilirken hata oluştu: $e")),
    );
  }
}

Future<void> clearCart(String userId) async {
  try {
    // Kullanıcının sepetini temizleme
    await FirebaseFirestore.instance
        .collection('Kullanıcılar')
        .doc(userId)
        .update({
      "sepet": [],
    });
  } catch (e) {
    print("Sepet temizlenirken hata oluştu: $e");
  }
}

}

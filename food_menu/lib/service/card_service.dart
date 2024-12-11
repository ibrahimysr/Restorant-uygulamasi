import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartProvider extends ChangeNotifier {
  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _userId;

  CartProvider() {
    _userId = _auth.currentUser!.uid;
    _fetchTotalPrice();
    _listenToCartChanges();
  }

  Future<void> _fetchTotalPrice() async {
    double total = 0.0;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Kullanıcılar')
          .doc(_userId)
          .get();

      if (userDoc.exists) {
        List<dynamic> sepet = userDoc['sepet'];
        for (var item in sepet) {
          String priceString = item['fiyat'];
          double price = double.tryParse(priceString) ?? 0.0;
          total += price;
        }
      }
    } catch (e) {
      debugPrint("Error calculating total cart price: $e");
    }

    _totalPrice = total;
    notifyListeners();
  }

  void _listenToCartChanges() {
    FirebaseFirestore.instance
        .collection('Kullanıcılar')
        .doc(_userId)
        .snapshots()
        .listen((snapshot) {
      double total = 0.0;

      if (snapshot.exists) {
        List<dynamic> sepet = snapshot['sepet'];
        for (var item in sepet) {
          String priceString = item['fiyat'];
          double price = double.tryParse(priceString) ?? 0.0;
          total += price;
        }
      }

      _totalPrice = total;
      notifyListeners();
    });
  }
}

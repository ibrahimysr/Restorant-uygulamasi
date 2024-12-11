import 'package:flutter/material.dart';
import 'package:food_menu/service/user_service.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:food_menu/widget/card_streambuilder.dart';
import 'package:provider/provider.dart';

class ShoppingCard extends StatefulWidget {
  const ShoppingCard({super.key});

  @override
  State<ShoppingCard> createState() => _ShoppingCardState();
}

class _ShoppingCardState extends State<ShoppingCard> {

    


  @override
  Widget build(BuildContext context) {

         final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    return SafeArea(
      child: 
      currentUser != null ?
       Scaffold(
        backgroundColor: appcolor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Sepet",style: TextStyleClass.mainTitle,),
            ),
           const Expanded(child: CardStreamBuilder()),
           
          ],
        ),
      ) : const Text("Veril Bulunamadı")
    );
  }
}
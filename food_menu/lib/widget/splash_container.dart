import 'package:flutter/material.dart';
import 'package:food_menu/style/textstyle.dart';

import 'package:food_menu/views/control_page.dart';
import 'package:lottie/lottie.dart';
import '../../style/color.dart';

Widget splashContainer(String title, String lottieTitle,context) {
  return Container(
    color: appcolor,
    child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(title, style: TextStyleClass.mainTitle),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          height: 220,
          width: 220,
          child: Lottie.network(lottieTitle, fit: BoxFit.fill),
        ),
      ),
      SizedBox(
        width: 300,
        height: 65,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ControlPage(),));
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(width: 2, color: Colors.white),
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            )),
            backgroundColor: enabledColor,
          ),
          child: Text(
            "Devam Et",
            style: TextStyleClass.mainContent
                .copyWith(color: textColor, fontSize: 20),
          ),
        ),
      ),
    ])),
  );
}

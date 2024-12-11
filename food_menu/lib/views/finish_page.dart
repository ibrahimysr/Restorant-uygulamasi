import 'package:flutter/material.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:food_menu/views/control_page.dart';
import 'package:food_menu/widget/mybutton.dart';
import 'package:lottie/lottie.dart';

class FinishPage extends StatefulWidget {
  const FinishPage({super.key});

  @override
  State<FinishPage> createState() => _FinishPageState();
}

class _FinishPageState extends State<FinishPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      backgroundColor: appcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset("assets/konfeti.json")),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Tebrikler",
                    style: TextStyleClass.mainTitle,
                  ),
                  Text(
                    "Siparişiniz Alınmıştır",
                    style: TextStyleClass.mainTitle,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: myButton(() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ControlPage(),
                    ));
              }, "Ana Sayfada Dön"),
            )
          ],
        ),
      ),
    );
  }
}


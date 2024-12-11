import 'package:flutter/material.dart';
import 'package:food_menu/service/auth_service.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:food_menu/widget/mybutton.dart';
import 'package:provider/provider.dart';


class ForgatPasswordPage extends StatefulWidget {
  const ForgatPasswordPage({super.key});

  @override
  State<ForgatPasswordPage> createState() => _ForgatPasswordPageState();
}

class _ForgatPasswordPageState extends State<ForgatPasswordPage> {
  final TextEditingController _passwordResetcontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back,color: textColor,)),
        backgroundColor: appcolor,
        centerTitle: true,
        title: Text("Şifrenizi Sıfırlayın",style:TextStyleClass.mainContent.copyWith( 
        fontSize: 20
      )),),
      backgroundColor: appcolor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "E-posta adresinizi girin",
                style: TextStyleClass.mainContent,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: appcolor2,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      border: Border.all(color: textColor)),
                  child: TextField(
                    controller: _passwordResetcontroller,
                    style: const TextStyle(color: textColor),
                    decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        iconColor: enabledColor,
                        border: InputBorder.none,
                        hintText: "E-posta",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
              ),
              myButton2(
                 
                  () => {
                        context
                            .read<FlutterFireAuthService>()
                            .passwordReset(_passwordResetcontroller.text.trim(),context)
                      }, "Şifreyi Sıfırla",) ,
            ],
          ),
        ),
      ),
    );
  }
}

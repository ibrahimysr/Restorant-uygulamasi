import 'package:flutter/material.dart';
import 'package:food_menu/service/auth_service.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:food_menu/views/forgat_pw_page.dart';
import 'package:food_menu/views/register.dart';
import 'package:food_menu/widget/login_textfield.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appcolor,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              children: [
                Expanded(
                  flex: 12,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text("Hoşgeldiniz", style: TextStyleClass.mainTitle),
                  ),
                ),
                const SizedBox(height: 15,),
                Expanded(
                  flex: 12,
                  child: Text(
                    "Lütfen Giriş Yapınız",
                    style: TextStyleClass.mainContent,
                  ),
                ),
                Expanded(
                  flex: 76,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        
                        loginTextField(_email, "Email", const Icon(Icons.email),
                            false, "Email"),
                        const SizedBox(
                          height: 20,
                        ),
                        loginTextField(_password, "Şifre",
                            const Icon(Icons.lock), true, "Şifre"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgatPasswordPage(),));
                                 
                                },
                                child: Text("Şifremi Unuttum",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.blue)),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50,bottom: 10),
                          child: SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: enabledColor
                              ),
                              onPressed: (){
                                 context.read<FlutterFireAuthService>().signIn(
                                _email.text.trim(),
                                _password.text.trim(),
                                context);
                              }, child:  Text("Giriş Yapınız",style: TextStyleClass.mainContent,))),
                        ) , 
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>const Register(),));
                              
                            },
                            child: Text(
                              "Kayıt Ol",
                              style: TextStyleClass.mainContent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:food_menu/service/auth_service.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:food_menu/widget/login_textfield.dart';
import 'package:provider/provider.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();
  final _phoneNumber = TextEditingController();

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hata"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

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
                
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 16),
                  child: Text("Hoşgeldiniz", style: TextStyleClass.mainTitle),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16,top: 15),
                  child: Text("Kayıt Olunuz", style: TextStyleClass.mainContent),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        loginTextField(_email, "Email", const Icon(Icons.email),
                            false, "Email"),
                        const SizedBox(height: 20),
                        loginTextField(_password, "Şifre",
                            const Icon(Icons.lock), true, "Şifre"),
                        const SizedBox(height: 20),
                        loginTextField(
                            _username,
                            "Kullanıcı Adı",
                            const Icon(Icons.supervised_user_circle_rounded),
                            false,
                            "Kullanıcı Adı"),
                                                    const SizedBox(height: 20),

                            loginTextField(
                            _phoneNumber,
                            "Telefon Numarası",
                            const Icon(Icons.supervised_user_circle_rounded),
                            false,
                            "Telefon Numarası"),
                        const SizedBox(height: 50),
                        SizedBox(
                          width: 250, 
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: enabledColor
                            ),
                            child: Text("Kayıt Ol",style: TextStyleClass.mainContent,),
                            onPressed: () {
                              String email = _email.text.trim();
                              String password = _password.text.trim();
                              String username = _username.text.trim();
                              String phoneNumber = _phoneNumber.text.trim();
                          
                              if (email.isEmpty ||
                                  password.isEmpty ||
                                  username.isEmpty || 
                                  phoneNumber.isEmpty
                                  ) {
                                showErrorDialog(
                                    context, "Lütfen tüm alanları doldurun.");
                              } else if (password.length < 6) {
                                showErrorDialog(
                                    context, "Şifre en az 6 karakter olmalıdır.");
                              } else if (!email.endsWith("@gmail.com")) {
                                showErrorDialog(context,
                                    "Email '@gmail.com' ile bitmelidir.");
                              } else {
                          
                                
                                context.read<FlutterFireAuthService>().signUp(
                                      email,
                                      password,
                                      username,
                                      phoneNumber,
                                      
                                      context,
                                    );
                                    
                              }
                            },
                            
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

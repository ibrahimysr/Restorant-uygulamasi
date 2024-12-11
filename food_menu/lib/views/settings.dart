import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:food_menu/views/forgat_pw_page.dart';
import 'package:food_menu/views/past_order_page.dart';
import 'package:food_menu/views/profile_image_picker.dart';
import 'package:food_menu/widget/mybutton.dart';
import 'package:food_menu/widget/settings_text_field.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _profileImageUrl;

 
  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Kullanıcılar')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          usernameController.text = snapshot.data()?['Kullanıcı Adı'] ?? '';
          emailController.text = snapshot.data()?['email'] ?? '';
          
          _profileImageUrl = snapshot.data()?['profileImageUrl'] ?? '';
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> _selectProfileImage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileImagePickerPage()),
    );

    if (result != null && result is String) {
      setState(() {
        _profileImageUrl = result;
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Kullanıcılar')
            .doc(user.uid)
            .update({
          'profileImageUrl': result,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
              backgroundColor: appcolor,
              centerTitle: true,
              title: Text(
                "Ayarlar",
                style: TextStyleClass.mainTitle,
              ),
              actions: [
                SizedBox( 
                  height: 80, 
                  width: 80,
                  child: Image.asset("assets/images/logo.png"),
                )
              ],
              leading: IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: textColor,
                  )),
            ),
        backgroundColor: appcolor,
        body: Column(
          children: [
            Container(
              color: appcolor,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: _selectProfileImage,
                        child: Container(
                          height: 110,
                          width: 110,
                          margin:
                              const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: enabledColor,
                            image: _profileImageUrl != null
                                ? DecorationImage(
                                    image:
                                        NetworkImage(_profileImageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _profileImageUrl == null
                              ? const Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        "Hoşgeldiniz",
                        style:
                            TextStyle(color: textColor, fontSize: 26),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              
              color:appcolor,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: settingTextfield(
                        usernameController,
                        const Icon(Icons.supervised_user_circle),
                        "Kullanıcı Adı",
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                      child: settingTextfield(
                        emailController,
                        const Icon(Icons.email),
                        "Email",
                      ),
                    ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      width: double.infinity,
                                         
                      child: myButton2( () => { 
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgatPasswordPage(),))
                               
                      },"Şifreyi Sıfırla",),
                      
                    ),
                  ), 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      width: double.infinity,
                      child: myButton2( () => { 
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PastOrderPage(),))
                               
                      },"Geçmiş Siparişlerim",),
                      
                    ),
                  )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

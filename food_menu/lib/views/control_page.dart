import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_menu/service/auth_service.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:food_menu/views/home_page.dart';
import 'package:food_menu/views/settings.dart';
import 'package:food_menu/views/shopping_card.dart';
import 'package:food_menu/widget/bottom_navigator_button.dart';
import 'package:provider/provider.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final PageController _pageController = PageController();
  int index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: appcolor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [MenuHeader(), MenuItems()],
          ),
        ),
      ),
      backgroundColor: appcolor,
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        onPageChanged: (int newIndex) {
          setState(() {
            index = newIndex;
          });
        },
        children: const [HomePage(), ShoppingCard(), SettingPage()],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: appcolor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bottomNavigatorButton(() {
                  _pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }, index, 0, "Ana Sayfa", Icons.home),
                bottomNavigatorButton(() {
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }, index, 1, "Sepet", Icons.shopping_cart_sharp),
                bottomNavigatorButton(() {
                  _pageController.animateToPage(2,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                }, index, 2, "Ayarlar", Icons.settings),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuHeader extends StatelessWidget {
  const MenuHeader({super.key});

  Future<Map<String, dynamic>?> _getProfileImageAndUsername() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Kullanıcılar')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        String? profileImageUrl = userDoc.get('profileImageUrl') as String?;
        String? username = userDoc.get('Kullanıcı Adı') as String?;

        if (profileImageUrl != null && username != null) {
          return {
            'profileImageUrl': profileImageUrl,
            'Kullanıcı Adı': username,
          };
        } else {
          debugPrint('Profile image URL or username is null');
          return null;
        }
      } else {
        debugPrint('User document does not exist');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching profile image URL and username: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: enabledColor,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _getProfileImageAndUsername(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const CircleAvatar(
              backgroundImage: AssetImage("assets/icon.png"),
              radius: 40,
            );
          } else if (!snapshot.hasData) {
            return const CircleAvatar(
              backgroundImage: AssetImage("assets/icon.png"),
              radius: 40,
            );
          } else {
            //String profileImageUrl = snapshot.data!["profileImageUrl"]!;
            String username = snapshot.data!["Kullanıcı Adı"]!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage("profileImageUrl"),
                    radius: 40,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      username,
                      style: const TextStyle(color: Colors.white, fontSize: 19),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class MenuItems extends StatelessWidget {
  const MenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(
              Icons.home,
              color: textColor,
            ),
            title: Text("Home", style: TextStyleClass.mainContent),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.notifications,
              color: textColor,
            ),
            title: Text(
              "Hata Bildirimi",
              style: TextStyleClass.mainContent,
            ),
            onTap: () {
              //showReportDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: textColor,
            ),
            title: Text("Çıkış Yap", style: TextStyleClass.mainContent),
            onTap: () {
              context.read<FlutterFireAuthService>().signOut(context);
            },
          ),
        ],
      ),
    );
  }
}

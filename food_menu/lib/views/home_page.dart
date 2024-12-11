import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_menu/service/user_service.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:food_menu/widget/category_text.dart';
import 'package:food_menu/widget/streambuilder.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String selectedCategory = "Pizza";
  String searchText = '';
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color getCategoryColor(String category) {
    return selectedCategory == category ? enabledColor : appcolor;
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    return Scaffold(
      backgroundColor: appcolor,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              // Custom App Bar
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                backgroundColor: appcolor,
                elevation: 0,
                title: Text(
                  "Lezzetler Dünyası",
                  style: TextStyleClass.mainTitle.copyWith(
                    color: Colors.deepOrange,
                    fontSize: 24,
                  ),
                ),
                actions: [
                  CircleAvatar(
                    backgroundColor: Colors.deepOrange.shade50,
                    child: IconButton(
                      icon: Icon(Icons.notifications_outlined,
                          color: Colors.deepOrange),
                      onPressed: () {
                        // Bildirim sayfası
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: appcolor2,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: enabledColor,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          )
                        ]),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchText = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Lezzetli yiyecekler ara...",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        prefixIcon:
                            Icon(Icons.search, color: Colors.deepOrange),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(15),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),

              // Category Selector
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          _buildCategoryChip(
                              "Pizza", "assets/images/pizza.png"),
                          _buildCategoryChip(
                              "Hamburger", "assets/images/burger2.png"),
                          _buildCategoryChip(
                              "İçecek", "assets/images/drink.png"),
                          _buildCategoryChip(
                              "Tatlı", "assets/images/cupcake.png"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Food Stream Builder
              SliverToBoxAdapter(
                child: SizedBox(
                  height: constraints.maxHeight - 225, // Dinamik yükseklik
                  child: FadeTransition(
                    opacity: _animation,
                    child: MyStreamBuilder(
                      selectedCategory: selectedCategory,
                      searchText: searchText,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCategoryChip(String category, String imagePath) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () => _onCategorySelected(category),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange.shade50 : appcolor2,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: Colors.deepOrange, width: 2)
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 8),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.deepOrange : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

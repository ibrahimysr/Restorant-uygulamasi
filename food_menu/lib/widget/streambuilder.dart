// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:food_menu/service/food_service.dart';
// import 'package:food_menu/style/color.dart';
// import 'package:food_menu/style/textstyle.dart';
// import 'package:food_menu/views/details_page.dart';

// class MyStreamBuilder extends StatelessWidget {
//   final String selectedCategory;

//   final String searchText;

//   const MyStreamBuilder({
//     super.key,
//     required this.selectedCategory,
//     required this.searchText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final FoodService foodService = FoodService();
//     return StreamBuilder<QuerySnapshot>(
//       stream: foodService.getFoodsStream(selectedCategory),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Hata: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text("Bir Bilgi Bulunamadı"));
//         } else {
//           final pizzas = snapshot.data!.docs.map((doc) {
//             return doc.data() as Map<String, dynamic>;
//           }).toList();
//           final filteredFood = foodService.searchFood(pizzas, searchText);

//           return GridView.builder(
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio:
//                   2.0 / 2.5, // Daha büyük kutular için oranı düşürün
//             ),
//             itemCount: filteredFood.length,
//             itemBuilder: (context, index) {
//               final food = filteredFood[index];
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage(food),));
//                   },
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: appcolor2,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(25),
//                         topRight: Radius.circular(25),
//                         bottomLeft: Radius.circular(25),
//                         bottomRight: Radius.circular(25),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             width: 150,
//                             height: 130,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 image: DecorationImage(
//                                     image: NetworkImage(food["url"]),
//                                     fit: BoxFit.fill)),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             food["isim"],
//                             style: TextStyleClass.mainTitle.copyWith(
//                               fontSize: 18,
//                               color: Colors.white,
//                             ),
//                             overflow: TextOverflow.clip,
//                             maxLines: 2,
//                           ),
//                           const SizedBox(height: 2),
                          
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 food["fiyat"],
//                                 style: TextStyleClass.mainContent.copyWith(
//                                   fontSize: 16,
//                                   color: textColor,
//                                 ),
                                                       
//                               ),
//                                Text(
//                                 " ₺",
//                                 style: TextStyleClass.mainContent.copyWith(
//                                   fontSize: 16,
//                                   color: enabledColor,
//                                 ),
                                                       
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_menu/service/food_service.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:food_menu/views/details_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MyStreamBuilder extends StatelessWidget {
  final String selectedCategory;
  final String searchText;

  const MyStreamBuilder({
    super.key,
    required this.selectedCategory,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    final FoodService foodService = FoodService();
    return StreamBuilder<QuerySnapshot>(
      stream: foodService.getFoodsStream(selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepOrange.shade200,
                    Colors.deepOrange.shade400
                  ],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 5,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade100,
                    Colors.red.shade200
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 80),
                  const SizedBox(height: 20),
                  Text(
                    'Bir sorun oluştu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade100,
                    Colors.grey.shade200
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.food_bank_outlined, color: Colors.orange, size: 80),
                  const SizedBox(height: 20),
                  Text(
                    "Henüz ürün bulunmamaktadır",
                    style: TextStyle(
                      fontSize: 20, 
                      color: Colors.black54,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          final foods = snapshot.data!.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
          final filteredFood = foodService.searchFood(foods, searchText);

          return AnimationLimiter(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredFood.length,
              itemBuilder: (context, index) {
                final food = filteredFood[index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  columnCount: 2,
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, 
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              pageBuilder: (_, __, ___) => DetailsPage(food),
                              transitionsBuilder: (_, animation, __, child) {
                                return RotationTransition(
                                  turns: Tween<double>(begin: 0.5, end: 1).animate(
                                    CurvedAnimation(
                                      parent: animation, 
                                      curve: Curves.elasticOut
                                    )
                                  ),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              }
                            )
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepOrange.shade100,
                                Colors.deepOrange.shade200
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 8)
                              )
                            ]
                          ),
                          child: Stack(
                            children: [
                              // Image with gradient overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(food["url"]),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withOpacity(0.3),
                                        BlendMode.darken
                                      )
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Content
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)
                                    )
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        food["isim"],
                                        style: TextStyleClass.mainTitle.copyWith(
                                          fontSize: 16,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: Colors.black,
                                              offset: Offset(1.0, 1.0),
                                            )
                                          ]
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${food["fiyat"]} ₺",
                                            style: TextStyleClass.mainContent.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 10.0,
                                                  color: Colors.black,
                                                  offset: Offset(1.0, 1.0),
                                                )
                                              ]
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Special badge
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text(
                                    "Özel",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
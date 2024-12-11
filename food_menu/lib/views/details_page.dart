import 'package:flutter/material.dart';
import 'package:food_menu/service/food_service.dart';
import 'package:food_menu/service/user_service.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> doc;

  const DetailsPage(this.doc, {super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final EdgeInsets commonPadding = const EdgeInsets.only(left: 40, bottom: 10);
  FoodService service = FoodService();

  @override
  Widget build(BuildContext context) {
  
    return SafeArea(
      child: Scaffold(
        backgroundColor: appcolor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            _buildDetailSection("İsim", widget.doc["isim"]),
            const SizedBox(height: 10),
            _buildDetailSection("Tanım", widget.doc["detay"]),
            const SizedBox(height: 25),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(27.0),
        child: Stack(
          children: [
            Container(
              width: 321,
              height: 380,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.doc["url"]),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: commonPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Color(0xffA99A97), fontSize: 18),
          ),
          Text(
            content,
            style: title == "İsim"
                ? TextStyleClass.mainTitle.copyWith(fontSize: 20)
                : TextStyleClass.mainContent,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
       final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    return Padding(
      padding: commonPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Fiyat",
                style: TextStyle(color: Color(0xffA99A97), fontSize: 18),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.doc["fiyat"],
                    style: TextStyleClass.mainContent,
                  ),
                  const Text(
                    " ₺",
                    style: TextStyle(color: enabledColor, fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: enabledColor,
            ),
            onPressed: () {
            service.addToCart(context,currentUser!.uid.toString(), widget.doc["isim"], widget.doc["detay"], widget.doc["fiyat"],widget.doc["url"]);
            },
            child: Text(
              "Sepete Ekle",
              style: TextStyleClass.mainTitle.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
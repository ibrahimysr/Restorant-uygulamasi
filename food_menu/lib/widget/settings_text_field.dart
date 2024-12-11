import 'package:flutter/material.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';

Widget settingTextfield(
    TextEditingController controller, Icon icon, String data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        data,
        style: TextStyleClass.mainContent,
      ),
      const SizedBox(
        height: 8,
      ),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: appcolor2,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
            ),
            border: Border.all(color: enabledColor)),
        child: TextField(
          controller: controller,
          style: const TextStyle(color: textColor),
          decoration: InputDecoration(
              icon: icon,
              iconColor: enabledColor,
              border: InputBorder.none,
              hintStyle: const TextStyle(color: Colors.grey)),
        ),
      ),
    ],
  );
}

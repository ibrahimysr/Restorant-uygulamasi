import 'package:flutter/material.dart';

import 'package:food_menu/style/textstyle.dart';


Widget categoryText(Function()? ontap, String title, Color colors,String assetTitle) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: GestureDetector(
        onTap: ontap,
        child: Container(
          decoration: BoxDecoration(
            color: colors,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [ 
             Container(
            width: 35.0,
            height: 35.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(assetTitle),
                fit: BoxFit.cover,
              ),
            ),
          ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyleClass.mainContent.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
  );
}

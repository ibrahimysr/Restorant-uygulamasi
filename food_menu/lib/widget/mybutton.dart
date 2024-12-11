import 'package:flutter/material.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/style/textstyle.dart';

Widget myButton(Function()? ontap ,String title) {

  return Padding(
                          padding: const EdgeInsets.only(top: 50,bottom: 10),
                          child: SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: enabledColor
                              ),
                              onPressed: ontap,
                               child:  Text(title,style: TextStyleClass.mainContent,))),
                        ); 

}


Widget myButton2(Function()? ontap ,String title) {

  return Padding(
                          padding: const EdgeInsets.only(top: 15,bottom: 10),
                          child: SizedBox(
                            width: 250,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: enabledColor
                              ),
                              onPressed: ontap,
                               child:  Text(title,style: TextStyleClass.mainContent,))),
                        ); 

}

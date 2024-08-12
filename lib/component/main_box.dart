import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global.dart';
import '../main.dart';

class MainBox extends StatelessWidget {
  final String text;
  final Color color;
  const MainBox({required this.text,super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.width*0.1282,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: color == mainColor?  Colors.white:gray100)
      ),
      child:
      Text(text,style:  TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17,
          color:color == mainColor?  Colors.white: color == gray700? Colors.white:gray700
      ),),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class TextFieldComponent extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final bool multi;
  final bool typeNumber;
  final Color color;
  FocusNode? focusNode = FocusNode();
  TextFieldComponent({required this.text,required this.controller,required this.multi,required this.color, required this.typeNumber,this.focusNode,super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 25,
        ),
        Text(text, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color
        ),),
        const SizedBox(
          height: 9,
        ),
        Container(
          width: 358,
         height:  multi ? null:50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xfff6f6fa)),
          child: TextField(
            controller: controller,
            maxLines: multi? 7:1,
            focusNode: focusNode,
            keyboardType: typeNumber? TextInputType.number:null,
            decoration:   InputDecoration(
              hintStyle: TextStyle(fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffAEAEB2)),
              border: InputBorder.none,
              // 밑줄 없애기
              contentPadding:EdgeInsets.only(left: 20,top: multi?30:0),
              // TextField 내부의 패딩 적용
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: mainColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

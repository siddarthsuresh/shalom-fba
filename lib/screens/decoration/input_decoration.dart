import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputTextFormDecoration {
  String text;

  InputTextFormDecoration({this.text});

  InputDecoration inputFormDecoration() {
    return InputDecoration(
        border: InputBorder.none,
        labelText: text,
        labelStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat-SemiBold',
            fontWeight: FontWeight.normal,
        fontSize: 20),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)));
  }

  BoxDecoration formBoxDecoration() {
    return BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100])));
  }

  BoxDecoration containerBoxDecoration() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 20.0, offset: Offset(0, 10))
        ]);
  }
}

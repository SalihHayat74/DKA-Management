import 'package:flutter/material.dart';


class C_TextField extends StatefulWidget {
  String ? labelText;
  String ? hintText;
  TextEditingController ? controller;
  C_TextField({
    required this.labelText, required this.hintText, required this.controller,
    Key? key,

  }) : super(key: key);

  @override
  State<C_TextField> createState() => _C_TextFieldState();
}

class _C_TextFieldState extends State<C_TextField> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 5, left: 20, right: 20, bottom: 10),
      child: TextField(
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
          filled: true,
            fillColor: Colors.white,
            labelText: widget.labelText,
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none
            )),
      ),
    );
  }
}

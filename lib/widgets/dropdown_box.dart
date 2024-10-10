import 'package:flutter/material.dart';
import 'package:prophunter/constant.dart';

// ignore: must_be_immutable
class DropDownBox extends StatelessWidget {
  DropDownBox({required this.items, required this.hintText, super.key});
  List items;
  String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {},
      readOnly: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: fadeWhite, width: 0.8),
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
      ),
    );
  }
}

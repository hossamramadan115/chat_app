import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTexFormtField extends StatelessWidget {
  CustomTexFormtField({this.onChanged, this.hintText, this.scureText = false});

  String? hintText;

  bool? scureText;

  Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (data) {
        if (data!.isEmpty) {
          return 'field is required';
        }
      },
      obscureText: scureText!,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

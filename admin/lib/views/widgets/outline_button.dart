import 'package:dairyadmin/constants/theme_colors.dart';
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;

  CustomOutlineButton({this.title, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
        borderSide: BorderSide(color: color),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(25.0),
        ),
        onPressed: onPressed,
        color: color,
        textColor: color,
        child: Container(
          child: Center(
            child: Text(title,
                style: TextStyle(fontSize: 15.0, color: ThemeColors.colorText)),
          ),
        ));
  }
}

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Color color;
  final Function onPressed;
  final double minWidth;

  const Button({Key key, this.label, this.color, this.onPressed, this.minWidth})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth ?? 200,
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: color,
        textColor: Colors.white,
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

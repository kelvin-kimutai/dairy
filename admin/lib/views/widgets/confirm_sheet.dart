import 'package:dairyadmin/constants/theme_colors.dart';
import 'package:flutter/material.dart';

import 'button.dart';
import 'outline_button.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String text;
  final Function confirm;

  const ConfirmSheet({Key key, this.title, this.text, this.confirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      height: 160,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 22,
                color: ThemeColors.colorPrimary,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(color: ThemeColors.colorTextLight),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    child: CustomOutlineButton(
                      title: 'No',
                      color: ThemeColors.colorText,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    child: Button(
                      minWidth: 50,
                      label: 'Yes',
                      color: ThemeColors.colorAccent,
                      onPressed: confirm,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

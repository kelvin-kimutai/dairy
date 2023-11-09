import 'package:Collector/constants/theme_colors.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String status;

  const ProgressDialog({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        height: 80,
        margin: EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(width: 5),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ThemeColors.colorAccent),
              ),
              SizedBox(width: 25.0),
              Expanded(child: Text(status))
            ],
          ),
        ),
      ),
    );
  }
}

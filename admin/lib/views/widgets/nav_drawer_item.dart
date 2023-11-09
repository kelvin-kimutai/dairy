import 'package:dairyadmin/views/styles/styles.dart';
import 'package:flutter/material.dart';

class NavDrawerItem extends StatelessWidget {
  final String label;
  final Function function;
  final IconData icon;

  const NavDrawerItem({Key key, this.label, this.function, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 22,
            ),
            SizedBox(width: 10),
            Text(label, style: kDrawerItemsStyle),
          ],
        ),
      ),
    );
  }
}

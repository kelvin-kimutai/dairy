import 'package:dairyadmin/constants/theme_colors.dart';
import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final String avatarUrl;

  const CustomAvatar({Key key, this.avatarUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26.5,
          backgroundColor: ThemeColors.colorAccent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: FadeInImage(
              image: NetworkImage(avatarUrl),
              placeholder: AssetImage('assets/images/user_icon.png'),
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

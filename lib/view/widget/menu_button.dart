import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.iconData,
    required this.title,
    this.color,
    this.splashColor,
    this.onTap,
  });

  final IconData iconData;
  final String title;
  final Color? color;
  final Color? splashColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: splashColor,
      onTap: onTap ?? () {},
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(
              iconData,
              color: color,
            ),
            Text(
              title,
              style: TextStyle(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
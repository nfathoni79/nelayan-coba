import 'package:flutter/material.dart';

class ProfileMenu {
  const ProfileMenu({
    required this.id,
    required this.title,
    required this.iconData,
    this.onTap,
  });

  final int id;
  final String title;
  final IconData iconData;
  final Function()? onTap;
}

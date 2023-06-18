import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.iconData,
    required this.title,
    this.description,
    this.onTap,
  });

  final IconData iconData;
  final String title;
  final String? description;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Card(
            color: Colors.blue.shade800,
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.blue,
              onTap: onTap ?? () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      iconData,
                      size: 72,
                      color: Colors.blue.shade100,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.blue.shade50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Text(
          description ?? '',
          style: TextStyle(
            color: Colors.blue.shade900,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
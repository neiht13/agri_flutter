import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Color? color;

  const CustomIcon(this.iconData, {
    Key? key,
    this.size = 18.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor  =  Theme.of(context).colorScheme.primary;
    final Color iconColor =
        color ?? primaryColor;
    return Icon(
      iconData,
      size: size,
      color: iconColor,
    );
  }
}

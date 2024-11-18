import 'package:flutter/material.dart' show Icon, immutable;

@immutable
class BottomNavigationItem {
  final String route;
  final String iconPath;
  final String label;

  const BottomNavigationItem(this.route, this.iconPath, this.label);
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchTitle extends StatelessWidget {
  final Color activeColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? title;

  const SwitchTitle({super.key, this.activeColor = Colors.green, this.value = false, required this.onChanged, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title ?? "", style: const TextStyle(fontSize: 16)),
          CupertinoSwitch(
                  activeColor: activeColor,
                  value: value,
                  onChanged: onChanged,
                ),
        ],
      ),
    );
  }
}
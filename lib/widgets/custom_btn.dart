import 'package:agriplant/widgets/custom_icon.dart';
import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  const CustomBtn({super.key, required this.icon, required this.text, this.onPressed, this.height,this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                          width: width??double.infinity,
                          height: height?? 50,
                          child: FilledButton.icon(
                            onPressed: onPressed??(){},
                            icon: CustomIcon(icon, color: Colors.white,),
                            label: Text(text),
                          ),
                        );
  }
}
import 'package:flutter/material.dart';

class TopSginin extends StatelessWidget {
  final String title;
  const TopSginin({
    Key? key,required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 20),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
           const SizedBox(
            width: 15,
          ),
          Text(
            title.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 25),
          )
        ],
      ),
    );
  }
}
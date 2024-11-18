
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../models/tree.dart';

class AdoptionPage extends ConsumerWidget {
  const AdoptionPage({super.key, required this.tree});

  final Tree tree;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhận nuôi cây xoài'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Hiển thị thông tin cây xoài
                Text(
                  tree.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "${tree.price.toStringAsFixed(0)} VND/năm",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 20),
                // Thông tin thanh toán (có thể thêm các trường như phương thức thanh toán)
                // ...
                const Spacer(),
                FilledButton.icon(
                  onPressed: (){},
                  icon: const Icon(IconlyLight.wallet),
                  label: const Text("Thanh toán"),
                ),
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}

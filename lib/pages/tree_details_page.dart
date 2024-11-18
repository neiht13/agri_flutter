
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../models/tree.dart';

class TreeDetailsPage extends StatefulWidget {
  const TreeDetailsPage({super.key, required this.tree});

  final Tree tree;

  @override
  State<TreeDetailsPage> createState() => _TreeDetailsPageState();
}

class _TreeDetailsPageState extends State<TreeDetailsPage> {
  late TapGestureRecognizer readMoreGestureRecognizer;
  bool showMore = false;

  @override
  void initState() {
    super.initState();
    readMoreGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showMore = !showMore;
        });
      };
  }

  @override
  void dispose() {
    readMoreGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lọc cây xoài tương tự
    List<Tree> similarTrees = trees.where((tree) {
      return tree.type == widget.tree.type && tree.id != widget.tree.id;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tree.name),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(IconlyLight.bookmark),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hình ảnh cây xoài
          Container(
            height: 250,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.tree.image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Thông tin cơ bản
          Text(
            widget.tree.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 5),
          Text(
            "Loại: ${widget.tree.type}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "Tuổi: ${widget.tree.age}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "Chiều cao: ${widget.tree.height}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "Đường kính tán: ${widget.tree.canopyDiameter}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "Năng suất bình quân: ${widget.tree.averageYield}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Text(
            "${widget.tree.price.toStringAsFixed(0)} VND/năm",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 20),
          // Mô tả cây
          Text(
            "Mô tả",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: showMore
                      ? widget.tree.description
                      : widget.tree.description.length > 100
                          ? '${widget.tree.description.substring(0, 100)}...'
                          : widget.tree.description,
                ),
                TextSpan(
                  recognizer: readMoreGestureRecognizer,
                  text: showMore ? " Thu gọn" : " Xem thêm",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Cây xoài tương tự
          Text(
            "Cây xoài tương tự",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: similarTrees.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final tree = similarTrees[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => TreeDetailsPage(tree: tree)),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        width: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(tree.image),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        tree.name,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Nút nhận nuôi
          FilledButton.icon(
            onPressed: () {
              // Xử lý nhận nuôi cây
            },
            icon: const Icon(IconlyLight.buy),
            label: const Text("Nhận nuôi ngay"),
          ),
        ],
      ),
    );
  }
}

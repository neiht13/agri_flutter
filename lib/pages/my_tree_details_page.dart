// my_trees/my_tree_details_page.dart
import 'package:flutter/material.dart';

import '../models/tree.dart';

class MyTreeDetailsPage extends StatefulWidget {
  const MyTreeDetailsPage({super.key});


  @override
  State<MyTreeDetailsPage> createState() => _MyTreeDetailsPageState();
}

class _MyTreeDetailsPageState extends State<MyTreeDetailsPage> {
  
  late Tree tree;

@override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar với hình ảnh cây
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(tree.name),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    tree.image,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay để làm nổi bật tiêu đề
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.green[700],
          ),
          SliverToBoxAdapter(
            child:  Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thông tin cơ bản về cây
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Tuổi cây
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Tuổi: ${tree.age}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Loại cây
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.category,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Loại: ${tree.type}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Chiều cao
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.height,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Chiều cao: ${tree.height}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Đường kính tán lá
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.aspect_ratio,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Đường kính tán lá: ${tree.canopyDiameter}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Giá
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.attach_money,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Giá: \$${tree.price.toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Mô tả cây
                            Text(
                              'Mô tả',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              tree.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20),
                            // Trạng thái cây
                            Text(
                              'Trạng thái cây',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Card(
                              color: Colors.green[50],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                 'Không rõ',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Lịch sử chăm sóc
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Lịch sử chăm sóc',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                // Nút thêm lịch sử chăm sóc mới (nếu cần)
                                // IconButton(
                                //   icon: const Icon(Icons.add),
                                //   onPressed: () {
                                //     // Thêm chức năng thêm lịch sử chăm sóc
                                //   },
                                // ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // myTreeState.careHistories != null &&
                            //         myTreeState.careHistories!.isNotEmpty
                            //     ? ListView.separated(
                            //         shrinkWrap: true,
                            //         physics: const NeverScrollableScrollPhysics(),
                            //         itemCount: myTreeState.careHistories!.length,
                            //         separatorBuilder: (_, __) =>
                            //             const Divider(height: 1),
                            //         itemBuilder: (context, index) {
                            //           final history =
                            //               myTreeState.careHistories![index];
                            //           return ListTile(
                            //             leading: CircleAvatar(
                            //               backgroundColor: Colors.green.shade100,
                            //               child: const Icon(
                            //                 Icons.nature,
                            //                 color: Colors.green,
                            //               ),
                            //             ),
                            //             title: Text(
                            //               history.activity,
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .titleMedium!
                            //                   .copyWith(
                            //                       fontWeight: FontWeight.bold),
                            //             ),
                            //             subtitle: Text(history.description),
                            //             trailing: Text(
                            //               history.date,
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .bodySmall,
                            //             ),
                            //           );
                            //         },
                            //       )
                            //     : 
                                Text(
                                    'Chưa có lịch sử chăm sóc',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
      
    );
  }
}





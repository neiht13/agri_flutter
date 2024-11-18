import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
        final double screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      child: Center(
        child: SizedBox(
          height: screenHeight * 0.7,
          child: Padding(
              padding:  EdgeInsets.zero, // Khoảng trống trên và dưới
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                  ),
                  child: Text(
                    'Xin chào!',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.newspaper),
                  title: const Text('Tin tức/Sự kiện'),
                  onTap: () {
                    context.push("/news");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contact_support),
                  title: const Text('Liên hệ/Hỗ trợ'),
                  onTap: () {
                    context.push("/supports");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Cài đặt'),
                  onTap: () {
                    context.push("/settings");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Giới thiệu'),
                  onTap: () {
                    context.push("/about");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text('Bản đồ Vườn xoài'),
                  onTap: () {
                    context.push("/news");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: const Text('Đánh giá và Phản hồi'),
                  onTap: () {
                    context.push("/feedback");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat),
                  title: const Text('Hỗ trợ trực tuyến'),
                  onTap: () {
                    context.push("/chat");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

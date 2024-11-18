// lib/presentation/screen/about/about_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giới thiệu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logo hoặc hình ảnh ứng dụng
            Image.asset(
              'assets/mango.jpg', // Thay đổi đường dẫn đến logo của bạn
              height: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'Cây xoài nhà tôi',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Cây xoài nhà tôi là ứng dụng hỗ trợ nông dân quản lý cây trồng và theo dõi thời tiết, cung cấp các thông tin hữu ích để tăng năng suất và chất lượng sản phẩm.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Phiên bản và các thông tin khác
            Text(
              'Phiên bản 1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 20),
            // Liên kết tới mạng xã hội hoặc trang web nếu cần
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
                  onPressed: () {
                    // Thêm liên kết tới Facebook
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.twitter, color: Colors.blue),
                  onPressed: () {
                    // Thêm liên kết tới Twitter
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.instagram, color: Colors.purple),
                  onPressed: () {
                    // Thêm liên kết tới Instagram
                  },
                ),
                // Thêm các biểu tượng mạng xã hội khác nếu cần
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// lib/presentation/screen/help/help_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  // Danh sách câu hỏi thường gặp
  final List<Map<String, String>> faqs = const [
    {
      'question': 'Làm thế nào để đăng nhập?',
      'answer': 'Bạn có thể đăng nhập bằng cách sử dụng email và mật khẩu đã đăng ký.'
    },
    {
      'question': 'Làm thế nào để thay đổi mật khẩu?',
      'answer': 'Vui lòng truy cập vào mục "Thay đổi mật khẩu" trong trang hồ sơ cá nhân.'
    },
    {
      'question': 'Ứng dụng hỗ trợ những ngôn ngữ nào?',
      'answer': 'Hiện tại, ứng dụng hỗ trợ tiếng Việt và tiếng Anh. Chúng tôi đang lên kế hoạch mở rộng thêm nhiều ngôn ngữ khác.'
    },
    {
      'question': 'Tôi có thể liên hệ hỗ trợ như thế nào?',
      'answer': 'Bạn có thể liên hệ hỗ trợ qua email: support@agriplant.com hoặc gọi số điện thoại: 0123-456-789.'
    },
    // Thêm các câu hỏi khác nếu cần
  ];



  @override
  Widget build(BuildContext context) {
        final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trợ giúp'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: Icon(FontAwesomeIcons.circleQuestion, color: primaryColor),
                title: Text(
                  faq['question']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      faq['answer']!,
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            )
          );
        },
      ),
    );
  }
}

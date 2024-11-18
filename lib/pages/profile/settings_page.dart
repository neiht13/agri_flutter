import 'package:agriplant/widgets/switch_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor  =  Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Nhận thông báo"),
            value: true,
            onChanged: (value) {
              
            },
          ),
          SwitchTitle(
            title: "Chế độ tối",
            activeColor: primaryColor,
            value: false,
            onChanged: (value) {
             
              // Thay đổi chủ đề của ứng dụng nếu cần
            },
          ),
          ListTile(
            title: const Text("Ngôn ngữ"),
            subtitle: const Text("Tiếng việt"),
            onTap: () {
              // Hiển thị dialog chọn ngôn ngữ
            },
          ),
          ListTile(
            title: const Text("Điều khoản sử dụng"),
            onTap: () {
              // Hiển thị điều khoản
            },
          ),
          ListTile(
            title: const Text("Chính sách bảo mật"),
            onTap: () {
              // Hiển thị chính sách
            },
          ),
        ],
      ),
    );
  }
}

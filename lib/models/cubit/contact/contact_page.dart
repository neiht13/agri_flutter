import 'package:agriplant/models/cubit/contact/contact_list_page.dart';
import 'package:agriplant/models/cubit/contact/statistics_page.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
    @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Số lượng tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý Landing Page'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Liên hệ'),
              Tab(text: 'Thống kê'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab hiển thị danh sách liên hệ
            ContactListPage(),
            // Tab hiển thị thống kê
            StatisticsPage(),
          ],
        ),
      ),
    );
  }
}
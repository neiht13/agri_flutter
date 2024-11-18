// pages/profile/user_item.dart

import 'package:agriplant/models/model/user.dart';
import 'package:agriplant/pages/profile/user_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class UserItem extends StatelessWidget {
  final User user;
  final int index;
  final int entryCount;
  final DateTime? lastUpdate;

  const UserItem({
    Key? key,
    required this.user,
    required this.index,
    required this.entryCount,
    this.lastUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String lastUpdateStr = lastUpdate != null ? DateFormat('dd/MM/yyyy').format(lastUpdate!) : 'Chưa có cập nhật';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        backgroundImage: user.image != null && user.image!.isNotEmpty
            ? NetworkImage(user.image!)
            : null,
        child: user.image == null || user.image!.isEmpty
            ? Text('${index + 1}')
            : null,
      ),
      title: Text(user.name ?? 'No Name'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Số lượng nhật ký: $entryCount'),
          Text('Cập nhật cuối: $lastUpdateStr'),
        ],
      ),
      onTap: () {
        // Mở trang chi tiết hoặc biểu đồ
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailPage(user: user),
          ),
        );
      },
    );
  }
}

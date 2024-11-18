import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final Function(dynamic) onEdit; // Hàm callback để chỉnh sửa

  const TaskList({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    // Danh sách Công việc mẫu
    List<Map<String, dynamic>> congviecList = [
      {"tenCongViec": "Công việc 1", "chitietcongviec": "Chi tiết 1"},
      {"tenCongViec": "Công việc 2", "chitietcongviec": "Chi tiết 2"},
    ];

    return ListView.builder(
      itemCount: congviecList.length,
      itemBuilder: (context, index) {
        final congviec = congviecList[index];

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(congviec["tenCongViec"]),
            subtitle: Text("Chi tiết: ${congviec["chitietcongviec"]}"),
            onTap: () {
              // Khi nhấn vào card sẽ mở form chỉnh sửa
              onEdit(congviec);
            },
          ),
        );
      },
    );
  }
}
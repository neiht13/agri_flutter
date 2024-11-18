import 'package:flutter/material.dart';

class StageList extends StatelessWidget {
  final Function(dynamic) onEdit; // Hàm callback để chỉnh sửa

  const StageList({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    // Danh sách Giai đoạn mẫu
    List<Map<String, dynamic>> giaidoanList = [
      {"tenGiaiDoan": "Giai đoạn 1", "color": "Xanh"},
      {"tenGiaiDoan": "Giai đoạn 2", "color": "Đỏ"},
    ];

    return ListView.builder(
      itemCount: giaidoanList.length,
      itemBuilder: (context, index) {
        final giaidoan = giaidoanList[index];

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(giaidoan["tenGiaiDoan"]),
            subtitle: Text("Màu: ${giaidoan["color"]}"),
            onTap: () {
              // Khi nhấn vào card sẽ mở form chỉnh sửa
              onEdit(giaidoan);
            },
          ),
        );
      },
    );
  }
}
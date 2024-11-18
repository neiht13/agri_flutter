import 'package:agriplant/models/cubit/season/season_cubit.dart';
import 'package:agriplant/models/model/season.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MuavuList extends StatelessWidget {
  final Function(dynamic) onEdit; // Hàm callback để chỉnh sửa

  const MuavuList({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeasonCubit, List<Season>>(
      builder: (context, muavuList) {
        return ListView.builder(
          itemCount: muavuList.length,
          itemBuilder: (context, index) {
            final muavu = muavuList[index];

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(muavu.muavu ?? 'Không có thông tin'),
                subtitle: Column(
                  children: [
                    Text("Năm: ${muavu.nam}"),
                    Text("Năm: ${muavu.ngaybatdau}"),
                  ],
                ),
                onTap: () {
                  // Khi nhấn vào card sẽ mở form chỉnh sửa
                  onEdit(muavu);
                },
              ),
            );
          },
        );
      },
    );
  }
}

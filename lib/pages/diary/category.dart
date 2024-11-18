import 'package:agriplant/models/cubit/season/season_cubit.dart';
import 'package:agriplant/models/cubit/season/season_form.dart';
import 'package:agriplant/models/cubit/stage/stage_cubit.dart';
import 'package:agriplant/models/cubit/stage/stage_form.dart';
import 'package:agriplant/models/cubit/task/task_cubit.dart';
import 'package:agriplant/models/cubit/task/task_form.dart';
import 'package:agriplant/models/model/season.dart';
import 'package:agriplant/models/model/stage.dart';
import 'package:agriplant/models/model/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateCategoryPage extends StatefulWidget {
  const UpdateCategoryPage({super.key});

  @override
  _UpdateCategoryPageState createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ["Mùa vụ", "Giai đoạn", "Công việc"];

  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController
    _tabController = TabController(length: _tabs.length, vsync: this);
    // Load danh sách mùa vụ, giai đoạn, công việc khi trang được tạo
    context.read<SeasonCubit>().fetchSeasons();
    context.read<StageCubit>().fetchStages();
    context.read<TaskCubit>().fetchTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openBottomSheet(dynamic item, [int? index]) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: _getFormForTab(item, index),
        );
      },
    );
  }

  Widget _getFormForTab(dynamic item, [int? index]) {
    switch (_tabController.index) {
      case 0:
        return SeasonForm(
          season: item,
          onSave: (newSeason) {
            if (item == null) {
              context.read<SeasonCubit>().addUpdateSeason(newSeason);
            } else {
              context.read<SeasonCubit>().addUpdateSeason(newSeason);
            }
            Navigator.pop(context);
          },
        );
      case 1:
        return UpdateStageForm(
          stage: item,
          onSave: (newStage) {
            if (item == null) {
              context.read<StageCubit>().addStage(newStage);
            } else {
              context.read<StageCubit>().updateStage(index!, newStage);
            }
            Navigator.pop(context);
          },
        );
      case 2:
        return UpdateTaskForm(
          task: item,
          onSave: (newTask) {
            if (item == null) {
              context.read<TaskCubit>().addTask(newTask);
            } else {
              context.read<TaskCubit>().updateTask(index!, newTask);
            }
            Navigator.pop(context);
          },
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật danh mục'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openBottomSheet(null);
        },
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSeasonTab(),
          _buildStageTab(),
          _buildTaskTab(),
          // const PestManagementPage(),
          // const ContactPage(),
        ],
      ),
    );
  }

  Widget _buildSeasonTab() {
    return BlocBuilder<SeasonCubit, List<Season>>(
      builder: (context, seasons) {
        // if (seasons.isEmpty) {
        //   return const Center(child: Text('Chưa có mùa vụ nào.'));
        // }
        return ListView.builder(
          itemCount: seasons.length,
          itemBuilder: (context, index) {
            final season = seasons[index];
            return _buildListItem(
              title: season.muavu ?? 'Không có thông tin',
              subtitle:
                  "Năm: ${season.nam} | Phương pháp: ${season.phuongphap} | Giống: ${season.giong} | Ngày bắt đầu: ${season.ngaybatdau}",
              onTap: () {
                _openBottomSheet(season, index);
              },
              onDelete: () {
                context.read<SeasonCubit>().deleteSeason(index, season.id ?? "");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã xoá mùa vụ: ${season.muavu}')),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStageTab() {
    return BlocBuilder<StageCubit, List<Stage>>(
      builder: (context, stages) {
        if (stages.isEmpty) {
          return const Center(child: Text('Chưa có giai đoạn nào.'));
        }
        return ListView.builder(
          itemCount: stages.length,
          itemBuilder: (context, index) {
            final stage = stages[index];
            return _buildListItem(
              title: stage.tenGiaiDoan ?? 'Không có thông tin',
              subtitle: "Ghi chú: ${stage.ghichu}",
              onTap: () {
                _openBottomSheet(stage, index);
              },
              onDelete: () {
                context.read<StageCubit>().deleteStage(index);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTaskTab() {
    return BlocBuilder<TaskCubit, List<Task>>(
      builder: (context, tasks) {
        if (tasks.isEmpty) {
          return const Center(child: Text('Chưa có công việc nào.'));
        }
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _buildListItem(
              title: task.tenCongViec ?? 'Không có thông tin',
              subtitle: "Thuộc giai đoạn: ${task.tenGiaiDoan}",
              onTap: () {
                _openBottomSheet(task, index);
              },
              onDelete: () {
                context.read<TaskCubit>().deleteTask(index);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildListItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return Dismissible(
      key: Key(title + subtitle),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        color: Colors.redAccent,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        onDelete();
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              // Thêm biểu tượng hoặc hình ảnh
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.local_florist, // Biểu tượng đại diện cho Season
                  color: Colors.green,
                  size: 30,
                ),
              ),
              SizedBox(width: 16),
              // Nội dung thông tin
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              // Nút xoá
              IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:agriplant/api_service.dart';
import 'package:agriplant/models/model/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskCubit extends Cubit<List<Task>> {
  TaskCubit() : super([]);
  ApiService apiService = ApiService();

  // Hàm load danh sách công việc từ dữ liệu mẫu hoặc API
  Future<void> fetchTasks() async {
            final response = await apiService.get('/congviec');
      List<Task> tasks = response.map((json) => Task.fromJson(json)).toList();

    emit(tasks); // Cập nhật danh sách công việc
  }

  // Thêm công việc
  void addTask(Task newTask) {
    final updatedList = List<Task>.from(state)..add(newTask);
    emit(updatedList);
  }

  // Cập nhật công việc
  void updateTask(int index, Task updatedTask) {
    final updatedList = List<Task>.from(state);
    updatedList[index] = updatedTask;
    emit(updatedList);
  }

  // Xóa công việc
  void deleteTask(int index) {
    final updatedList = List<Task>.from(state)..removeAt(index);
    emit(updatedList);
  }
}
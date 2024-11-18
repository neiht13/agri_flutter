import 'package:agriplant/api_service.dart';
import 'package:agriplant/models/model/stage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StageCubit extends Cubit<List<Stage>> {
  StageCubit() : super([]);
  
  ApiService apiService = ApiService();

  // Hàm load danh sách giai đoạn từ dữ liệu mẫu hoặc API
  Future<void> fetchStages() async 
{
        final response = await apiService.get('/giaidoan');
      List<Stage> stageList = response.map((json) => Stage.fromJson(json)).toList();

    emit(stageList); // Cập nhật danh sách giai đoạn
  }

  // Thêm giai đoạn
  void addStage(Stage newStage) {
    final updatedList = List<Stage>.from(state)..add(newStage);
    emit(updatedList);
  }

  // Cập nhật giai đoạn
  void updateStage(int index, Stage updatedStage) {
    final updatedList = List<Stage>.from(state);
    updatedList[index] = updatedStage;
    emit(updatedList);
  }

  // Xóa giai đoạn
  void deleteStage(int index) {
    final updatedList = List<Stage>.from(state)..removeAt(index);
    emit(updatedList);
  }
}
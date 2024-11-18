import 'package:agriplant/api_service.dart';
import 'package:agriplant/models/model/season.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class SeasonCubit extends Cubit<List<Season>> {
  SeasonCubit() : super([]);

  final ApiService _apiService = ApiService();

  // Hàm load danh sách mùa vụ từ API hoặc dữ liệu mẫu
  Future<void> fetchSeasons() async {
    // try {
    //   // Đây là dữ liệu mẫu tĩnh, bạn có thể thay thế bằng API nếu có
    //   final List<Season> seasonList = [
    //     Season(muavu: "Đông Xuân", nam: "2024", ngaybatdau: "2024-01-15", phuongphap: "Truyền thống", giong: "Giống A1", dientich: 10.5, soluong: 1000, giagiong: 1500000, stt: "1", ghichu: "Mùa vụ chính trong năm", user: "Người dùng 1"),
    //     Season(muavu: "Hè Thu", nam: "2024", ngaybatdau: "2024-06-01", phuongphap: "Hữu cơ", giong: "Giống B2", dientich: 8.3, soluong: 800, giagiong: 1200000, stt: "2", ghichu: "Thời tiết nóng ẩm, thích hợp trồng lúa", user: "Người dùng 2"),
    //     Season(muavu: "Thu Đông", nam: "2024", ngaybatdau: "2024-09-15", phuongphap: "Công nghệ cao", giong: "Giống C3", dientich: 12.0, soluong: 1500, giagiong: 1800000, stt: "3", ghichu: "Mùa vụ cuối trong năm, thời tiết thuận lợi", user: "Người dùng 3"),
    //   ];
      
    //   emit(seasonList); // Cập nhật danh sách mùa vụ
    // } catch (e) {
    //   print('Lỗi khi tải dữ liệu mùa vụ: $e');
    //   emit([]); // Nếu có lỗi, cập nhật danh sách trống
    // }

    try {
      final response = await _apiService.get('/muavu');
      List<Season> seasonList = response.map((json) => Season.fromJson(json)).toList();
      print(seasonList.toString());
      emit(seasonList);
    } catch (e) { 
      print('Error fetching farming logs: $e');
      rethrow; // Ném lại ngoại lệ để lớp gọi xử lý
    }
  }

  // Thêm mùa vụ
  Future<void> addUpdateSeason(Season newSeason) async {
     final updatedList = List<Season>.from(state);
    int index = updatedList.indexWhere((season) => season.id == newSeason.id);
    if (newSeason.id == null) {
        updatedList.add(newSeason);
    } else {
        updatedList[index] = newSeason;
    }
    try {
      final response = await _apiService.post('/muavu', newSeason.toJson());
      emit(updatedList);
    } catch (e) { 
      print('Error fetching farming logs: $e');
      rethrow;
    }
    emit(updatedList); 
  }

  // // Sửa mùa vụ
  // void updateSeason(int index, Season updatedSeason) {
  //   final updatedList = List<Season>.from(state);
  //   updatedList[index] = updatedSeason;
  //   emit(updatedList); // Cập nhật danh sách với mùa vụ đã chỉnh sửa
  // }

  // Xóa mùa vụ
  Future<void> deleteSeason(int index, String deleteId) async {
      try {
        final updatedList = List<Season>.from(state);
        updatedList.removeAt(index);
        await _apiService.delete('/muavu', deleteId);
        emit(updatedList);
      } catch (e) { 
        print('Error fetching farming logs: $e');
        rethrow;
      }
        
    
  }
}
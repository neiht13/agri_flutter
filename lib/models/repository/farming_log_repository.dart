// lib/data/repository/farming_log_repository.dart


import 'package:agriplant/api_service.dart';
import 'package:agriplant/models/model/nhatky.dart';

class FarmingLogRepository {
  final ApiService _apiService;

  FarmingLogRepository({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  Future<List<FarmingLog>> getFarmingLogs(String? userId) async {
    String id = userId ?? "";
    if (userId == null) {
      id = await _apiService.getCurrentUser() ?? "";
    }

    try {
      print("id: $id");
      final response = await _apiService.get('/nhatky', {"uId": id});
      return response.map((json) => FarmingLog.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching farming logs: $e');
      return [];
      // rethrow; // Ném lại ngoại lệ để lớp gọi xử lý
    }
  }

  Future<List<FarmingLog>> getAllFarmingLogs() async {
    try {
      final response = await _apiService.getAll('/nhatky');
      return response.map((json) => FarmingLog.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching farming logs: $e');
      return [];
      // rethrow; // Ném lại ngoại lệ để lớp gọi xử lý
    }
  }

  Future<void> addFarmingLog(FarmingLog log) async {
    try {
      final response = await _apiService.post('/nhatky', log.toJson());
      // return log;
    } catch (e) {
      print('Error adding farming log: $e');
      // rethrow;
    }
  }

  Future<void> updateFarmingLog(FarmingLog log) async {
    try {
      // Sử dụng PUT hoặc PATCH thay vì POST cho cập nhật
      final response = await _apiService.post('/nhatky', log.toJson());
      // return log;
    } catch (e) {
      print('Error updating farming log: $e');
      // rethrow;
    }
  }

  Future<void> deleteFarmingLog(String id) async {
    try {
      await _apiService.delete('/nhatky', id);
    } catch (e) {
      print('Error deleting farming log: $e');
      rethrow;
    }
  }
}

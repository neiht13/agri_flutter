// lib/data/cubit/farming_log_cubit.dart
import 'package:agriplant/models/model/nhatky.dart';
import 'package:agriplant/models/repository/farming_log_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/src/material/date.dart';
import 'nhatky_state.dart';

class FarmingLogCubit extends Cubit<FarmingLogState> {
  final FarmingLogRepository repository;

  FarmingLogCubit({required this.repository}) : super(FarmingLogInitial());

  // Lấy danh sách FarmingLog
  Future<void> fetchFarmingLogs(String? userId) async {
    try {
      emit(FarmingLogLoading());
      final logs = await repository.getFarmingLogs(userId);
      emit(FarmingLogLoaded(logs: logs));
    } catch (e) {
      emit(FarmingLogError(message: e.toString()));
    }
  }
  // Lấy danh sách FarmingLog
  Future<void> getAllFarmingLogs() async {
    try {
      emit(FarmingLogLoading());
      final logs = await repository.getAllFarmingLogs();
      emit(FarmingLogLoaded(logs: logs));
    } catch (e) {
      emit(FarmingLogError(message: e.toString()));
    }
  }

  Future<void> fetchUserStatistics() async {
    try {
      // Giả sử bạn có một dịch vụ để lấy tất cả các bản ghi nhật ký
      final logs = await repository.getAllFarmingLogs();

      // Tạo một map để lưu trữ thống kê
      Map<String, List<FarmingLog>> userNhatKyMap = {};

      for (var nhatKy in logs) {
        userNhatKyMap.putIfAbsent(nhatKy.uId ?? "", () => []).add(nhatKy);
      }

      // Cập nhật trạng thái với dữ liệu thống kê
      emit(UserStatisticsLoaded(userNhatKyMap));
    } catch (e) {
      emit(const FarmingLogError(message: "Failed to load user statistics"));
    }
  }

  // Thêm mới FarmingLog
  Future<void> addFarmingLog(FarmingLog log) async {
    try {
      await repository.addFarmingLog(log);
      fetchFarmingLogs(null); // Cập nhật danh sách sau khi thêm
    } catch (e) {
      emit(FarmingLogError(message: e.toString()));
    }
  }

  // Cập nhật FarmingLog
  Future<void> updateFarmingLog(FarmingLog log) async {
    try {
      await repository.updateFarmingLog(log);
      fetchFarmingLogs(null); // Cập nhật danh sách sau khi cập nhật
    } catch (e) {
      emit(FarmingLogError(message: e.toString()));
    }
  }

  // Xóa FarmingLog
  Future<void> deleteFarmingLog(FarmingLog log) async {
    try {
      await repository.deleteFarmingLog(log.id!);
      fetchFarmingLogs(null); // Cập nhật danh sách sau khi xóa
    } catch (e) {
      emit(FarmingLogError(message: e.toString()));
    }
  }

  void fetchFarmingLogsSeason(String s) {}

  void fetchFarmingLogsSeasonAndDateRange(String s, DateTimeRange dateTimeRange) {}
}

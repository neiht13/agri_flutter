// users_cubit.dart
import 'package:agriplant/models/model/nhatky.dart';
import 'package:agriplant/models/model/user.dart';
import 'package:agriplant/models/repository/farming_log_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../repository/user_repository.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;

  UsersLoaded(this.users);
}

class UsersError extends UsersState {
  final String message;

  UsersError(this.message);
}

class UserStatisticsLoaded extends UsersState {
  final List<User> users;
  final Map<String, List<FarmingLog>> userFarmingLogMap;
  final Map<String, DateTime> userLastUpdateMap;

  UserStatisticsLoaded(this.users, this.userFarmingLogMap, this.userLastUpdateMap);
}


class UsersCubit extends Cubit<UsersState> {
  final UserRepository userRepository;

  UsersCubit({required this.userRepository}) : super(UsersInitial());

  void fetchUsers() async {
    try {
      emit(UsersLoading());
      final users = await userRepository.getUsers();
      print("users in cubit $users");
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError('Failed to fetch users'));
    }
  }

  


  List<User> _users = [];
  Map<String, List<FarmingLog>> _userFarmingLogMap = {};
    Map<String, DateTime> _userLastUpdateMap = {};

    Future<void> fetchUserStatistics() async {
      FarmingLogRepository farm = FarmingLogRepository();
    try {
      // Lấy tất cả các bản ghi FarmingLog
      final farmingLogList = await farm.getAllFarmingLogs();

      // Tạo một map để lưu trữ thống kê
      _userFarmingLogMap = {};
      _users = await userRepository.getUsers();


      for (var farmingLog in farmingLogList) {
        String? userId = farmingLog.uId;
        if (userId != null) {
          _userFarmingLogMap.putIfAbsent(userId, () => []).add(farmingLog);
        }

        String? ngayThucHienStr = farmingLog.ngayThucHien;
        if (ngayThucHienStr != null && ngayThucHienStr.isNotEmpty) {
          DateTime? date = _parseDate(ngayThucHienStr);
          if (date != null) {
            if (_userLastUpdateMap[userId] == null || date.isAfter(_userLastUpdateMap[userId]!)) {
              _userLastUpdateMap[userId ?? ""] = date;
            }
          }
        }
      }
      

      

      // Cập nhật trạng thái với dữ liệu thống kê
      emit(UserStatisticsLoaded(_users, _userFarmingLogMap, _userLastUpdateMap));
    } catch (e) {
      emit(UsersError('Failed to load user statistics'));
    }
  }

    DateTime? getUserLastUpdate(String userId) {
    return _userLastUpdateMap[userId];
  }

    DateTime? _parseDate(String dateStr) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateStr);
    } catch (e) {
      print('Lỗi khi phân tích ngày: $e');
      return null;
    }
  }
  List<FarmingLog> getUserFarmingLogs(String userId) {
    return _userFarmingLogMap[userId] ?? [];
  }
}

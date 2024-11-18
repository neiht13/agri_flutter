// lib/data/repository/farming_log_repository.dart

import 'package:agriplant/api_service.dart';

import '../model/user.dart';

class UserRepository {
  // Giả sử chúng ta lưu trữ dữ liệu trong bộ nhớ
  // Trong thực tế, bạn có thể tích hợp với API hoặc cơ sở dữ liệu như Firebase
  ApiService apiService = ApiService();

  Future<List<User>> getUsers() async {

    try {
      List response = await apiService.getAll('/users');
      List<User> users = response.map((json) => User.fromJson(json)).toList();
      return users;
    } catch (e){
      print('error fetch: $e');
    }
    return [];

  }


  Future<User?> getUser(String id) async {

    try {
      List response = await apiService.get('/users', {"id": id} );
      User users = User.fromJson(response.first);
      await Future.delayed(const Duration(seconds: 1));
      return users;
    } catch (e){
      print('error fetch: $e');
    }
    return null;
  }


}

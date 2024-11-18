// user_cubit.dart
import 'package:agriplant/api_service.dart';
import 'package:agriplant/models/model/nhatky.dart';
import 'package:agriplant/models/model/user.dart';
import 'package:agriplant/models/repository/farming_log_repository.dart';
import 'package:agriplant/models/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;

  UserCubit({required this.userRepository}): super(UserInitial());

  final ApiService apiService = ApiService();

  // Fetch user information
//   Future<void> fetchUsers() async {
//     emit(UserLoading());
//     try {
//       // final userData = await apiService.get("/users", {"id": userId}); // Giả sử apiService có phương thức này

//       List<User> sampleUsers = [
//         User(
//           id: '1',
//           username: 'alice',
//           email: 'alice@example.com',
//           name: 'Alice Smith',
//           image: 'https://example.com/images/alice.jpg',
//           phone: '555-1234',
//           mota: 'Farmer specializing in organic vegetables.',
//           diachi: '456 Elm Street, Springfield',
//           dientich: 50.0,
//           donvihtx: 'HTX1',
//           location: '10.3940,105.7235', // Near the specified coordinates
//           masovungtrong: 'MVT1001',
//         ),
//         User(
//           id: '2',
//           username: 'bob',
//           email: 'bob@example.com',
//           name: 'Bob Johnson',
//           image: 'https://example.com/images/bob.jpg',
//           phone: '555-5678',
//           mota: 'Produces high-quality dairy products.',
//           diachi: '789 Maple Avenue, Shelbyville',
//           dientich: 75.0,
//           donvihtx: 'HTX2',
//           location: '10.3938,105.7234', // Near the specified coordinates
//           masovungtrong: 'MVT1002',
//         ),
//         User(
//           id: '3',
//           username: 'charlie',
//           email: 'charlie@example.com',
//           name: 'Charlie Brown',
//           image: 'https://example.com/images/charlie.jpg',
//           phone: '555-8765',
//           mota: 'Cultivates a variety of grains.',
//           diachi: '321 Oak Road, Ogdenville',
//           dientich: 120.0,
//           donvihtx: 'HTX3',
//           location: '10.3942,105.7232', // Near the specified coordinates
//           masovungtrong: 'MVT1003',
//         ),
//         User(
//           id: '4',
//           username: 'diana',
//           email: 'diana@example.com',
//           name: 'Diana Prince',
//           image: 'https://example.com/images/diana.jpg',
//           phone: '555-4321',
//           mota: 'Expert in fruit orchards.',
//           diachi: '654 Pine Lane, North Haverbrook',
//           dientich: 60.0,
//           donvihtx: 'HTX4',
//           location: '10.3939,105.7236', // Near the specified coordinates
//           masovungtrong: 'MVT1004',
//         ),
//         User(
//           id: '5',
//           username: 'edward',
//           email: 'edward@example.com',
//           name: 'Edward King',
//           image: 'https://example.com/images/edward.jpg',
//           phone: '555-2468',
//           mota: 'Specializes in beekeeping and honey production.',
//           diachi: '987 Cedar Court, Capital City',
//           dientich: 30.0,
//           donvihtx: 'HTX5',
//           location: '10.3941,105.7233', // Near the specified coordinates
//           masovungtrong: 'MVT1005',
//         ),
//       ];

// //       final userData = [User.fromJson({
// //   "_id": "659f4af00368c6c0ae6edf14",
// //   "name": "Bùi Văn Phước",
// //   "username": "buivanphuoc",
// //   "password": "123",
// //   "role": "USER",
// //   "status": true,
// //   "email": null,
// //   "image": null,
// //   "phone": "0987281309",
// //   "diachi": "Xã Tân Công Sính, huyện Tam Nông, tỉnh Đồng Tháp",
// //   "location": "",
// //   "mota": null,
// //   "dientich": 10
// // }), User.fromJson({
// //         "_id": "659f4af00368c6c0ae6edf14",
// //         "name": "Bùi Văn Phước",
// //         "username": "buivanphuoc",
// //         "password": "123",
// //         "role": "USER",
// //         "status": true,
// //         "email": null,
// //         "image": null,
// //         "phone": "0987281309",
// //         "diachi": "Xã Tân Công Sính, huyện Tam Nông, tỉnh Đồng Tháp",
// //         "location": "",
// //         "mota": null,
// //         "dientich": 10
// //       })];
//       emit(UsersLoaded(users: sampleUsers));
//     } catch (e) {
//       emit(UserError(message: e.toString()));
//     }
//   }
  Future<void> fetchUser(String? userId) async {
    String? id = userId ;

    emit(UserLoading());
    try {
      id ??= await apiService.getCurrentUser();
      final userData = await userRepository.getUser(id!);
      emit(UserLoaded(user: userData));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  // Update user information
  Future<void> updateUser(User updatedUser) async {
    emit(UserLoading());
    try {
      final userData = await apiService.post("/users", updatedUser.toJson()); // Giả sử apiService có phương thức này
      emit(UserLoaded(user: updatedUser));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  // Update user information
  Future<void> ac(User updatedUser) async {
    emit(UserLoading());
    try {
      final userData = await apiService.post("/users", updatedUser.toJson()); // Giả sử apiService có phương thức này
      emit(UserLoaded(user: updatedUser));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  // Delete user (if applicable)
  Future<void> deleteUser(String userId) async {
    emit(UserLoading());
    try {
      final userData = await apiService.get("/users", {"id": userId}); // Giả sử apiService có phương thức này
      emit(UserDeleted());
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(UserLoading());
    try {
      // final success = await apiService.changePassword(currentPassword, newPassword); // Giả sử apiService có phương thức này
      // if (success) {
      //   emit(PasswordChanged());
      // } else {
      //   emit(UserError(message: 'Đổi mật khẩu thất bại. Vui lòng thử lại.'));
      // }
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  // Logout
  Future<void> logout() async {
    emit(UserLoading());
    try {
      // await apiService.logout(); // Giả sử apiService có phương thức này
      emit(UserInitial());
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

}

// lib/core/api_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://localhost:3000/api';
// const String baseUrl = 'https://ricedairy.vercel.app/api';
//const String baseUrl = 'https://gaochauthanhdt.vn/api';
//  const String baseUrl = 'https://saurienghungdung.vn/api';
//  const String baseUrl = 'https://qr.xoaidinhyen.vn/api';
//  const String baseUrl = 'https://xoaibinhan.vercel.app/api';

class ApiService {
  final Dio _dio;
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {
              'Content-Type': 'application/json',
            },
            connectTimeout: const Duration(seconds: 60),
            receiveTimeout: const Duration(seconds: 30),
          ),
        ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) {
        // Xử lý lỗi chung ở đây
        // Ví dụ: nếu lỗi là do token hết hạn, bạn có thể thực hiện làm mới token
        return handler.next(error);
      },
    ));
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('uId');
  }
  Future<String?> getCurrentUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('xId');
  }

  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth',
        data: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final prefs = await SharedPreferences.getInstance();
        String uId = data['uId'] ?? "";
        String token = data['token'] ?? "";
        String role = data['role'] ?? "";
        String xId = data['xId'] ?? "";

        await prefs.setString('uId', uId);
        await prefs.setString('token', token);
        await prefs.setString('role', role);
        await prefs.setString('xId', xId);

        print('Login successful: $data');
        return token;
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (e) {
      print('Login error: ${e.response?.data ?? e.message}');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> get(String endpoint,
      [Map<String, dynamic>? queryParameters]) async {
    String uId = await getCurrentUser() ?? "";

    // Ensure queryParameters is not null and add uId to it
    queryParameters = queryParameters ?? {};
    queryParameters['uId'] = queryParameters['uId'] ?? uId;

    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      print('GET $endpoint error: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data ?? 'GET request error');
    }
  }

  Future<List<Map<String, dynamic>>> getAll(String endpoint,
      [Map<String, dynamic>? queryParameters]) async {
    // Ensure queryParameters is not null and add uId to it
    queryParameters = queryParameters ?? {};
    queryParameters['xId'] = await getCurrentUnit();

    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      print('GET $endpoint error: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data['message'] ?? 'Lỗi tải dữ liệu');
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    String uId = await getCurrentUser() ?? "";
    data['uId'] = uId;
    try {
      final response = await _dio.post(
        endpoint,
        data: jsonEncode(data),
      );
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      print('POST $endpoint error: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data['message'] ?? 'Lỗi thêm/ sửa dữ liệu');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint, String deleteId) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: {"id": deleteId},
      );
      return response.data;
    } on DioException catch (e) {
      print('DELETE $endpoint error: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data['message'] ?? 'Lỗi xóa dữ liệu');
    }
  }

  Future<void> uploadImage(String imageName, String imageData) async {
    try {
      final response = await _dio.post(
        '/images/upload',
        data: jsonEncode({
          'imageName': imageName,
          'imageData': imageData,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Upload hình ảnh thất bại');
      }
    } on DioException catch (e) {
      print('Upload hình ảnh lỗi: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data['message'] ?? 'Tải lên hình ảnh lỗi');
    }
  }

  Future<Uint8List> fetchImage(String imageName) async {
    try {
      final response = await _dio.get(
        '/images/download/$imageName',
        queryParameters: {"filename": imageName},
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        throw Exception('Tải hình ảnh thất bại');
      }
    } on DioException catch (e) {
      print('Fetch hình ảnh lỗi: ${e.response?.data ?? e.message}');
      throw Exception(e.response?.data['message'] ?? 'tải hình ảnh lỗi');
    }
  }

  // Thêm phương thức getImageUrl
  String getImageUrl(String imageName) {
    return '$baseUrl/ftp/$imageName';
  }

}

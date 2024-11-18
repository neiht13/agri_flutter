// product_service.dart
import 'dart:convert';
import 'package:agriplant/api_service.dart';
import 'package:agriplant/models/model/nhatky.dart';
import 'package:http/http.dart' as http;
import 'agrochemicals.dart';


class AgrochemicalsService {

  AgrochemicalsService();

  // Phương thức lấy danh sách sản phẩm
  Future<List<Agrochemicals>> fetchAgrochemicalss(FarmingLog? log) async {
    ApiService _apiService = ApiService();

   try {
      final response = await _apiService.get('/phanthuoc', {'farmingLogId': log?.id});
      List<Agrochemicals> listData = response.map((json) => Agrochemicals.fromJson(json)).toList();
      return listData;
    } catch (e) { 
      print('Error fetching argochemicals logs: $e');
      rethrow; // Ném lại ngoại lệ để lớp gọi xử lý
    }
  }

  // Phương thức upload hình ảnh (giả sử đã có trong ApiService)
  Future<void> uploadImage(String imageName, String base64Image) async {
    final response = await http.post(
      Uri.parse('$baseUrl/upload'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'imageName': imageName, 'imageData': base64Image}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to upload image');
    }
  }
}

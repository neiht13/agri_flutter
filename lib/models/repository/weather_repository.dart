// lib/data/repository/weather_repository.dart
import 'dart:convert';
import 'package:agriplant/models/model/weather.dart';
import 'package:http/http.dart' as http;

class WeatherRepository {
  final String apiKey = '418e1d248b261f03b34f0eb7f9a0b1ab';

  Future<Weather> fetchCurrentWeather(String cityName) async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric&lang=vi',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Weather.fromJson(jsonData);
    } else {
      throw Exception('Không thể tải dữ liệu thời tiết');
    }
  }
  Future<Weather> fetchCurrentWeatherByCoordinates(
      double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=vi',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Weather.fromJson(jsonData);

    } else {
      throw Exception('Không thể tải dữ liệu thời tiết');
    }
  }

  Future<List<Weather>> fetchForecastByCoordinates(
      double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=vi',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> list = jsonData['list'];
      return list.map((item) {
        return Weather.fromJson(item);

      }).toList();
    } else {
      throw Exception('Không thể tải dữ liệu dự báo thời tiết');
    }
  }

  Future<List<Weather>> fetchForecast(String cityName) async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric&lang=vi',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> list = jsonData['list'];
      return list.map((item) {
        return Weather.fromJson(item);
      }).toList();
    } else {
      throw Exception('Không thể tải dữ liệu dự báo thời tiết');
    }

  }
}

// lib/data/model/weather.dart
import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double windSpeed;
  final int humidity;
  final double? visibility;
  final double? cloudiness;
  final DateTime date;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.humidity,
    this.visibility,
    this.cloudiness,
    required this.date,
  });

  @override
  List<Object?> get props => [
    cityName,
    temperature,
    description,
    icon,
    windSpeed,
    humidity,
    cloudiness,
    visibility,
    date,
  ];

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'] ?? '',
      windSpeed: json['wind']['speed'].toDouble(),
      visibility: json['visibility'].toDouble(),
      cloudiness: json['clouds']['all'].toDouble(),
      humidity: json['main']['humidity'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),


    );
  }
}

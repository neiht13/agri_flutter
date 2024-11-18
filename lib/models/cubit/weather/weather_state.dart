// lib/data/cubit/weather/weather_state.dart
part of 'weather_cubit.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather currentWeather;
  final List<Weather> forecast;

  const WeatherLoaded({required this.currentWeather, required this.forecast});

  @override
  List<Object?> get props => [currentWeather, forecast];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError({required this.message});

  @override
  List<Object?> get props => [message];
}

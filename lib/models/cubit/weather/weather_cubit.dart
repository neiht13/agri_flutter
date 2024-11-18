// lib/data/cubit/weather/weather_cubit.dart
import 'package:agriplant/models/model/weather.dart';
import 'package:agriplant/models/repository/weather_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherCubit({required this.weatherRepository}) : super(WeatherInitial());

  Future<void> fetchWeather(String cityName) async {
    try {
      emit(WeatherLoading());
      final Weather currentWeather = await weatherRepository.fetchCurrentWeather(cityName);
      final List<Weather> forecast = await weatherRepository.fetchForecast(cityName);
      emit(WeatherLoaded(currentWeather: currentWeather, forecast: forecast));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }
  Future<void> fetchWeatherByCoordinates(
      double latitude, double longitude) async {
    try {
      emit(WeatherLoading());
      final Weather currentWeather =
      await weatherRepository.fetchCurrentWeatherByCoordinates(
        latitude,
        longitude,
      );
      final List<Weather> forecast =
      await weatherRepository.fetchForecastByCoordinates(
        latitude,
        longitude,
      );
      emit(WeatherLoaded(currentWeather: currentWeather, forecast: forecast));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }
}

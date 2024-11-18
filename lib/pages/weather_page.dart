// lib/presentation/screen/weather/weather_page.dart
import 'package:agriplant/models/cubit/weather/weather_cubit.dart';
import 'package:agriplant/models/model/weather.dart';
import 'package:agriplant/utils/contants.dart';
import 'package:agriplant/widgets/custom_icon.dart';
import 'package:agriplant/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  ConsumerState<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  final _cityController = TextEditingController(text: 'Cao Lãnh');

  @override
  void initState() {
    super.initState();
    // Fetch weather data for the default city
    context.read<WeatherCubit>().fetchWeather(_cityController.text);
    _getCurrentLocationWeather();
  }

  Future<void> _getCurrentLocationWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra xem dịch vụ định vị đã được bật hay chưa
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dịch vụ định vị chưa được bật.')),
      );
      return;
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Quyền truy cập vị trí bị từ chối.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Quyền truy cập vị trí đã bị từ chối vĩnh viễn.')),
      );
      return;
    }

    // Lấy vị trí hiện tại
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Sử dụng tọa độ để lấy dữ liệu thời tiết
    context.read<WeatherCubit>().fetchWeatherByCoordinates(
          position.latitude,
          position.longitude,
        );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _searchWeather() {
    if (_cityController.text.isNotEmpty) {
      context.read<WeatherCubit>().fetchWeather(_cityController.text);
    }
  }

  Widget _buildCurrentWeather(Weather weather) {
    return Column(
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          DateFormat('EEEE, dd MMMM yyyy', 'vi').format(weather.date),
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
              width: 120,
              height: 120,
            ),
            Column(
              children: [
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                      fontSize: 50, fontWeight: FontWeight.bold),
                ),
                Text(
                  weather.description,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildWeatherInfo(
              icon: FontAwesomeIcons.wind,
              label: 'Gió',
              value: '${weather.windSpeed} m/s',
            ),
            _buildWeatherInfo(
              icon: FontAwesomeIcons.umbrella,
              label: 'Độ ẩm',
              value: '${weather.humidity}%',
            ),
            _buildWeatherInfo(
              icon: FontAwesomeIcons.hurricane,
              label: 'Tầm nhìn xa',
              value: '${weather.visibility} m',
            ),
            _buildWeatherInfo(
              icon: FontAwesomeIcons.cloud,
              label: 'Trời có mây',
              value: '${weather.cloudiness}%',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherInfo(
      {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon,
            color: Colors.blue), // Thay đổi Colors.green nếu cần
        const SizedBox(height: 4),
        Text(label),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildForecast(List<Weather> forecast) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.length,
        itemBuilder: (context, index) {
          final weather = forecast[index];
          return Container(
            width: 100,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('HH:mm').format(weather.date),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Image.network(
                  'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 8),
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  weather.description,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeatherContent(WeatherState state) {
    if (state is WeatherLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WeatherLoaded) {
      return Column(
        children: [
          _buildCurrentWeather(state.currentWeather),
          const SizedBox(height: 24),
          const Text(
            'Dự báo thời tiết',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildForecast(state.forecast),
        ],
      );
    } else if (state is WeatherError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thời Tiết'),
        actions: [
          const Text("Vị trí hiện tại"),
          IconButton(
            icon: const Icon(Icons.my_location), // Thay đổi màu nếu cần
            onPressed: () {
             
            },
          ),
        ],
      ),
      body: Container(
        height: 1000,
        decoration: const BoxDecoration(
          backgroundBlendMode: BlendMode.colorBurn,
          gradient: LinearGradient(
            colors: [primaryColor, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              return Column(
                children: [
                  InputField(
                    controller: _cityController,
                    labelText: '',
                    suffixIcon: const CustomIcon(
                      FontAwesomeIcons.magnifyingGlass,
                    ),
                    // prefixIcon: const CustomIcon(FontAwesomeIcons.magnifyingGlass,),
                    onSuffixIconPressed: _searchWeather,
                  ),
                  const SizedBox(height: 16),
                  _buildWeatherContent(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

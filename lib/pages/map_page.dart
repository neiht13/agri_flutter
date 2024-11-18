import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Vị trí trung tâm bản đồ (tọa độ vườn xoài)
    const LatLng gardenCenter = LatLng(10.456789, 105.123456); // Thay bằng tọa độ thực tế

    // Danh sách các marker (các cây xoài hoặc điểm quan trọng)
    final List<Marker> markers = [
      const Marker(
        width: 80,
        height: 80,
        point: gardenCenter,
        child: Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ),
      ),
      // Thêm các marker khác nếu cần
    ];

  final Map<String, String> mapLayers = {
    'Mặc định': 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
    'Vệ tinh': 'http://{s}.google.com/vt/lyrs=y&x={x}&y={y}&z={z}', // Thay đổi URL cho Satellite nếu cần
  };
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ Vườn xoài'),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: gardenCenter,
          initialZoom: 15.0,
          // Nếu muốn, có thể thêm các tùy chọn khác
        ),
        children: [
          TileLayer(
            urlTemplate: 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
            subdomains: const ['mt0','mt1','mt2','mt3'],
            userAgentPackageName: 'com.example.app', // Thay bằng package name của bạn
          ),
          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
    );
  }
}

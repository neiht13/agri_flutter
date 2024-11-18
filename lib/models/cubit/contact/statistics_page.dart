import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int visitCount = 0;

  @override
  void initState() {
    super.initState();
    fetchVisitCount();
  }

  Future<void> fetchVisitCount() async {
    final response = await http.get(Uri.parse('https://your-api.com/visits'));

    if (response.statusCode == 200) {
      setState(() {
        visitCount = int.parse(response.body);
      });
    } else {
      throw Exception('Failed to load visit count');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Số lượt truy cập: $visitCount',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}

import 'package:agriplant/models/model/user.dart';
import 'package:agriplant/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agriplant/models/cubit/user/users_cubit.dart';
import 'package:intl/intl.dart';

class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách FarmingLog của người dùng
    final farmingLogList = context.read<UsersCubit>().getUserFarmingLogs(user.id);

    // Lấy tháng và năm hiện tại
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    // Xử lý dữ liệu để chuẩn bị cho biểu đồ
    Map<int, int> entriesPerDay = {}; // key: day, value: count

    for (var farmingLog in farmingLogList) {
      String? ngayThucHienStr = farmingLog.ngayThucHien;
      if (ngayThucHienStr != null && ngayThucHienStr.isNotEmpty) {
        // Giả sử định dạng ngày là "dd/MM/yyyy"
        DateTime? date = _parseDate(ngayThucHienStr);
        if (date != null) {
          // Chỉ lấy nhật ký trong tháng và năm hiện tại
          if (date.month == currentMonth && date.year == currentYear) {
            int day = date.day;
            entriesPerDay.update(day, (value) => value + 1, ifAbsent: () => 1);
          }
        }
      }
    }

    // Chuyển đổi dữ liệu thành danh sách cho biểu đồ
    List<FlSpot> spots = entriesPerDay.entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.toDouble());
    }).toList();

    // Sắp xếp danh sách theo ngày
    spots.sort((a, b) => a.x.compareTo(b.x));

    // Tìm giá trị Y tối đa
    double maxY = 0;
    if (spots.isNotEmpty) {
      maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết người dùng'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: spots.isNotEmpty
            ? LineChart(
                LineChartData(
                  minX: 1,
                  maxX: 31, // Số ngày tối đa trong tháng
                  minY: 0,
                  maxY: maxY + 1, // Thêm 1 cho khoảng trống
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          int day = value.toInt();
                          if (day >= 1 && day <= 31) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 10,
                              child: Text('$day'),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: false,
                      barWidth: 2,
                      color: primaryColor,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                ),
              )
            : const Center(child: Text('Không có dữ liệu để hiển thị biểu đồ')),
      ),
    );
  }

  DateTime? _parseDate(String dateStr) {
    try {
      // Giả sử định dạng ngày là "dd/MM/yyyy"
      return DateFormat('dd/MM/yyyy').parse(dateStr);
    } catch (e) {
      print('Lỗi khi phân tích ngày: $e');
      return null;
    }
  }
}

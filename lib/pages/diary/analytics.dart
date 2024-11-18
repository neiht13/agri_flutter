// statistic_page.dart
import 'package:agriplant/models/cubit/nhatky/nhatky_cubit.dart';
import 'package:agriplant/models/cubit/nhatky/nhatky_state.dart';
import 'package:agriplant/models/cubit/season/season_cubit.dart';
import 'package:agriplant/models/cubit/user/user_cubit.dart';
import 'package:agriplant/models/cubit/user/users_cubit.dart';
import 'package:agriplant/models/model/nhatky.dart';
import 'package:agriplant/models/model/season.dart';
import 'package:agriplant/models/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _selectedDateRange;
  Season? _selectedSeason;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load dữ liệu mùa vụ khi trang được tạo
    context.read<SeasonCubit>().fetchSeasons();
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
         final primaryColor = Theme.of(context).colorScheme.primary;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor, // Màu chủ đạo
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // Màu cho các nút
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      // Lấy dữ liệu mới dựa trên phạm vi ngày đã chọn
      if (_selectedSeason != null) {
        context.read<FarmingLogCubit>().fetchFarmingLogsSeasonAndDateRange(
          _selectedSeason!.muavu!,
          _selectedDateRange!,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng Scaffold với thiết kế hiện đại hơn
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê'),
        // backgroundColor: primaryColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            // color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Chi phí'),
                Tab(text: 'Công việc'),
                Tab(text: 'Thống kê người dùng'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Bộ lọc dữ liệu với thiết kế mới
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            // color: primaryColor,
            child: Column(
              children: [
                // Dropdown chọn mùa vụ với thiết kế mới
                BlocBuilder<SeasonCubit, List<Season>>(
                  builder: (context, seasons) {
                    if (seasons.isEmpty) {
                      return const SizedBox();
                    }
                    return DropdownButtonFormField<Season>(
                      value: _selectedSeason,
                      hint: const Text(
                        'Chọn mùa vụ',
                        style: TextStyle(color: Colors.white),
                      ),
                      items: seasons.map((Season season) {
                        return DropdownMenuItem<Season>(
                          value: season,
                          child: Text('Mùa vụ: ${season.muavu} (${season.nam})'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSeason = newValue;
                          if (_selectedSeason != null) {
                            // Load dữ liệu công việc cho mùa vụ đã chọn và phạm vi ngày
                            if (_selectedDateRange != null) {
                              context
                                  .read<FarmingLogCubit>()
                                  .fetchFarmingLogsSeasonAndDateRange(
                                _selectedSeason!.muavu!,
                                _selectedDateRange!,
                              );
                            } else {
                              context
                                  .read<FarmingLogCubit>()
                                  .fetchFarmingLogsSeason(_selectedSeason?.muavu ?? "");
                            }
                          }
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none),
                        labelText: 'Mùa vụ',
                        labelStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                // Chọn phạm vi ngày cùng nút lấy vị trí
                GestureDetector(
                  onTap: () => _selectDateRange(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.date_range, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedDateRange == null
                                ? 'Chọn từ ngày - đến ngày'
                                : 'Từ ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start)} '
                                'đến ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end)}',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Hiển thị nội dung theo tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Thống kê chi phí nhập vào
                _buildCostStatistics(),
                // Tab 2: Thống kê công việc từng loại trong từng giai đoạn
                _buildTaskStatistics(),
                _buildAdminStatistics(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget thống kê chi phí (Tab 1)

Widget _buildCostStatistics() {
  return BlocBuilder<FarmingLogCubit, FarmingLogState>(
    builder: (context, state) {
      if (state is FarmingLogLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is FarmingLogLoaded) {
        List<FarmingLog> logs = state.logs;

        if (logs.isEmpty) {
          return const Center(child: Text('Chưa có dữ liệu về chi phí'));
        }

        // Tính tổng chi phí theo tháng
        Map<String, double> costByMonth = {};
        for (var log in logs) {
          if (log.ngayThucHien != null) {
            String month = DateFormat('MM/yyyy').format(DateFormat('dd/MM/yyyy').parse(log.ngayThucHien!));
            costByMonth.update(
              month, 
              (value) => value + log.chiPhiVatTu.toDouble(),
              ifAbsent: () => log.chiPhiVatTu.toDouble()
            );
          }
        }

        // Chuyển đổi dữ liệu để sử dụng trong biểu đồ
        List<BarChartGroupData> barGroups = [];
        int index = 0;
        costByMonth.forEach((month, cost) {
          barGroups.add(
            BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: cost,
                  color: Theme.of(context).primaryColor,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Colors.white, width: 1),
                ),
              ],
              showingTooltipIndicators: [0],
            ),
          );
          index++;
        });

        // Calculate interval with a minimum value to prevent zero
        double interval = costByMonth.values.isNotEmpty
            ? (costByMonth.values.reduce((a, b) => a > b ? a : b) / 5)
            : 20;
        if (interval == 0) {
          interval = 20; // Set to a default value if zero
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tổng chi phí
              Text(
                'Tổng chi phí: ${logs.fold(0.0, (sum, log) => sum + (log.chiPhiVatTu ?? 0.0))} VND',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Biểu đồ chi phí
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: costByMonth.values.isNotEmpty
                            ? costByMonth.values.reduce((a, b) => a > b ? a : b) * 1.2
                            : 100,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              String month = costByMonth.keys.elementAt(group.x.toInt());
                              return BarTooltipItem(
                                '$month\n',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '${rod.toY.toStringAsFixed(2)} VND',
                                    style: const TextStyle(
                                      color: Colors.yellowAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                String month = costByMonth.keys.elementAt(value.toInt());
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    month,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              },
                              reservedSize: 40,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: interval, // Use the calculated interval
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: barGroups,
                        gridData: const FlGridData(show: true, drawVerticalLine: false),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (state is FarmingLogError) {
        return Center(
          child: Text(
            state.message,
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
        );
      } else {
        return const Center(child: Text('Không có dữ liệu.'));
      }
    },
  );
}

  // Widget thống kê công việc (Tab 2)
  Widget _buildTaskStatistics() {
    return BlocBuilder<FarmingLogCubit, FarmingLogState>(
      builder: (context, state) {
        if (state is FarmingLogLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FarmingLogLoaded) {
          List<FarmingLog> logs = state.logs;

          if (logs.isEmpty) {
            return const Center(child: Text('Chưa có dữ liệu về công việc'));
          }

          // Lọc dữ liệu theo mùa vụ và phạm vi ngày
          List<FarmingLog> filteredLogs = logs.where((log) {
            bool matchesSeason = _selectedSeason == null ||
                log.muaVu == _selectedSeason!.muavu;
            bool matchesDate = _selectedDateRange == null ||
                (log.ngayThucHien != null &&
                    DateFormat('dd/MM/yyyy').parse(log.ngayThucHien!).isAfter(_selectedDateRange!.start.subtract(const Duration(days:1))) &&
                    DateFormat('dd/MM/yyyy').parse(log.ngayThucHien!).isBefore(_selectedDateRange!.end.add(const Duration(days:1))));
            return matchesSeason && matchesDate;
          }).toList();

          if (filteredLogs.isEmpty) {
            return const Center(child: Text('Không có dữ liệu trong phạm vi đã chọn.'));
          }

          // Tạo thống kê theo loại công việc
          Map<String, int> taskCountByType = {};
          for (var log in filteredLogs) {
            String type = log.congViec ?? 'Không xác định';
            taskCountByType.update(type, (value) => value + 1, ifAbsent: () => 1);
          }

          // Tính tổng công việc
          int totalTasks = taskCountByType.values.fold(0, (sum, count) => sum + count);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Tổng công việc
                Text(
                  'Tổng công việc: $totalTasks',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Biểu đồ công việc
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: taskCountByType.entries.map((entry) {
                            final double percentage = (entry.value / totalTasks) * 100;
                            return PieChartSectionData(
                              color: _getColor(entry.key),
                              value: percentage,
                              title: '${percentage.toStringAsFixed(1)}%',
                              radius: 50,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Danh sách chi tiết công việc
                Expanded(
                  child: ListView(
                    children: taskCountByType.entries.map((entry) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getColor(entry.key),
                          child: Text(
                            entry.key[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(entry.key),
                        trailing: Text('${entry.value} công việc'),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        } else if (state is FarmingLogError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        } else {
          return const Center(child: Text('Không có dữ liệu.'));
        }
      },
    );
  }

Widget _buildAdminStatistics() {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return const Center(child: Text('Không có người dùng trong đơn vị.'));
        }
        if (state is UsersLoaded) {
          List<User> users = state.users;

          return BlocBuilder<FarmingLogCubit, FarmingLogState>(
            builder: (context, state) {
              if (state is FarmingLogLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FarmingLogLoaded) {
                List<FarmingLog> logs = state.logs;

                if (logs.isEmpty) {
                  return const Center(child: Text('Chưa có dữ liệu về nhật ký.'));
                }

                // Build statistics based on users and logs
                // For example, total logs per user
                Map<String, int> logCountByUser = {};

                for (var log in logs) {
                  String userId = log.uId ?? '';
                  if (userId.isNotEmpty) {
                    logCountByUser.update(userId, (value) => value + 1, ifAbsent: () => 1);
                  }
                }

                // Map userIds to usernames
                Map<String, String> userNames = {};
                for (var user in users) {
                  userNames[user.id] = user.name ?? user.username;
                }

                // Build the UI
                return ListView(
                  children: logCountByUser.entries.map((entry) {
                    String userId = entry.key;
                    int logCount = entry.value;
                    String userName = userNames[userId] ?? 'Unknown';

                    return ListTile(
                      title: Text(userName),
                      trailing: Text('$logCount nhật ký'),
                    );
                  }).toList(),
                );
              } else if (state is FarmingLogError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                );
              } else {
                return const Center(child: Text('Không có dữ liệu.'));
              }
            },
          );
        } else {
          return const Center(child: Text('Không có dữ liệu.'));
        }
      },
    );
  }
  // Hàm lấy màu dựa trên loại công việc
  Color _getColor(String type) {
    // Bạn có thể tùy chỉnh màu sắc dựa trên loại công việc
    switch (type.toLowerCase()) {
      case 'bón phân':
        return Colors.green;
      case 'thu hoạch':
        return Colors.orange;
      case 'phun thuốc':
        return Colors.blue;
      case 'làm đất':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

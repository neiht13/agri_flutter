// farming_log_page.dart

import 'package:agriplant/api_service.dart';
import 'package:agriplant/models/cubit/nhatky/nhatky_cubit.dart';
import 'package:agriplant/models/model/nhatky.dart';
import 'package:agriplant/models/model/user.dart';
import 'package:agriplant/models/repository/user_repository.dart';
import 'package:agriplant/pages/diary/card_log.dart';
import 'package:agriplant/pages/diary/nhatky_form.dart';
import 'package:agriplant/routes.dart';
import 'package:agriplant/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;

import '../../models/cubit/nhatky/nhatky_state.dart';

class FarmingLogPage extends StatefulWidget {
  const FarmingLogPage({super.key});

  @override
  State<FarmingLogPage> createState() => _FarmingLogPageState();
}

class _FarmingLogPageState extends State<FarmingLogPage> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedUserId;
  String currentUserRole = 'USER';

  void _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _fromDate != null && _toDate != null
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : DateTimeRange(start: DateTime.now(), end: DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked.start;
        _toDate = picked.end;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    context.read<FarmingLogCubit>().fetchFarmingLogs(null);
    ApiService().getRole().then((role) {
      setState(() {
        currentUserRole = role ?? 'USER';
      });
    });
  }

  void _resetFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _selectedUserId = null;
    });
  }

  void _showUserSelectionDialog() async {
    List<User> users = await UserRepository().getUsers();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn người dùng'),
          content: SizedBox(
            width: double.maxFinite,
            child: users.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      User user = users[index];
                      return ListTile(
                        title: Text(user.name ?? 'No Name'),
                        onTap: () {
                          setState(() {
                            _selectedUserId = user.id;
                          });
                          Navigator.of(context).pop();
                          context.read<FarmingLogCubit>().fetchFarmingLogs(user.id);
                        },
                      );
                    },
                  )
                : const Text('Không có người dùng nào.'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedUserId = null;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Bỏ chọn'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return BlocProvider.value(
                value: context.read<FarmingLogCubit>(),
                child: const FarmingLogForm(),
              );
            },
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: BlocBuilder<FarmingLogCubit, FarmingLogState>(
        builder: (context, state) {
          if (state is FarmingLogLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FarmingLogLoaded) {
            final logs = state.logs;

            // Lọc dữ liệu dựa trên tìm kiếm, ngày và người dùng
            String searchQuery = _searchController.text.toLowerCase();
            List<FarmingLog> filteredAndSortedLogs = logs.where((log) {
              final searchText = (log.congViec ?? "").toLowerCase();
              final matchesSearch =
                  searchText.contains(searchQuery.toLowerCase());

              DateTime? logDate;
              if (log.ngayThucHien != null) {
                try {
                  logDate = DateFormat('dd/MM/yyyy').parse(log.ngayThucHien!);
                } catch (e) {
                  logDate = null;
                }
              }

              final matchesDate = (_fromDate == null && _toDate == null) ||
                  (logDate != null &&
                      !logDate!.isBefore(_fromDate ?? DateTime(2000)) &&
                      !logDate.isAfter(_toDate ?? DateTime(2100)));

              final matchesUser = (currentUserRole == 'ADMIN' && _selectedUserId != null)
                  ? log.uId == _selectedUserId
                  : true;

              return matchesSearch && matchesDate && matchesUser;
            }).toList();

            // Sắp xếp danh sách đã lọc theo ngày thực hiện
            filteredAndSortedLogs.sort((a, b) {
              DateTime? dateA;
              DateTime? dateB;

              if (a.ngayThucHien != null) {
                try {
                  dateA = DateFormat('dd/MM/yyyy').parse(a.ngayThucHien!);
                } catch (e) {
                  dateA = null;
                }
              }

              if (b.ngayThucHien != null) {
                try {
                  dateB = DateFormat('dd/MM/yyyy').parse(b.ngayThucHien!);
                } catch (e) {
                  dateB = null;
                }
              }

              if (dateA == null && dateB == null) return 0;
              if (dateA == null) return -1;
              if (dateB == null) return 1;

              return dateA.compareTo(dateB);
            });

            // Nhóm các logs theo stage
            Map<String, List<FarmingLog>> logsGroupedByStage = {};
            for (var log in filteredAndSortedLogs) {
              String stage = log.giaiDoan ?? 'Unknown Stage';
              if (logsGroupedByStage.containsKey(stage)) {
                logsGroupedByStage[stage]!.add(log);
              } else {
                logsGroupedByStage[stage] = [log];
              }
            }

            // Xây dựng danh sách các stages để duyệt theo thứ tự
            List<String> stages = logsGroupedByStage.keys.toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Thanh tìm kiếm và bộ lọc
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSearchField(),
                        ),
                        const SizedBox(width: 10),
                        _buildFilterButton(),
                      ],
                    ),
                  ),
                  // Hiển thị thông tin về phạm vi ngày được chọn
                  if (_fromDate != null && _toDate != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            'Từ ${DateFormat('dd/MM/yyyy').format(_fromDate!)} đến ${DateFormat('dd/MM/yyyy').format(_toDate!)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _resetFilters,
                            child: const Text(
                              'Xóa lọc',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Hiển thị thông tin người dùng được chọn
                  if (currentUserRole == 'ADMIN' && _selectedUserId != null)
                    FutureBuilder<User?>(
                      future: UserRepository().getUser(_selectedUserId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          User user = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Text(
                                  'Đang xem nhật ký của: ${user.name}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedUserId = null;
                                    });
                                  },
                                  child: const Text(
                                    'Bỏ chọn',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  // Hiển thị logs theo từng stage dưới dạng timeline
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stages.length,
                    itemBuilder: (context, stageIndex) {
                      String stage = stages[stageIndex];
                      List<FarmingLog> logsInStage = logsGroupedByStage[stage]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tiêu đề của stage
                          Container(
                            width: double.infinity,
                            color: Colors.grey[200],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              stage,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Hiển thị các log trong stage này
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: logsInStage.length,
                            itemBuilder: (context, index) {
                              final log = logsInStage[index];
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Timeline indicator
                        
                                  // Log item
                                  Expanded(
                                    child: FarmingLogItem(
                                      log: log,
                                      index: index,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is FarmingLogError) {
            return Center(
              child: Text(
                'Đã xảy ra lỗi: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(child: Text('Không có dữ liệu.'));
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    final primaryColor = Theme.of(context).primaryColor;

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(
        "Sổ Tay Canh Tác",
        style: TextStyle(
          color: primaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (currentUserRole == 'ADMIN')
          IconButton(
            icon: Icon(Icons.account_circle, color: primaryColor),
            onPressed: () {
              _showUserSelectionDialog();
            },
          ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton.filledTonal(
            onPressed: () {
              context.push("/notifications");
            },
            icon: badges.Badge(
              badgeContent: const Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              position: badges.BadgePosition.topEnd(top: -15, end: -12),
              badgeStyle: badges.BadgeStyle(
                badgeColor: primaryColor,
              ),
              child: const CustomIcon(IconlyBroken.notification),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm công việc',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: () => _selectDateRange(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.filter_list,
          color: Colors.white,
        ),
      ),
    );
  }
}

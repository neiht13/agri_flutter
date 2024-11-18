// pages/profile/user_management_page.dart

import 'package:agriplant/models/cubit/user/users_cubit.dart';
import 'package:agriplant/models/model/user.dart';
import 'package:agriplant/pages/profile/add_user_form.dart';
import 'package:agriplant/pages/profile/user_item.dart';
import 'package:agriplant/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({Key? key}) : super(key: key);

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final usersCubit = context.read<UsersCubit>();
    // usersCubit.fetchUsers();
    usersCubit.fetchUserStatistics();
  }

  @override
  Widget build(BuildContext context) {
    // Use the unified theme for the entire application
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open a modal bottom sheet to add a new user
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return BlocProvider.value(
                value: context.read<UsersCubit>(),
                child: const UserForm(),
              );
            },
          );
        },
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserStatisticsLoaded) {
            final users = state.users;
            final userFarmingLogMap = state.userFarmingLogMap;
    final userLastUpdateMap = state.userLastUpdateMap;

            // Filter users based on the search query
            String searchQuery = _searchController.text.toLowerCase();
            List<User> filteredUsers = users.where((user) {
              final matchesSearch = user.name?.toLowerCase().contains(searchQuery);
              return matchesSearch ?? false;
            }).toList();

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                // Search field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: _buildSearchField(),
                ),
                // Display a message if no users are found
                if (filteredUsers.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Không tìm thấy người dùng nào.'),
                    ),
                  ),
                // List of user items
                ...filteredUsers.asMap().entries.map((entry) {
                  int index = entry.key;
                  User user = entry.value;
                  int entryCount = userFarmingLogMap[user.id]?.length ?? 0;
                          DateTime? lastUpdate = userLastUpdateMap[user.id];

                  return UserItem(
                    user: user,
                    index: index,
                    entryCount: entryCount,
                    lastUpdate: lastUpdate
                  );
                }).toList(),
              ],
            );
          } else if (state is UsersError) {
            return Center(
              child: Text(
                'An error occurred: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }

  // Build the AppBar with the same style
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        "Quản lý người dùng",
        style: TextStyle(
          color: primaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Build the search field
  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Tìm kiếm người dùng',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        setState(() {}); // Refresh the UI when the search query changes
      },
    );
  }
}

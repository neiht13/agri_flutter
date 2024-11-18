import 'package:agriplant/api_service.dart';
import 'package:agriplant/widgets/custom_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class BottomBarCustom extends StatefulWidget {
  const BottomBarCustom({super.key});

  @override
  State<BottomBarCustom> createState() => _BottomBarCustomState();
}

class _BottomBarCustomState extends State<BottomBarCustom> {
  int _selectedIndex = 0;
  List<BottomNavigationItem> bottomNavigationItems = [];

  @override
  void initState() {
    super.initState();
    _initializeNavigationItems();
  }

  Future<void> _initializeNavigationItems() async {
    String role = await ApiService().getRole() ?? "";
    print('role ${role}');
    setState(() {
      bottomNavigationItems = [
        const BottomNavigationItem('/farmlogs', IconlyBroken.calendar, 'Nhật ký'),
        const BottomNavigationItem('/season', IconlyBroken.activity, 'Mùa vụ'),
        (role == "ADMIN" ? const BottomNavigationItem('/usermanage' , IconlyBroken.work, 'Quản lý'):
        const BottomNavigationItem('/weather', IconlyBroken.star, 'Thời tiết')),
        const BottomNavigationItem('/chart', IconlyBroken.chart, 'Thống kê'),
        const BottomNavigationItem('/profile', IconlyBroken.profile, 'Thông tin'),
      ];
    });
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      context.push(bottomNavigationItems[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu danh sách chưa được khởi tạo
    if (bottomNavigationItems.isEmpty) {
      return const SizedBox(); // Hoặc một widget loading tùy ý
    }

    int itemCount = bottomNavigationItems.length;
    double itemWidth = MediaQuery.of(context).size.width / itemCount;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: bottomNavigationItems.map((item) {
            int index = bottomNavigationItems.indexOf(item);

            double iconSize = 24.0;
            double selectedIconSize = 26.0;

            return BottomNavigationBarItem(
              icon: CustomIcon(
                item.icon,
                color: Colors.grey,
                size: iconSize,
              ),
              activeIcon: CustomIcon(
                item.icon,
                size: selectedIconSize,
                color: primaryColor,
              ),
              label: item.label,
            );
          }).toList(),
          onTap: _onItemTapped,
        ),
        Positioned(
          bottom: kBottomNavigationBarHeight + 31,
          left: _selectedIndex * itemWidth + itemWidth * 0.25,
          child: Container(
            width: itemWidth * 0.5,
            height: 2,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomNavigationItem {
  final String route;
  final IconData icon;
  final String label;

  const BottomNavigationItem(this.route, this.icon, this.label);
}


import 'package:agriplant/pages/explore_page.dart';
import 'package:agriplant/pages/my_trees_page.dart';
import 'package:agriplant/pages/noti_page.dart';
import 'package:agriplant/pages/profile/profile_page.dart';
import 'package:agriplant/widgets/bottom_bar.dart';
import 'package:agriplant/widgets/drawer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
      final Widget child; // Widget để thay đổi nội dung theo trang

  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const ExplorePage(),
    const MyTreesPage(),
    // const NotificationsPage(),
    const ProfilePage(),
  ];
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerWidget(),
    
      body: SafeArea(child: widget.child),
      bottomNavigationBar: BounceInUp(child: const BottomBarCustom())
    );
  }
}

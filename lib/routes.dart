import 'package:agriplant/models/tree.dart';
import 'package:agriplant/pages/diary/analytics.dart';
import 'package:agriplant/pages/diary/category.dart';
import 'package:agriplant/pages/diary/diary_page.dart';
import 'package:agriplant/pages/diary/watermeter_form.dart';
import 'package:agriplant/pages/profile/about_page.dart';
import 'package:agriplant/pages/profile/change_password_page.dart';
import 'package:agriplant/pages/drawer/chat_page.dart';
import 'package:agriplant/pages/drawer/contact_page.dart';
import 'package:agriplant/pages/explore_page.dart';
import 'package:agriplant/pages/drawer/feedback_page.dart';
import 'package:agriplant/pages/profile/edit_profile_page.dart';
import 'package:agriplant/pages/profile/help_page.dart';
import 'package:agriplant/pages/main_page.dart';
import 'package:agriplant/pages/map_page.dart';
import 'package:agriplant/pages/my_tree_details_page.dart';
import 'package:agriplant/pages/my_trees_page.dart';
import 'package:agriplant/pages/drawer/news_page.dart';
import 'package:agriplant/pages/noti_page.dart';
import 'package:agriplant/pages/onboarding_page.dart';
import 'package:agriplant/pages/profile/profile_page.dart';
import 'package:agriplant/pages/profile/settings_page.dart';
import 'package:agriplant/pages/auth/signin.dart';
import 'package:agriplant/pages/auth/signup.dart';
import 'package:agriplant/pages/profile/user_management_page.dart';
import 'package:agriplant/pages/tree_details_page.dart';
import 'package:agriplant/pages/weather_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/intro',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        // `child` sẽ là nội dung của từng trang khác nhau
        return MainPage(child: child); // HomeScreen chứa BottomNavigationBar
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const ExplorePage();
          },
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) {
            return const ExplorePage();
          },
        ),
        GoRoute(
          path: '/mytrees',
          builder: (context, state) {
            return const MyTreesPage();
          },
        ),
      
        GoRoute(
          path: '/profile',
          builder: (context, state) {
            return const ProfilePage();
          },
        ),
        GoRoute(
          path: '/news',
          builder: (context, state) {
            return const NewsPage();
          },
        ),
        GoRoute(
          path: '/supports',
          builder: (context, state) {
            return const ContactPage();
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) {
            return const SettingsPage();
          },
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) {
            return const ChatPage();
          },
        ),
        // GoRoute(
        //   path: '/notifications',
        //   builder: (context, state) {
        //     return const NotificationsPage();
        //   },
        // ),
        GoRoute(
          path: '/map',
          builder: (context, state) =>  const WaterMeterForm(),
        ),
        GoRoute(
          path: '/weather',
          builder: (context, state) => const WeatherPage(),
        ),
        GoRoute(
            path: '/feedback',
            builder: (context, state) => const FeedbackPage()),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const ContactPage(),
        ),
        GoRoute(
          path: '/changepassword',
          builder: (context, state) => const ChangePasswordPage(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutPage(),
        ),
        GoRoute(
          path: '/help',
          builder: (context, state) => const HelpPage(),
        ),
        GoRoute(
          path: '/farmlogs',
          builder: (context, state) => const FarmingLogPage(),
        ),
        GoRoute(
          path: '/season',
          builder: (context, state) => const UpdateCategoryPage(),
        ),
        GoRoute(
          path: '/editprofile',
          builder: (context, state) => const EditPersonalInfoPage(),
        ),
        // GoRoute(
        //   path: '/trees',
        //   builder: (context, state) => const(),
        // ),
        GoRoute(
          path: '/treedetails',
          builder: (context, state) => TreeDetailsPage(tree: state.extra as Tree,),
        ),
        GoRoute(
          path: '/chart',
          builder: (context, state) => const StatisticPage(),
        ),
        GoRoute(
          path: '/usermanage',
          builder: (context, state) => const UserManagementPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const SigninPage();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        return const SignupPage();
      },
    ),
    GoRoute(
      path: '/intro',
      builder: (context, state) {
        return const OnboardingPage();
      },
    ),
  ],
);

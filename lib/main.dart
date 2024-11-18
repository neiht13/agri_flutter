import 'dart:ui';

import 'package:agriplant/firebase_options.dart';
import 'package:agriplant/models/cubit/contact/contact.dart';
import 'package:agriplant/models/cubit/nhatky/nhatky_cubit.dart';
import 'package:agriplant/models/cubit/product/agrochemicals_cubit.dart';
import 'package:agriplant/models/cubit/product/agrochemicals_service.dart';
import 'package:agriplant/models/cubit/season/season_cubit.dart';
import 'package:agriplant/models/cubit/stage/stage_cubit.dart';
import 'package:agriplant/models/cubit/task/task_cubit.dart';
import 'package:agriplant/models/cubit/user/user_cubit.dart';
import 'package:agriplant/models/cubit/user/users_cubit.dart';
import 'package:agriplant/models/cubit/weather/weather_cubit.dart';
import 'package:agriplant/models/repository/farming_log_repository.dart';
import 'package:agriplant/models/repository/user_repository.dart';
import 'package:agriplant/models/repository/weather_repository.dart';
import 'package:agriplant/routes.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi', null); // Khởi tạo cho locale 'vi'
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final WeatherRepository weatherRepository = WeatherRepository();
    final UserRepository userRepository = UserRepository();
    final FarmingLogRepository farmingLogRepository = FarmingLogRepository();
    final AgrochemicalsService productService = AgrochemicalsService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FarmingLogCubit(repository: farmingLogRepository)
            ..fetchFarmingLogs(null),
        ),
        BlocProvider(
          create: (context) => SeasonCubit()..fetchSeasons(),
        ),
        BlocProvider(
          create: (context) => StageCubit()..fetchStages(),
        ),
        BlocProvider(
          create: (context) => TaskCubit()..fetchTasks(),
        ),
        BlocProvider(
          create: (context) =>
              UserCubit(userRepository: userRepository)..fetchUser(null),
        ),
        BlocProvider(
          create: (context) =>
              UsersCubit(userRepository: userRepository)..fetchUsers(),
        ),
        BlocProvider<WeatherCubit>(
          create: (context) =>
              WeatherCubit(weatherRepository: weatherRepository),
        ),
         BlocProvider(
          create: (context) => AgrochemicalsCubit(productService)..fetchAgrochemicalss(null),
        ),
        //  BlocProvider(
        //   create: (context) => Contact(id: '', xId: '', uId: '', name: '', email: '', phone: '', message: '', status: true, createAt: DateTime.now())..fetchContacts(),
        // ),
        // Bạn có thể thêm các Bloc/Cubit khác nếu cần ở đây
      ],
      child: MaterialApp.router(
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          textTheme: GoogleFonts.nunitoTextTheme(),
          iconTheme: const IconThemeData(
            size: 24.0, // Bạn có thể thay đổi kích thước theo ý muốn
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: routes,
        locale: const Locale('vi', 'VN'),
      ),
    );
  }
}

import 'package:attendme_app/injection.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attending/attending_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/image/image_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_bloc.dart';
import 'package:attendme_app/presentation/bloc/location/location_bloc.dart';
import 'package:attendme_app/presentation/bloc/login/login_bloc.dart';
import 'package:attendme_app/presentation/interface/screen/home_screen.dart';
import 'package:attendme_app/presentation/interface/screen/auth/login_screen.dart';
import 'package:attendme_app/presentation/interface/screen/settings_screen.dart';
import 'package:flutter/services.dart';

import 'injection.dart' as di;
import 'package:attendme_app/presentation/interface/screen/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Authentication Bloc
        BlocProvider<AuthBloc>(
          create: (_) => di.inject<AuthBloc>(),
        ),
        // Login User Bloc
        BlocProvider<LoginBloc>(
          create: (_) => di.inject<LoginBloc>(),
        ),
        // Attendance Bloc
        BlocProvider<AttendanceBloc>(
          create: (_) => di.inject<AttendanceBloc>(),
        ),
        // Current Date Bloc
        BlocProvider<CalendarBloc>(
          create: (_) => di.inject<CalendarBloc>(),
        ),
        // Attending Bloc
        BlocProvider<AttendingBloc>(
          create: (_) => di.inject<AttendingBloc>(),
        ),
        BlocProvider<ImageBloc>(
          create: (_) => di.inject<ImageBloc>(),
        ),
        BlocProvider<LocationBloc>(
          create: (_) => di.inject<LocationBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        routerConfig: GoRouter(
          initialLocation: AuthScreen.routePath,
          routes: [
            GoRoute(
              path: AuthScreen.routePath,
              builder: (context, state) => const AuthScreen(),
            ),
            GoRoute(
              path: LoginScreen.routePath,
              builder: (context, state) => const LoginScreen(),
            ),
            // Home Default Screen
            GoRoute(
              path: HomeScreen.routePath,
              builder: (context, state) => const HomeScreen(),
            ),
            // Settings Screen
            GoRoute(
              path: SettingsScreen.routePath,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:attendme_app/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attendance_event.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_event.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_bloc.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_event.dart';
import 'package:attendme_app/presentation/interface/screen/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  static String routePath = '/settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SettingsItem(
              title: 'Logout',
              onTap: () async {
                Future.microtask(
                    () => context.read<AuthBloc>().add(OnLogout()));
                Future.microtask(() =>
                    context.read<AttendanceBloc>().add(OnSetCleanState()));
                Future.microtask(() =>
                    context.read<CalendarBloc>().add(OnGetTodaysCalendar()));
                context.go(AuthScreen.routePath);
              })
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final Function onTap;
  const SettingsItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: Text(title),
        onTap: () => onTap(),
      ),
      const Divider()
    ]);
  }
}

import 'package:attendme_app/presentation/bloc/attendance/attended_user/attended_user_bloc.dart';
import 'package:attendme_app/presentation/bloc/attendance/attended_user/attended_user_event.dart';
import 'package:attendme_app/presentation/bloc/attendance/attended_user/attended_user_state.dart';
import 'package:attendme_app/presentation/bloc/calendar/calendar_bloc.dart';
import 'package:attendme_app/presentation/interface/widgets/listview_items/attended_user_items.dart';
import 'package:attendme_app/presentation/interface/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendedUserScreen extends StatefulWidget {
  static const routePath = '/attended_user_screen';
  const AttendedUserScreen({super.key});

  @override
  State<AttendedUserScreen> createState() => _AttendedUserScreenState();
}

class _AttendedUserScreenState extends State<AttendedUserScreen> {
  @override
  void initState() {
    // _fetchAttendedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attended'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<AttendedUserBloc, AttendedUserState>(
              builder: (context, state) {
            if (state is LoadingAUS) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ErrorAUS) {
              return Center(child: Text(state.message));
            } else {
              final userList = state as SuccessAUS;
              const AppProgressBar(value: 0.3);
              return Expanded(
                child: ListView.builder(
                    itemCount: userList.listOfUser.length,
                    itemBuilder: (context, index) => AttendedUserItems(
                          userData: userList.listOfUser[index],
                          onTap: () {},
                        )),
              );
            }
          })
        ],
      ),
    );
  }

  Future<void> _fetchAttendedUser() async {
    final dateState = context.read<CalendarBloc>().state.date;
    context.read<AttendedUserBloc>().add(OnFetchAttendedUser(dateState));
  }
}

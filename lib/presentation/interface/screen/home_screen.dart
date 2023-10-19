import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_event.dart';

import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  static String routePath = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state == SuccessAS()) {
            final data = state as SuccessAS;
            return Column(
              children: [
                // Top Appbar
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                '${data.credentials?.imageUrl}',
                                height: 47,
                                width: 47,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${data.credentials?.jobDesk}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                Text(
                                  '${data.credentials?.surName} ${data.credentials?.lastName}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.settings),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Content Divider
                CalendarTimeline(
                  initialDate: data.date!,
                  firstDate: DateTime(2000, 1, 15),
                  lastDate: DateTime(2028, 11, 20),
                  onDateSelected: (date) {},
                  leftMargin: 20,
                  monthColor: Colors.blueGrey,
                  dayColor: Colors.grey,
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: AppColors.secondaryColor,
                  selectableDayPredicate: (date) => date.day != 23,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(22)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        children: [CardAbsent()],
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class CardNotAttended extends StatelessWidget {
  const CardNotAttended({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 88,
      decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: const BorderRadius.all(
            Radius.circular(13),
          )),
      child: Container(
        margin: const EdgeInsets.all(14),
        child: const Row(
          children: [
            Icon(
              Icons.person_off,
              size: 56,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Youre not Attended',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Attend Me !',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ])
          ],
        ),
      ),
    );
  }
}

class CardAttended extends StatelessWidget {
  final String attendedTime;
  const CardAttended({super.key, required this.attendedTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 88,
      decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: const BorderRadius.all(
            Radius.circular(13),
          )),
      child: Container(
        margin: const EdgeInsets.all(14),
        child: Row(
          children: [
            const Icon(
              Icons.checklist_outlined,
              size: 56,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Youre Attended at',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    attendedTime,
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ])
          ],
        ),
      ),
    );
  }
}

class CardAbsent extends StatelessWidget {
  const CardAbsent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 88,
      decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: const BorderRadius.all(
            Radius.circular(13),
          )),
      child: Container(
        margin: const EdgeInsets.all(14),
        child: const Row(
          children: [
            Icon(
              Icons.person_off_rounded,
              size: 56,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Youre not Attended',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Absent',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ])
          ],
        ),
      ),
    );
  }
}

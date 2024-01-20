import 'package:attendme_app/common/colors.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:attendme_app/presentation/bloc/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingScreen extends StatefulWidget {
  static String routePath = '/profile_setting_screen';
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Profile Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 100,
              width: double.infinity,
              color: AppColors.primaryColor,
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is SuccessAS) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(38)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                color: Colors.black
                                    .withOpacity(0.3), // Set opacity here
                              )
                            ]),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(38),
                            child: Image.network(state.credentials!.imageUrl!)),
                      ),
                    )
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

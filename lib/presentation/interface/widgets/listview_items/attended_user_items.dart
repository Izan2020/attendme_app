import 'package:attendme_app/data/models/attended_user_response.dart';
import 'package:flutter/material.dart';

class AttendedUserItems extends StatelessWidget {
  final AttendedUser userData;
  final Function onTap;
  const AttendedUserItems({
    super.key,
    required this.userData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => onTap(),
          child: Container(
            margin: const EdgeInsets.all(11),
            height: 72,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.network(
                    userData.user.image_url,
                    height: 55,
                    width: 55,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(width: 15),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userData.user.surname} ${userData.user.last_name}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(userData.created_at),
                  ],
                )
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 0.3,
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String routePath = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        'https://i.seadn.io/gae/2HpFlXRKpJZl3uS3BaEiWbV1wr1T43uf32_iQbzVnZBLvu13Nl3NxjgPFy-d_gdKPUpCpk_H2E98EWrmRFusQ99p2s4zaEL1m3NN?auto=format&dpr=1&w=1000',
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Employee',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          'Hamas Azizan',
                          style: TextStyle(
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
          )
        ],
      )),
    );
  }
}

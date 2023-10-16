import 'package:attendme_app/presentation/interface/screen/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: GoRouter(
        initialLocation: AuthScreen.routePath,
        routes: [
          GoRoute(
            path: AuthScreen.routePath,
            builder: (context, state) => const AuthScreen(),
          )
        ],
      ),
    );
  }
}

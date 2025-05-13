import 'package:flutter/material.dart';
import 'package:projeto_bimestral/theme/app_theme.dart';
//import 'package:projeto_bimestral/screens/welcome_screen.dart';
import 'package:projeto_bimestral/routes.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.welcome,
      routes: Routes.getAll(),
    );
  }
}

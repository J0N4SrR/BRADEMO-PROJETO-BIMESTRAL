import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/list_screen.dart';
import 'screens/form_screen.dart';
import 'screens/grid_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/shell_screen.dart';

class Routes {
  // Definição de nomes das rotas
  static const welcome = '/';
  static const list    = '/list';
  static const form    = '/form';
  static const grid    = '/grid';
  static const detail  = '/detail';
  static const shell   = '/shell';

  // Mapeamento de nomes para Builders
  static Map<String, WidgetBuilder> getAll() {
    return {
      welcome: (ctx) => const WelcomeScreen(),
      list:    (ctx) => const ListScreen(),
      form:    (ctx) => const FormScreen(),
      grid:    (ctx) => const GridScreen(),
      detail:  (ctx) => const DetailScreen(),
      shell:   (ctx) => const ShellScreen(),
    };
  }
}

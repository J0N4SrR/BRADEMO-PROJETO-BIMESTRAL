import 'package:flutter/material.dart';
import 'package:projeto_bimestral/screens/welcome_screen.dart';
import 'package:projeto_bimestral/screens/list_screen.dart';
import 'package:projeto_bimestral/screens/form_screen.dart';
import 'package:projeto_bimestral/screens/grid_screen.dart';
import 'package:projeto_bimestral/screens/detail_screen.dart';
import 'package:projeto_bimestral/screens/shell_screen.dart';
import 'screens/mood_journal_screen.dart';
import 'screens/mood_booster_screen.dart';
import 'screens/positive_notes_screen.dart';
import 'screens/trigger_plan_screen.dart';


class Routes {
  static const welcome = '/';
  static const list    = '/list';  
  static const form    = '/form';
  static const grid    = '/grid';
  static const detail  = '/detail';
  static const shell   = '/shell';
  static const moodJournal = '/mood-journal';
  static const moodBooster = '/mood-booster';
  static const positiveNotes = '/positive-notes';
  static const triggerPlan = '/trigger-plan';

  static Map<String, WidgetBuilder> getAll() => {
        welcome: (ctx) => const WelcomeScreen(),
        list:    (ctx) => const ListScreen(),
        form:    (ctx) => const FormScreen(),
        grid:    (ctx) => const GridScreen(),
        detail:  (ctx) => const DetailScreen(),
        shell:   (ctx) => const ShellScreen(),
        moodJournal: (_) => const MoodJournalScreen(),
        moodBooster: (_) => const MoodBoosterScreen(),
        positiveNotes: (_) => PositiveNotesScreen(),
        triggerPlan: (_) => const TriggerPlanScreen(),
      };
}

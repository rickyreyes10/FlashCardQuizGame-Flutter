import 'package:flashcards_project_1/configs/themes.dart';
import 'package:flashcards_project_1/providerNotifiers/flashcards_review_animation_notifier.dart';
import 'package:flashcards_project_1/providerNotifiers/flashcards_test_animation_notifier.dart';
import 'package:flashcards_project_1/providerNotifiers/flashcards_database_notifier.dart';
import 'package:flashcards_project_1/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => FlashCardsNotifier()),
    ChangeNotifierProvider(create: (_) => FlashcardsDatabaseNotifier()),
    ChangeNotifierProvider(create: (_) => FlashCardsReviewNotifier()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcards App',
      theme: appTheme,
      home: const HomePage(),
    );
  }
}
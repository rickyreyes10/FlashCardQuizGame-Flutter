import 'package:flashcards_project_1/screens/create_deck_screen.dart';
import 'package:flashcards_project_1/screens/review_deck_screen.dart';
import 'package:flashcards_project_1/screens/test_deck_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const CreateDeckScreen()));
              },
              child: const Text('Create Deck of Flashcards'),
              // The button styling is automatically applied from themes.dart
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ReviewDeckScreen()));
              },
              child: const Text('Review Deck of Flashcards'),
              // The button styling is automatically applied from themes.dart
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TestDeckScreen()));
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const TestDeckScreen()));
              },
              child: const Text('Test Deck of Flashcards'),
              // The button styling is automatically applied from themes.dart
            ),
          ],
        ),
      ),
    );
  }
}

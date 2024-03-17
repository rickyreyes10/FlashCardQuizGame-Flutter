import 'package:flashcards_project_1/components/flashcard_test_page/card_1.dart';
import 'package:flashcards_project_1/components/flashcard_test_page/card_2.dart';
import 'package:flashcards_project_1/providerNotifiers/flashcards_test_animation_notifier.dart';
import 'package:flashcards_project_1/screens/home_screen.dart';
import 'package:flashcards_project_1/screens/test_deck_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashcardsPage extends StatefulWidget {
  final int topicId;
  const FlashcardsPage({super.key, required this.topicId});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final flashcardsNotifier =
          Provider.of<FlashCardsNotifier>(context, listen: false);
      flashcardsNotifier.runSlideCard1();
      flashcardsNotifier.initializeFlashcards(widget.topicId, context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashCardsNotifier>(
      builder: (_, notifier, __) => Scaffold(
        appBar: AppBar(
          title: const Text('testing'),
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              notifier.reset();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => TestDeckScreen()));
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                notifier.reset();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ],
        ),
        body: IgnorePointer(
          ignoring: notifier.ignoreTouches,
          child: Stack(
            children: [
              //Align(alignment: Alignment.bottomCenter, child: ProgressBar()),
              Card2(),
              Card1(),
            ],
          ),
        ),
      ),
    );
  }
}

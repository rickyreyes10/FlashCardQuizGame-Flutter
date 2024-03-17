import 'package:flashcards_project_1/components/flashcard_review_page/card_1_r.dart';
import 'package:flashcards_project_1/components/flashcard_review_page/card_2_r.dart';
import 'package:flashcards_project_1/providerNotifiers/flashcards_review_animation_notifier.dart';
import 'package:flashcards_project_1/screens/home_screen.dart';
import 'package:flashcards_project_1/screens/review_deck_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashcardsReviewPage extends StatefulWidget {
  final int topicId;
  const FlashcardsReviewPage({super.key, required this.topicId});

  @override
  State<FlashcardsReviewPage> createState() => _FlashcardsReviewPageState();
}

class _FlashcardsReviewPageState extends State<FlashcardsReviewPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final flashcardsNotifier =
          Provider.of<FlashCardsReviewNotifier>(context, listen: false);
      flashcardsNotifier.runSlideCard1();
      flashcardsNotifier.initializeFlashcards(widget.topicId, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashCardsReviewNotifier>(
      builder: (_, notifier, __) => Scaffold(
        appBar: AppBar(
          title: const Text('reviewing'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ReviewDeckScreen()));
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Center the trash bin icon horizontally
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red, size: 50),
                onPressed: () async {
                  // Confirmation dialog before deletion
                  final confirmDeletion = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Flashcard"),
                        content: const Text(
                            "Are you sure you want to delete this flashcard?"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: const Text("Delete"),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmDeletion == true) {
                    final notifier = Provider.of<FlashCardsReviewNotifier>(
                        context,
                        listen: false);
                    notifier.deleteCurrentFlashcard(context);
                  }
                },
              ),
            ),
            // Flashcard viewing area
            Expanded(
              child: IgnorePointer(
                ignoring: Provider.of<FlashCardsReviewNotifier>(context)
                    .ignoreTouches,
                child: Stack(
                  children: [
                    Card2r(),
                    Card1r(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

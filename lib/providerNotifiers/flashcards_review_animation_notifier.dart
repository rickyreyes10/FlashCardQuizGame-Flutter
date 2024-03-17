import 'package:flashcards_project_1/database/database_helper.dart';
import 'package:flashcards_project_1/enums/slide_direction.dart';
import 'package:flashcards_project_1/models/flashcard.dart';
import 'package:flashcards_project_1/screens/review_deck_screen.dart';
import 'package:flutter/material.dart';

class FlashCardsReviewNotifier extends ChangeNotifier {
  int? currentTopicId;
  List<Flashcard> selectedFlashcards =
      []; // All the flashcards for the deck (topic)
  Flashcard? currentFlashcard; // Currently displayed flashcard
  //Flashcard? flashcardDummy; // Used for animation, represents the next flashcard

  // Method to fetch and initialize flashcards for a given topicId
  Future<void> initializeFlashcards(int topicId, BuildContext context) async {
    currentTopicId = topicId; //store topicId
    List<Flashcard> flashcardsFromDb =
        await DatabaseHelper.instance.getFlashcardsForTopic(topicId);
    flashcardsFromDb.shuffle(); // Shuffle for random order
    selectedFlashcards = flashcardsFromDb;
    generateCurrentFlashcard(context);
  }

  // Method to select the next flashcard for review
  void generateCurrentFlashcard(BuildContext context) {
    if (selectedFlashcards.isNotEmpty) {
      currentFlashcard = selectedFlashcards.removeLast();
      notifyListeners();
    } else {
      // Show completion dialog
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text("Review Complete"),
            content: const Text("You have reviewed all flashcards."),
            actions: <Widget>[
              TextButton(
                child: const Text("Restart Review"),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss the dialog
                  initializeFlashcards(currentTopicId!,
                      context); // Restart with the same topicId
                },
              ),
              TextButton(
                child: const Text("Exit"),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss the dialog
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ReviewDeckScreen()),
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> deleteCurrentFlashcard(BuildContext context) async {
    if (currentFlashcard != null && currentFlashcard!.id != null) {
      await DatabaseHelper.instance.deleteFlashcard(currentFlashcard!.id!);
      selectedFlashcards.removeWhere((card) => card.id == currentFlashcard!.id);
      generateCurrentFlashcard(context); // Pass context here
      notifyListeners();
    }
  }

  //animation code
  bool ignoreTouches = true;

  setIgnoreTouch({required bool ignore}) {
    ignoreTouches = ignore;
    notifyListeners();
  }

  SlideDirection swipedDirection = SlideDirection.none;

  bool slideCard1 = false,
      flipCard1 = false,
      flipCard2 = false,
      swipeCard2 = false;

  bool resetSlideCard1 = false,
      resetFlipCard1 = false,
      resetFlipCard2 = false,
      resetSwipeCard2 = false;

  runSlideCard1() {
    resetSlideCard1 = false;
    slideCard1 = true;
    notifyListeners();
  }

  runFlipCard1() {
    resetFlipCard1 = false;
    flipCard1 = true;
    notifyListeners();
  }

  resetCard1() {
    resetSlideCard1 = true;
    resetFlipCard1 = true;
    slideCard1 = false;
    flipCard1 = false;
  }

  runFlipCard2() {
    resetFlipCard2 = false;
    flipCard2 = true;
    notifyListeners();
  }

  runSwipeCard2({required SlideDirection direction}) {
    swipedDirection = direction;
    resetSwipeCard2 = false;
    swipeCard2 = true;
    notifyListeners();
  }

  resetCard2() {
    resetFlipCard2 = true;
    resetSwipeCard2 = true;
    flipCard2 = false;
    swipeCard2 = false;
  }
}
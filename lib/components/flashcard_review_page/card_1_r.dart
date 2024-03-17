import 'package:flashcards_project_1/components/flashcard_test_page/results_box.dart';
import 'package:flashcards_project_1/configs/constants.dart';
import 'package:flashcards_project_1/database/database_helper.dart';
import 'package:flashcards_project_1/enums/slide_direction.dart';
import 'package:flashcards_project_1/models/flashcard.dart';
import 'package:flutter/material.dart';

class FlashCardsNotifier extends ChangeNotifier {
  int roundTally = 0,
      cardTally = 0,
      correctTally = 0,
      incorrectTally = 0,
      correctPercentage = 0;

  int? currentTopicId;

  List<Flashcard> incorrectCards = [];

  List<Flashcard> selectedFlashcards =
      []; // All the flashcards for the deck (topic)
  Flashcard? currentFlashcard; // Currently displayed flashcard
  //Flashcard? flashcardDummy; // Used for animation, represents the next flashcard

  bool isFirstRound = true,
      isRoundCompleted = false,
      isSessionCompleted = false;

  // Method to fetch and initialize flashcards for a given topicId
  Future<void> initializeFlashcards(int topicId,
      {required BuildContext context}) async {
    print(
        'initializeFlashcards called with topicId: $topicId, isFirstRound: $isFirstRound');
    currentTopicId = topicId;

    selectedFlashcards.clear();
    print('Selected flashcards cleared.');

    isRoundCompleted = false;

    if (isFirstRound) {
      List<Flashcard> flashcardsFromDb =
          await DatabaseHelper.instance.getFlashcardsForTopic(topicId);
      print(
          'Fetched ${flashcardsFromDb.length} flashcards from DB for topicId: $topicId');

      flashcardsFromDb.shuffle(); // Shuffle for random order
      selectedFlashcards = flashcardsFromDb;
      print('Flashcards shuffled and set as selected for round 1.');

      print(
          'Selected flashcards before generating current flashcard: ${selectedFlashcards.map((e) => e.question)}');

      generateCurrentFlashcard(context: context);
    } else {
      print(
          'Incorrect cards for retest: ${incorrectCards.map((e) => e.question)}');
      selectedFlashcards = List.from(incorrectCards);
      print('Selected flashcards set to incorrectCards for retest.');

      incorrectCards.clear();
      print('incorrectCards cleared after reassigning to selectedFlashcards.');
    }
    roundTally++;
    cardTally = selectedFlashcards.length;
    correctTally = 0;
    incorrectTally = 0;
  }

  void generateCurrentFlashcard({required BuildContext context}) {
    if (selectedFlashcards.isNotEmpty) {
      print(
          'Removing last flashcard from selectedFlashcards: ${selectedFlashcards.last.question}');

      print(
          'generateCurrentFlashcard called, currentFlashcard: ${currentFlashcard?.question}');

      currentFlashcard = selectedFlashcards.removeLast();
      print('Next flashcard selected: ${currentFlashcard?.question}');

      notifyListeners();
      print('Notifying listeners after updating current flashcard.');
    } else {
      if (incorrectCards.isEmpty) {
        isSessionCompleted = true;
        print(
            'All flashcards have been answered correctly. Session completed.');
      }

      isRoundCompleted = true;
      isFirstRound = false;
      print(
          'All flashcards reviewed for this round. isRoundCompleted: $isRoundCompleted, isFirstRound: $isFirstRound');

      calculateCorrectPercentage();

      // Trigger results box after a short delay
      Future.delayed(Duration(milliseconds: kSlideAwayDuration), () {
        showDialog(
            context: context,
            builder: (context) => Resultsbox(topicId: currentTopicId!));
      });
    }
  }

  void updateCardOutcome(
      {required Flashcard? flashcard, required bool isCorrect}) {
    if (!isCorrect) {
      incorrectCards.add(flashcard!);
      print('Added to incorrectCards: ${flashcard.question}');
      incorrectTally++;
    } else {
      correctTally++;
    }
    // Debugging: Print all current incorrect cards
    print('Current incorrect cards: ${incorrectCards.map((e) => e.question)}');
    notifyListeners();
  }

  calculateCorrectPercentage() {
    final percentage = correctTally / cardTally;
    correctPercentage = (percentage * 100).round();
  }

  reset() {
    // so this for when we exit the session and come back in for another the values have been reset
    isFirstRound = true;
    isRoundCompleted = false;
    isSessionCompleted = false;
    roundTally = 0;
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
    updateCardOutcome(
        flashcard: currentFlashcard,
        isCorrect: direction ==
            SlideDirection
                .leftAway); //since we are flipping card2 around and transforming it 180 degrees.. the cards left is our right
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

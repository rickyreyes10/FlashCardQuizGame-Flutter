import 'package:flashcards_project_1/database/database_helper.dart';
import 'package:flashcards_project_1/models/flashcard.dart';
import 'package:flutter/material.dart';

class FlashcardsDatabaseNotifier extends ChangeNotifier {
  Future<void> addFlashcard(
      String topicName, String question, String answer) async {
    final db = DatabaseHelper.instance;

    // Ensure the topic exists and get its ID
    int topicId = await db.ensureTopicExists(topicName);

    // Create a new flashcard with the obtained topicId
    Flashcard newFlashcard = Flashcard(
      topicId: topicId, // Use the topicId from the previous step
      question: question,
      answer: answer,
    );

    // Add the new flashcard to the database
    await db.createFlashcard(newFlashcard);

    // Notify listeners about the change, if needed
    notifyListeners();
  }

  Future<void> deleteTopicAndFlashcards(int topicId) async {
    await DatabaseHelper.instance.deleteTopicAndFlashcards(topicId);
    notifyListeners();
  }
}

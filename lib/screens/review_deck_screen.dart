import 'package:flashcards_project_1/configs/constants.dart';
import 'package:flashcards_project_1/database/database_helper.dart';
import 'package:flashcards_project_1/models/topic.dart';
import 'package:flashcards_project_1/providerNotifiers/flashcards_database_notifier.dart';
import 'package:flashcards_project_1/screens/flashcards_review_screen.dart';
import 'package:flashcards_project_1/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewDeckScreen extends StatefulWidget {
  const ReviewDeckScreen({super.key});

  @override
  State<ReviewDeckScreen> createState() => _ReviewDeckScreenState();
}

class _ReviewDeckScreenState extends State<ReviewDeckScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review Flashcards"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Consumer<FlashcardsDatabaseNotifier>(
        builder: (context, notifier, child) {
          // Using FutureBuilder inside Consumer to rebuild whenever notifyListeners is called
          return FutureBuilder<List<Topic>>(
            future: DatabaseHelper.instance.getTopics(), // Fetch topics
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.hasData) {
                final topics = snapshot.data!;
                return ListView.builder(
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    Topic topic = topics[index];
                    return Card(
                      color: kBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title:
                            Text(topic.name, style: TextStyle(color: kWhite)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _confirmDeleteTopic(context, topic.id!),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FlashcardsReviewPage(
                                      topicId: topic.id!)));
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text("No topics found."));
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDeleteTopic(BuildContext context, int topicId) async {
    final confirmDeletion = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Topic"),
          content: const Text(
              "This will delete the topic and all its flashcards. Are you sure?"),
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
      final notifier =
          Provider.of<FlashcardsDatabaseNotifier>(context, listen: false);
      await notifier.deleteTopicAndFlashcards(topicId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Topic and its flashcards deleted successfully')),
      );
    }
  }
}
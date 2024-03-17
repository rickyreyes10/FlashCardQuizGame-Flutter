import 'package:flashcards_project_1/configs/constants.dart';
import 'package:flashcards_project_1/database/database_helper.dart';
import 'package:flashcards_project_1/models/topic.dart';
import 'package:flashcards_project_1/providerNotifiers/flashcards_database_notifier.dart';
import 'package:flashcards_project_1/screens/flashcards_test_screen.dart';
import 'package:flashcards_project_1/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestDeckScreen extends StatefulWidget {
  const TestDeckScreen({super.key});

  @override
  State<TestDeckScreen> createState() => _TestDeckScreenState();
}

class _TestDeckScreenState extends State<TestDeckScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Flashcards"),
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
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FlashcardsPage(topicId: topic.id!)));
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
}
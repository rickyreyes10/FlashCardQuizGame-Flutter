import 'package:flashcards_project_1/providerNotifiers/flashcards_database_notifier.dart';
import 'package:flashcards_project_1/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateDeckScreen extends StatefulWidget {
  const CreateDeckScreen({super.key});

  @override
  State<CreateDeckScreen> createState() => _CreateDeckScreenState();
}

class _CreateDeckScreenState extends State<CreateDeckScreen> {
  final _formKey = GlobalKey<FormState>();
  String _topicName = '';
  String _question = '';
  String _answer = '';
  //TextEditingController for each field
  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  void _addFlashcard(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Use the notifier to add the flashcard
      final notifier =
          Provider.of<FlashcardsDatabaseNotifier>(context, listen: false);
      notifier.addFlashcard(_topicName, _question, _answer);

      // Provide user feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Flashcard added to "$_topicName"!')),
      );

      // Clear only the question and answer fields
      _questionController.clear();
      _answerController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Flashcard'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _topicNameController,
                decoration: const InputDecoration(labelText: 'Topic Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a topic name' : null,
                onSaved: (value) => _topicName = value!,
              ),
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a question' : null,
                onSaved: (value) => _question = value!,
              ),
              TextFormField(
                controller: _answerController,
                decoration: const InputDecoration(labelText: 'Answer'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an answer' : null,
                onSaved: (value) => _answer = value!,
              ),
              ElevatedButton(
                onPressed: () => _addFlashcard(context),
                child: const Text('Add Flashcard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
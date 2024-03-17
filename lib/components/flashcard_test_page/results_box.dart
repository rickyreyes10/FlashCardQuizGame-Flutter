import 'package:flashcards_project_1/providerNotifiers/flashcards_test_animation_notifier.dart';
import 'package:flashcards_project_1/screens/flashcards_test_screen.dart';
import 'package:flashcards_project_1/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Resultsbox extends StatelessWidget {
  final int topicId;
  const Resultsbox({Key? key, required this.topicId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashCardsNotifier>(
      builder: (_, notifier, __) => AlertDialog(
        title: Text(
          notifier.isSessionCompleted
              ? 'Session Completed!'
              : 'Round Completed!',
          textAlign: TextAlign.center,
        ),
        actions: [
          Table(
            columnWidths: {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
            },
            children: [
              buildTableRow(
                  title: 'Total Rounds', stat: notifier.roundTally.toString()),
              buildTableRow(
                  title: 'No. Cards', stat: notifier.cardTally.toString()),
              buildTableRow(
                  title: 'No. Correct', stat: notifier.correctTally.toString()),
              buildTableRow(
                  title: 'No. Incorrect',
                  stat: notifier.incorrectTally.toString()),
              buildTableRow(
                  title: 'Correct Percentage',
                  stat: '${notifier.correctPercentage.toString()}%'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                notifier.isSessionCompleted
                    ? SizedBox()
                    : ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FlashcardsPage(topicId: topicId)));
                        },
                        child: Text('Retest Incorrect cards')),
                ElevatedButton(
                    onPressed: () {
                      notifier.reset();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text('Home')),
              ],
            ),
          )
        ],
      ),
    );
  }

  TableRow buildTableRow({required String title, required String stat}) {
    return TableRow(
      children: [
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            stat,
            textAlign: TextAlign.right,
          ),
        ))
      ],
    );
  }
}
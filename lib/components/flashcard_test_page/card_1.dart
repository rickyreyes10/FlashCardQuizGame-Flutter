import 'package:flashcards_project_1/configs/constants.dart';
import 'package:flashcards_project_1/enums/slide_direction.dart';
import 'package:flashcards_project_1/flashcard_animations/flashcard_test_animations/half_flip_animation.dart';
import 'package:flashcards_project_1/flashcard_animations/flashcard_test_animations/slide_animation.dart';
import 'package:flashcards_project_1/providerNotifiers/flashcards_test_animation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Card1 extends StatelessWidget {
  const Card1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building Card1');
    final size = MediaQuery.of(context).size;
    return Consumer<FlashCardsNotifier>(
      builder: (_, notifier, __) => GestureDetector(
        onDoubleTap: () {
          notifier.runFlipCard1();
          notifier.setIgnoreTouch(ignore: true);
        },
        child: HalfFlipAnimation(
          animate: notifier.flipCard1,
          reset: notifier.resetFlipCard1,
          flipFromHalfWay: false,
          animationCompleted: () {
            notifier.resetCard1();
            notifier.runFlipCard2();
          },
          child: SlideAnimation(
            animationDuration: 1000,
            animationDelay: 200,
            animationCompleted: () {
              notifier.setIgnoreTouch(ignore: false);
            },
            reset: notifier.resetSlideCard1,
            animate: notifier.slideCard1 &&
                !notifier.isRoundCompleted, //both have to be true
            direction: SlideDirection.upIn,
            child: Center(
              child: Container(
                width: size.width * 0.90,
                height: size.height * 0.70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kCircularBorderRadius),
                  border: Border.all(
                    color: Colors.black,
                    width: kCardBorderWidth,
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(notifier.currentFlashcard?.question ?? 'Loading...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 50, color: kWhite)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
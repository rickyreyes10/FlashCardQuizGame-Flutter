import 'dart:math';

import 'package:flashcards_project_1/configs/constants.dart';
import 'package:flashcards_project_1/enums/slide_direction.dart';
import 'package:flashcards_project_1/flashcard_animations/flashcard_review_animations/half_flip_animation_review.dart';
import 'package:flashcards_project_1/flashcard_animations/flashcard_review_animations/slide_animation_review.dart';
import 'package:flashcards_project_1/providerNotifiers/flashcards_review_animation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Card2r extends StatelessWidget {
  //final Flashcard? currentFlashcard;
  const Card2r({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<FlashCardsReviewNotifier>(
      builder: (_, notifier, __) => GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < -100) {
            notifier.runSwipeCard2(direction: SlideDirection.rightAway);
            notifier.runSlideCard1();
            notifier.setIgnoreTouch(ignore: true);
            Future.delayed(Duration(milliseconds: kSlideAwayDuration), () {
              notifier.generateCurrentFlashcard(context);
            });
          }
        },
        child: HalfFlipAnimationR(
          animate: notifier.flipCard2,
          reset: notifier.resetFlipCard2,
          flipFromHalfWay: true,
          animationCompleted: () {
            notifier.setIgnoreTouch(ignore: false);
          },
          child: SlideAnimationR(
            animationCompleted: () {
              notifier.resetCard2();
            },
            reset: notifier.resetSwipeCard2,
            animate: notifier.swipeCard2,
            direction: notifier.swipedDirection,
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
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: Text(notifier.currentFlashcard?.answer ?? 'Loading...',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 50, color: kWhite)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

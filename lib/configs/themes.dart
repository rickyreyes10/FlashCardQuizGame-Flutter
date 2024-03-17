import 'package:flashcards_project_1/configs/constants.dart';
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: kBlue,
  scaffoldBackgroundColor: kWhite,
  fontFamily: 'Georgia',

  textTheme: const TextTheme(
    headline1:
        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: kBlue),
    bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: kBlue),
  ),

  appBarTheme: const AppBarTheme(
    color: kBlue,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(color: kWhite, fontSize: 25.0),
    iconTheme: IconThemeData(color: kWhite),
    toolbarHeight: kAppBarHeight,
  ),

  // Setting ElevatedButton theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all(kBlue), // Button background color
      foregroundColor: MaterialStateProperty.all(kWhite), // Text color
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCircularBorderRadius),
        ),
      ),
    ),
  ),

  dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCircularBorderRadius),
      ),
      backgroundColor: kWhite,
      titleTextStyle: TextStyle(
        fontFamily: 'Georgia',
        fontSize: 20,
        color: kBlue,
      )),
);

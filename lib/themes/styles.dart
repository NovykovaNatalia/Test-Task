import 'package:flutter/material.dart';
import 'package:leads_do_it_test/themes/app_colors.dart';

class Styles {
  static const TextStyle textHeader = TextStyle(
    decoration: TextDecoration.none,
    color: AppColors.textColor,
    fontFamily: "Raleway-VariableFont_wght",
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle textBody = TextStyle(
    decoration: TextDecoration.none,
    color: AppColors.textColor,
    fontFamily: "Raleway-VariableFont_wght",
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle textHistory = TextStyle(
    decoration: TextDecoration.none,
    color: AppColors.primary,
    fontFamily: "Raleway-VariableFont_wght",
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle textSplash = TextStyle(
    decoration: TextDecoration.none,
    color: AppColors.layer_1,
    fontFamily: "Raleway-VariableFont_wght",
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle hintText = TextStyle(
    decoration: TextDecoration.none,
    color: AppColors.hintColor,
    fontFamily: "Raleway-VariableFont_wght",
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}

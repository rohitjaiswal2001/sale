
import 'package:flutter/material.dart';

extension MediaQueryValues on BuildContext {
  double get mediaQueryHeight => MediaQuery.sizeOf(this).height;
  double get mediaQueryWidth => MediaQuery.sizeOf(this).width ;
}


extension EmptySpace on num {
  SizedBox get height => SizedBox(height:toDouble());
  SizedBox get width => SizedBox(width:toDouble());
}


extension StringExtension on String {
    String capitalizefirst() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}


extension StringExtension2 on String {
  String capitalizeFirstAll() {
    return split(' ').map((word) {
      if (word.isNotEmpty) {
        return "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
      }
      return word;
    }).join(' ');
  }
}

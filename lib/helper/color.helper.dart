import 'package:flutter/material.dart';

Color changeColor(String color) {
  switch (color) {
    case "success":
      return Colors.green;
      break;
    case "danger":
      return Colors.red;
      break;
    case "warning":
      return Colors.orange;
      break;
    default:
      return Colors.black38;
      break;
  }
}

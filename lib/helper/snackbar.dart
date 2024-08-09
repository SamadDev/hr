import 'package:flutter/material.dart';

void showInSnackBar(SnackBarType snackBarType, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(getSnackBarMessage(snackBarType)),
    ),
  );
}

enum SnackBarType { Saved, Updated, Deleted, Error, Valid }

String getSnackBarMessage(SnackBarType snackBarType) {
  switch (snackBarType) {
    case SnackBarType.Saved:
      return "Record has been saved successfully";
      break;
    case SnackBarType.Updated:
      return "Record has been Updated successfully";
      break;
    case SnackBarType.Deleted:
      return "Record has been Deleted successfully";
      break;
    case SnackBarType.Error:
      return "Something error please contact support";
      break;
    case SnackBarType.Valid:
      return "Please fill all the required fields";
      break;
  }
}

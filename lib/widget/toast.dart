import 'package:flutter/material.dart';
import 'package:keep_note/core/color_const.dart';

void showToast(BuildContext context, String message, bool isSuccess) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: isSuccess ? ColorConstants.primary : Colors.red,
      content: Text(message),
    ),
  );
}

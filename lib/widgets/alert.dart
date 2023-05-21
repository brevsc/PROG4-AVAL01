import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;

  const Alert(
      {super.key,
      required this.title,
      required this.description,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: <Widget>[
        TextButton(
          child: Text(buttonText),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

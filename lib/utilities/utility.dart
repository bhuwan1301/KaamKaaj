import 'package:flutter/material.dart';

class AppUtility {
  static const appbarcolor = Color.fromRGBO(180, 180, 180, 1);
  var taskbgcolor = const Color.fromARGB(33, 0, 174, 255);
  static const tasktextstyle = TextStyle(fontFamily: 'NunitoSans', color: Colors.black, fontWeight: FontWeight.bold);
  static const appbartext = Row(
    children: [
      Text(
        "Kaam",
        style: TextStyle(
          fontSize: 25,
          color: Color.fromARGB(255, 0, 0, 200),
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayWritePE',
        ),
      ),
      Text(
        " Kaaj",
        style: TextStyle(
          fontSize: 25,
          color: Color.fromARGB(255, 200, 0, 0),
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayWritePE',
        ),
      ),
    ],
  );
}

import 'package:flutter/material.dart';

UPickAppBar({bool showBack = true}) {
  return AppBar(
    automaticallyImplyLeading: showBack,
    centerTitle: true,
    elevation: 10,
    title: Text(
      'UPick',
      style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontFamily: 'NunitoSans',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic),
    ),
  );
}

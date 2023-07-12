import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration boxShadow =  BoxDecoration(
  color:Colors.white,border: Border.all(color: Colors.grey.shade50),
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(2),
      topRight: Radius.circular(2),
      bottomLeft: Radius.circular(2),
      bottomRight: Radius.circular(2)
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.2),
      spreadRadius: 1,
      blurRadius: 1,
      offset: Offset.zero, // changes position of shadow
    ),
  ],
);
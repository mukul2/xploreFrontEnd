import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration boxShadow =  BoxDecoration(
  color:Colors.white,border: Border.all(color: Colors.black54,width: 0.1),
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(4),
      topRight: Radius.circular(4),
      bottomLeft: Radius.circular(4),
      bottomRight: Radius.circular(4)
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.1),
      spreadRadius: 1,
      blurRadius: 1,
      offset: Offset.zero, // changes position of shadow
    ),
  ],
);
BoxDecoration boxShadow2 =  BoxDecoration(
  color:Colors.white,border: Border.all(color: Colors.black,width: 0.1),
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(0),
      topRight: Radius.circular(0),
      bottomLeft: Radius.circular(0),
      bottomRight: Radius.circular(0)
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.1),
      spreadRadius: 1,
      blurRadius: 1,
      offset: Offset.zero, // changes position of shadow
    ),
  ],
);
BoxDecoration boxShadow3 =  BoxDecoration(
  color:Colors.transparent,
  border: Border.all(color: Colors.black54,width: 0.5),


);
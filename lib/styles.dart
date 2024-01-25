import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle styleBold =  TextStyle(fontWeight: FontWeight.w900,letterSpacing: 1.5,fontFamily: "Inter");
TextStyle styleSemiBold =  TextStyle(fontWeight: FontWeight.w700,letterSpacing: 1.5,fontFamily: "Inter");
TextStyle styleNormal =  TextStyle(fontWeight: FontWeight.w500,letterSpacing: 1.5,fontFamily: "Inter");

BoxDecoration bdq = BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.white);
BoxDecoration boxShadow =  BoxDecoration(
  color:Colors.white,border: Border.all(color: Colors.black54,width: 0.3),
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
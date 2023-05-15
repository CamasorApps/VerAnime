import 'package:flutter/material.dart';

class Parse {
    static Color toColor(String color){
      return Color(int.parse(color.replaceFirst('#', '0x'))).withOpacity(1.0);
    }

    static int toHex(String color){
      return int.parse(color.replaceFirst('#', '0xFF'));
    }

    static bool toBool(int value){
      return (value > 0) ? true : false; 
    }
}
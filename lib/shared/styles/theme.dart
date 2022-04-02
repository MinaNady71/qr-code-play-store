import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


ThemeData darkTheme =  ThemeData(

  timePickerTheme:TimePickerThemeData(
    backgroundColor: Color(0xff323739) ,
    dayPeriodTextColor: Colors.white,
    dialTextColor:  Colors.white,
    hourMinuteTextColor:  Colors.white,
  ) ,
    colorScheme: ColorScheme.dark().copyWith(
     // primary: Color(0xff020c17),
      primary: Color(0xff037f65),
     secondary: Color(0xff062542),
      secondaryContainer: Color(0xff020c17),
    ),
    primaryColor: Color(0xff323739) ,
  backgroundColor:Color(0xff131C21) ,
    bottomAppBarColor: Color(0xff323739),
  scaffoldBackgroundColor: Color(0xff323739),
  appBarTheme: AppBarTheme(
    titleSpacing: 15.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xff323739),
      statusBarBrightness: Brightness.light,
    ),
    color: Color(0xff323739),
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 15.0,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
        color: Colors.white
    ),

  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(

      showSelectedLabels: true,
      showUnselectedLabels: true,
      unselectedIconTheme: IconThemeData(size: 22),
      selectedIconTheme: IconThemeData(size: 27),
      selectedLabelStyle: TextStyle(fontSize: 13),
      unselectedLabelStyle:TextStyle(fontSize: 11),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color(0xff04A583),
      elevation: 20.0,
      backgroundColor: Color(0xff323739),
      unselectedItemColor: Colors.white
  ),
  textTheme: TextTheme(
    subtitle1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        color: Color(0xff04A583)
    ),
    bodyText1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        color: Colors.white
    ),
    bodyText2: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        color: Colors.white
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light().copyWith(
     primary: Color(0xff04A583),
  ),
    primaryColor: Colors.white,
  backgroundColor: Colors.grey[300],
    bottomAppBarColor: Color(0xff04A583),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
      titleSpacing: 15.0,
      systemOverlayStyle:SystemUiOverlayStyle(
          statusBarColor: Color(0xff04A583),
          statusBarBrightness: Brightness.light
      ),
      color: Colors.white,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
          color:  Colors.white
      )
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    showSelectedLabels: true,
    showUnselectedLabels: true,
    backgroundColor: Color(0xff04A583),
    unselectedIconTheme: IconThemeData(size: 22),
    selectedIconTheme: IconThemeData(size: 27),
    selectedLabelStyle: TextStyle(fontSize: 13),
    unselectedLabelStyle:TextStyle(fontSize: 11),
    type: BottomNavigationBarType.fixed,
    unselectedItemColor:Colors.white ,
    selectedItemColor:Colors.black38,
    elevation: 20.0,
  ),
  textTheme: TextTheme(
    subtitle1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        color: Color(0xff2fffdd),
    ),
    bodyText1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        color: Colors.black
    ),
    bodyText2: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14.0,
        color: Colors.black54
    ),
  ),
);
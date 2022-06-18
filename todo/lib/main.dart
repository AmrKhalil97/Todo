import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/homelayout.dart';
import 'package:todo/shared/BlocObserver.dart';

void main(List<String> args) {
  BlocOverrides.runZoned(
    () {
      runApp(MyApp());
    },
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white
          ),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 25,


          ),
          elevation: 0
        ),
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedIconTheme: IconThemeData(
            color:Colors.black
              ,
            opacity: 100,



          ),
          unselectedIconTheme: IconThemeData(
              color:Colors.black
              ,
              opacity: 0.5,



          ),
            selectedLabelStyle: TextStyle(
            color: Colors.black,
              fontWeight: FontWeight.bold,



        )
        )
      ),
      debugShowCheckedModeBanner: false,
      home: home(),
    );
  }
}

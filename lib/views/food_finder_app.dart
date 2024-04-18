import 'package:flutter/material.dart';
import 'package:food_finder/models/venues_db.dart';
import 'package:food_finder/helpers/weather_checker.dart';
import 'package:provider/provider.dart';
import 'package:food_finder/providers/position_provider.dart';
import 'package:food_finder/providers/weather_provider.dart';
import 'dart:async';




class FoodFinderApp extends StatefulWidget {
  final VenuesDB venues;

  const FoodFinderApp({super.key, required this.venues});

  @override
  State<FoodFinderApp> createState() => _FoodFinderAppState();
}



class _FoodFinderAppState extends State<FoodFinderApp> {
  late final Timer _checkerTimer;
  late final WeatherChecker _weatherChecker;

  @override
  initState(){
    // TODO(you): Initialize the _checkerTimer and _weatherChecker here
    // ---> Your code from the Weather app may be helpful to refer to 

    // This way we don't have to wait a minute from after the app starts to first attempt a weather check.
    _weatherChecker.fetchAndUpdateCurrentSeattleWeather();


  }

  @override 
  dispose(){
    // TODO(you):  Cancel our timer when we are no longer needed so we don't leak
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        home: SafeArea(
            child: Scaffold(
              // This is how you can consume from two providers at once without 
              // needing to nest Consumers inside each other 
              body: Consumer2<PositionProvider, WeatherProvider>( 
                builder: (context, positionProvider, weatherProvider, child) {
                  // TODO(you): If position is known, call weatherChecker.updateLocation with our current position

                  // TODO(you): Remove this placeholder, and add your views here.
                  // Keep this as tidy and readable as you can by, relying on custom Widgets you define 
                  // to create the view tree. 
                  // VSCode makes this easy... check out the Extract Widget feature described here: 
                  //  https://medium.com/flutter-community/flutter-visual-studio-code-shortcuts-for-fast-and-efficient-development-7235bc6c3b7d
                  // Please place each custom Widget in their own file in the views/ directory.
                  return Placeholder();
                } 
              ),
            ),
          )
    );
  }
}

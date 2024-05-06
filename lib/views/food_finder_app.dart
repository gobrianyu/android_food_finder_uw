import 'package:flutter/material.dart';
import 'package:food_finder/models/venues_db.dart';
import 'package:food_finder/helpers/weather_checker.dart';
import 'package:food_finder/views/header.dart';
import 'package:food_finder/views/venue_list.dart';
import 'package:provider/provider.dart';
import 'package:food_finder/providers/position_provider.dart';
import 'package:food_finder/providers/weather_provider.dart';
import 'dart:async';



// This class represents a food finder app which, when given location permissions,
// will find and display a list of nearby restaurants and cafes.
class FoodFinderApp extends StatefulWidget {
  final VenuesDB venues;

  const FoodFinderApp({super.key, required this.venues});

  @override
  State<FoodFinderApp> createState() => _FoodFinderAppState();
}


// Our app's state!
class _FoodFinderAppState extends State<FoodFinderApp> {
  late final Timer _checkerTimer;
  late final WeatherChecker _weatherChecker;
  bool isLoaded = false; // Boolean for whether our app has loaded; used to build UI.

  // Initialises our app's state.
  // No parameters.
  @override
  initState(){
    super.initState();
    // Instance of our weather provider.
    final singleUseWeatherProvider = Provider.of<WeatherProvider>(context, listen: false);
    _weatherChecker = WeatherChecker(singleUseWeatherProvider); // Instance of our weather checker, initialising it with our weather provider.

    // This way we don't have to wait a minute from after
    // the app starts to first attempt a weather check.
    Future.delayed(const Duration(seconds: 4), () async {
      await _weatherChecker.fetchAndUpdateCurrentSeattleWeather(); // Waits for the update...
      isLoaded = singleUseWeatherProvider.isLoaded; // ... before marking the weather as loaded.
    });

    // Fetches and updates our weather approx every minute.
    // This results in the possibility of weather not loading in quickly upon app start.
    // Could be fixed with a different implementation, but this meets criteria.
    _checkerTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _weatherChecker.fetchAndUpdateCurrentSeattleWeather();
      isLoaded = singleUseWeatherProvider.isLoaded;
    });
  }

  // Cleaning up after ourselves: cancels and disposes our timer.
  @override 
  dispose(){
    _checkerTimer.cancel();
    super.dispose();
  }

  // Builds the app from provided context.
  // Parameter:
  // - BuildContext context: the context from which we are building the app UI.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Consumer2<PositionProvider, WeatherProvider>(
            builder: (context, positionProvider, weatherProvider, child) {
              
              // Updates weather checker's location if a valid position is provided.
              if (positionProvider.status) {
                _weatherChecker.updateLocation(positionProvider.latitude, positionProvider.longitude);
              }

              /// Building UI:
              // Case where app is unable to access location.
              if (positionProvider.loadFailure) {
                return loadVenuesFail(weatherProvider, positionProvider);
              } else if (!positionProvider.status) { // Case where (typically on startup) the app is still loading location info. 
                return loadingVenues(weatherProvider, positionProvider);
              } else { // Case where app successfully loads location.
                return loadVenuesSuccess(weatherProvider, positionProvider);
              }
            } 
          ),
        ),
      )
    );
  }

  // UI for when location is successfully loaded. Displays app bar with current location and
  // weather, alongside a scrollable list of nearby venues sorted in order by distance away.
  // Will push locations with patios to users when the weather is sunny.
  // Parameters:
  // - WeatherProvider weatherProvider: for weather condition info
  // - PositionProvider positionProvider: for latitude, longitude, and load status info
  ListView loadVenuesSuccess(WeatherProvider weatherProvider, PositionProvider positionProvider) {
    return ListView(
      children: [
        WeatherHeader(
            weatherProvider.condition,
            positionProvider.latitude,
            positionProvider.longitude,
            isLoaded,
            positionProvider.loadFailure), 
        VenueList(widget.venues.nearestTo(
            latitude: positionProvider.latitude,
            longitude: positionProvider.longitude,
            condition: weatherProvider.condition,
        ).toList(),
        positionProvider.latitude,
        positionProvider.longitude),
      ]
    );
  }

  // UI for when app fails to find user's location; will prompt user with on-screen text
  // to check their location permissions in settings.
  // Parameters:
  // - WeatherProvider weatherProvider: for weather condition info
  // - PositionProvider positionProvider: for load status info
  Column loadVenuesFail(WeatherProvider weatherProvider, PositionProvider positionProvider) {
    return Column(
      children: [
        // The app bar. Provided arguments should set it to a 'loading failed' message.
        WeatherHeader(weatherProvider.condition, 200, 200, isLoaded, positionProvider.loadFailure), // Maximum possible coordinates are 180 so this default is fine
        
        // Main body. Just some text to prompt the user.
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Semantics(
                  label: 'Text. Oh no! Something went wrong. Please check that location permissions are enabled in settings.',
                  child: const ExcludeSemantics(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text( // Our prompt text.
                        'Oh no!\nSomething went wrong :(\nPlease check that location\npermissions are enabled\nin settings.',
                        textAlign:TextAlign.center,
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.w400, 
                          color: Color.fromARGB(150, 0, 0, 0),
                        )
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
        const Spacer()
      ]
    );
  }

  // UI for while app is still loading the user's location (typically during startup).
  // Parameters:
  // - WeatherProvider weatherProvider: for weather condition info
  // - PositionProvider positionProvider: for load status info
  Column loadingVenues(WeatherProvider weatherProvider, PositionProvider positionProvider) {
    return Column(
      children: [
        // The app bar. Provided arguments should set it to a loading message.
        WeatherHeader(weatherProvider.condition, 200, 200, isLoaded, positionProvider.loadFailure),

        // Main body. Just some loading text.
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Semantics(
                  label: 'Text. Loading venues.',
                  child: const ExcludeSemantics(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Loading venues...',
                        textAlign:TextAlign.center,
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.w400, 
                          color: Color.fromARGB(150, 0, 0, 0),
                        )
                      ),
                    ),
                  ),
                ),
              ]
            )
          )
        ),
        const Spacer()
      ]
    );
  }
}

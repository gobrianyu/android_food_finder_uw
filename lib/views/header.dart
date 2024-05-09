import 'package:flutter/material.dart';
import 'package:food_finder/weather_conditions.dart';

// This class builds the faux 'app bar' for the food finder app.
// It displays location and weather information when loaded.
class WeatherHeader extends StatelessWidget {
  final WeatherCondition condition;
  final double latitude;
  final double longitude;
  final bool weatherLoadAttempted; // True if an attempt was made to update the weather. Used to determine whether to display 'loading' text.
  final bool locationLoadFailure; // True if there was an error in getting user's location. Used to determine whether to display error text.

  const WeatherHeader(this.condition, this.latitude, this.longitude, this.weatherLoadAttempted, this.locationLoadFailure, {super.key});


  // Builds the header (or app bar) from the provided context.
  // Parameter:
  // - BuildContext context: context from which to build the header
  @override
  Widget build(BuildContext context) {

    // The header itself.
    return Container(
      padding: const EdgeInsets.all(20),
      height: 100,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 229, 126),
          boxShadow: [ // Shadow beneath header.
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 4,
              blurRadius: 7,
              offset: const Offset(0, 2),
            )
          ]
      ),

      // Returns header with error message if locationLoadFailure is true;
      // returns header with correct information.
      child: locationLoadFailure 
            ? failedToLoadAppBar() // Header with error message.
            : loadedAppBar(latitude, longitude, condition), // Header with correct info.
    );
  }


  // Returns child for an errored header (i.e. unable to get user's location).
  // No parameters. 
  Widget failedToLoadAppBar() {
    return Semantics(
      label: 'App bar text. Location not found. Weather unavailable.',
      child: ExcludeSemantics(
        child: Row(
          children: [

            // 'Location not found' text in left corner.
            const Expanded(
              flex:8,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('Location'), Text('not found')],
                ),
              )
            ),

            // Question mark icon in place of the usual weather icon.
            Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.centerRight,
                child: const Icon(Icons.question_mark, color: Colors.black, size: 40),
              )
            ),

            // 'Weather unavailable' text in right corner.
            const Expanded(
              flex: 5,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Text(' Weather', style: TextStyle(fontSize: 15)),
                      Text(' unavailable', style: TextStyle(fontSize: 15)),
                  ]
                ),
              )
            )
          ]
        ),
      ),
    );
  }


  // Returns child for regular (non-errored) header. Either displays
  // weather and location info or a loading message depending on status.
  // Parameters:
  // - double latitude: user's current latitude
  // - double longitude: user's current longitude
  // - WeatherCondition condition: current weather condition
  Widget loadedAppBar(double latitude, double longitude, WeatherCondition condition) {
    IconData weatherIcon; // Icon to display; represents current weather.
    String conditionText = ''; // String to display weather in text form.

    // Switch statement for setting the weatherIcon and conditionText.
    switch (condition) {
      case WeatherCondition.gloomy:
        weatherIcon = Icons.cloud_outlined;
        conditionText = 'Gloomy';
      case WeatherCondition.sunny:
        weatherIcon = Icons.wb_sunny_outlined;
        conditionText = 'Sunny';
      case WeatherCondition.rainy:
        weatherIcon = Icons.water_drop_outlined;
        conditionText = 'Rainy';
      default: weatherIcon = Icons.question_mark; // Defaults to a question mark if whether is unknown.
    }

    // The app bar itself.
    return Row(
      children: [

        // Location text in left corner.
        Expanded(
          flex: 8,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: locationText(latitude, longitude),
          )
        ),

        // Weather icon.
        Expanded(
          flex: 5,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Icon(weatherIcon, color: Colors.black, size: 40),
          )
        ),

        // Weather text in right corner.
        Expanded(
          flex: 4,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: weatherText(conditionText),
          )
        )
      ],
    );
  }


  // Returns child for header representing the 
  // weather condition in text form.
  // Parameter:
  // - String conditionText: text form of weather condition
  Widget weatherText(String conditionText) {

    // Case if weather has not yet loaded (but has not necessarily errored).
    if (!weatherLoadAttempted) {
      return Semantics(
        label: 'Loading weather.',
        child: const ExcludeSemantics(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Text('  Loading', style: TextStyle(fontSize: 15)),
                Text('  Weather...', style: TextStyle(fontSize: 15)),
            ]
          ),
        ),
      );  
    }

    // Case if weather has loaded.
    return Semantics(
      label: 'The current weather is $conditionText.', 
      child: ExcludeSemantics(
        child: Text(
          '   $conditionText',
          style: const TextStyle(fontSize: 18), 
          overflow: TextOverflow.ellipsis
        )
      )
    );
  }


  // Returns child for header representing user's location
  // in text form.
  // Parameters:
  // - double latitude: user's latitude
  // - double longitude: user's longitude
  Widget locationText(double latitude, double longitude) {
    final String roundedLatitude = latitude.toStringAsFixed(2);
    final String roundedLongitude = longitude.toStringAsFixed(2);
  
    // Case where location has not yet loaded.
    if (latitude > 180) { // Coordinates are only valid between -180 and 180. Values greater than 180 (200 specifically) is used to represent not-yet-loaded coords.
      return Semantics(
        label: 'App bar text. Loading location.',
        child: const ExcludeSemantics(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Loading'), Text('Location...')],
          ),
        ),
      );
    }
    
    // Case where location has successfully loaded.
    return Semantics(
      // Semantics label correctly reads out current location as latitude (north/south), longitude (east, west).
      label: 'App bar text. Your current location is'
             ' ${latitude.abs().toStringAsFixed(2)} ${latitude > 0 ? 'north' : 'south'},'
             ' ${longitude.abs().toStringAsFixed(2)} ${longitude > 0 ? 'east' : 'west'}.',
      child: ExcludeSemantics(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Current Location:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), 
                  Text('$roundedLatitude, $roundedLongitude', style: const TextStyle(fontSize: 15))
          ],
        ),
      ),
    );
  }
}

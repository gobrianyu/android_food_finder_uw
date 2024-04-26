import 'dart:convert';

import 'package:food_finder/models/venue.dart';
import 'package:food_finder/weather_conditions.dart';


class VenuesDB{
  final List<Venue> _venues;

  List<Venue> get all{
    return List<Venue>.from(_venues, growable: false);
  }

  // Returns up to max number of venues in sorted order from 
  // closest to given coordinates to furthest
  nearestTo({int max = 999, required double latitude, required double longitude, required WeatherCondition condition}) {
    List<Venue> sortedVenues = _venues;
    if (condition == WeatherCondition.sunny) {
      sortedVenues.sort( // Promote locations with patios when the weather is sunny
        (a, b) {
          double aDist = a.distanceFrom(latitude: latitude, longitude: longitude);
          double bDist = b.distanceFrom(latitude: latitude, longitude: longitude);
          // Arbitrarily divide distance by 5 if location has a patio
          if (a.hasPatio) {
            aDist /= 5;
          }
          if (b.hasPatio) {
            bDist /= 5;
          }
          return aDist.compareTo(bDist); // Compare updated distances
        }
      );  
    } else {
      sortedVenues.sort(
        (a, b) => a.distanceFrom(latitude: latitude, longitude: longitude).compareTo(
                  b.distanceFrom(latitude: latitude, longitude: longitude)));
    }
    
    return sortedVenues.take(max);
  }


  VenuesDB.initializeFromJson(String jsonString) : _venues = _decodeVenueListJson(jsonString);

  static List<Venue> _decodeVenueListJson(String jsonString){
    final listMap = jsonDecode(jsonString);
    final theList = (listMap as List).map( (element) {
      return Venue.fromJson(element);
    }).toList();
    return theList;
  }

}
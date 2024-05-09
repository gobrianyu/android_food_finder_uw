import 'package:flutter/material.dart';
import 'package:food_finder/models/venue.dart';
import 'package:url_launcher/url_launcher.dart';

// Class represents a scrollable venue list UI.
// Venues are represented by cards, including
// the venue name, distance, tags, and image.
class VenueList extends StatelessWidget {
  final List<Venue> venues; // List of venues to display.
  final double latitude;
  final double longitude;

  const VenueList(this.venues, this.latitude, this.longitude, {super.key}); // Constructor


  // Builds the UI from provided context.
  // Parameters:
  // - BuildContext context: context to build UI from.
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 135,
      child: CustomScrollView( // Allows us to scroll through our venues. A ListView wold work as well, but the original build was a grid.
        shrinkWrap: true,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid.count(
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              crossAxisCount: 1, // Change this number to change to mock GridView (don't).
              childAspectRatio: 2.5,
              children: venues.map((venue) => createVenueCard(venue)).toList() // Calls createVenueCard on each venue in our list.
            ),
          ),
        ],
      ),
    );
  }


  Widget createVenueCard(Venue venue) {
    return Semantics(
      label: generateLabel(venue),
      child: ExcludeSemantics(
        child: GestureDetector( // Allows venue cards to be interacted with.
          onTap: () async { // Opens link to venue's website on tap.
            final Uri url = Uri.parse(venue.url);
            if (!await launchUrl(url)) {
              throw Exception('Could not launch $url'); // Throws exception if failed to launch.
            }
          },

          // Main venue card container.
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
            ),
            child: Row(
              children: [
                
                // Left yellow half of venue card.
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            topLeft: Radius.circular(8)),
                        color: Color.fromARGB(255, 244, 240, 195)),
                    padding: const EdgeInsets.all(10),
                    child: Builder(builder: (context) {
                      final double dist = venue.distanceInMeters(latitude: latitude, longitude: longitude);
                      final String cuisineIcon = getCuisineIcon(venue.cuisine); // Emoji representation of cuisine.
                      String distText; // Display string for user's distance away from venue.
                  
                      // Set displayed distance text in km if more than 1000m
                      if (dist > 1000) {
                        distText = '${(dist / 1000).toStringAsFixed(1)}km away';
                      } else {
                        distText = '${dist.toStringAsFixed(0)}m away';
                      }
                  
                      // Displayed text info on venue card.
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(builder: (context) {
                            if (venue.hasPatio) { // If venue has patio, add an extra patio tag...
                              return Row(
                                children: [
                                  makeTag(cuisineIcon),
                                  const SizedBox(width: 3),
                                  Container(
                                      width: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                                      padding: const EdgeInsets.all(3),
                                      child: const Icon(Icons.outdoor_grill)),
                              ],);
                            }
                            return makeTag(cuisineIcon); // ... otherwise just create a cuisineIcon tag.
                          }),
                          const Padding(padding: EdgeInsets.all(3)),

                          // The actual text:
                          Text(venue.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
                          Text(distText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                        ]
                      );
                    }),
                  ),
                ),

                // Right side image.
                AspectRatio(aspectRatio: 1, child: 
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      topRight: Radius.circular(8)), 
                    child: Image(
                      image: AssetImage(venue.image),
                      fit: BoxFit.cover
                    )
                  )
                )
              ]
            ),
          )
        ),
      ),
    );
  }

  // Returns an emoji as a String to represent the given cuisine.
  // Parameter:
  // - String cuisine: String representation of the venue's cuisine
  // Note:
  //   Using emojis to represent cuisines; 'arbitrarily' chosen.
  //   Ideally, icons would be custom made to suit each cuisine
  //   rather than choosing from a limited selection of emojis.
  String getCuisineIcon(String cuisine) {
    switch (cuisine.toLowerCase()) {
      case 'japanese': return '⛩️';
      case 'bakery': return '🍞';
      case 'cafe': return '☕';
      case 'thai' || 'chinese' || 'asian' || 'vietnamese': return '🥢';
      case 'pizza': return '🍕';
      case 'italian': return '🍝';
      case 'greek': return '🏛️';
      case 'mediterranean': return '🧆';
      case 'burger' || 'fast food': return '🍔';
      case 'mexican': return '🌮';
      case 'hawaiian': return '🌴';
      case 'bar': return '🍺';
      case 'bbq': return '🥩';
      case 'breakfast': return '🥞';
      case 'french': return '🥐';
      default: return '❓';
    }
  }

  // Makes a 'venue genre/cuisine tag' child for a venue card from a provided icon String.
  // Parameter:
  // - String icon: the icon (as a string) representing the venue's tag 
  Container makeTag(String icon) {
    return Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
        padding: const EdgeInsets.all(3),
        child: FittedBox(fit: BoxFit.scaleDown, child: Text(icon)),
    );
  }


  // Generates and returns a String representation of a semantics label for screen reader accessibility.
  // Included information includes venue name, distance away, cuisine type, if it has a patio, and actions.
  // Parameter:
  // - Venue venue: the venue to generate a semantics label for
  String generateLabel(Venue venue) {
    final double dist = venue.distanceInMeters(latitude: latitude, longitude: longitude);
    final String distLabel = dist > 1000 
          ? '${(dist / 1000).toStringAsFixed(1)} kilometres away.'
          : '${dist.toStringAsFixed(0)} metres away';
    final String cuisineLabel = 'Venue type: ${venue.cuisine}.';

    // Building the label text.
    String labelText = 'Venue card. ${venue.name}. $distLabel. $cuisineLabel';
    if (venue.hasPatio) {
      labelText = '$labelText This venue has an outdoor patio.';
    }
    labelText = '$labelText Double click to open link in browser.';
    return labelText;
  }
}
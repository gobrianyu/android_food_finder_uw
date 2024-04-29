import 'package:flutter/material.dart';
import 'package:food_finder/models/venue.dart';
import 'package:url_launcher/url_launcher.dart';

class VenueList extends StatelessWidget {
  final List<Venue> venues;
  final double latitude;
  final double longitude;
  const VenueList(this.venues, this.latitude, this.longitude, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 135,
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid.count(
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              crossAxisCount: 1,
              childAspectRatio: 2.5,
              children: venues.map((venue) => GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(venue.url);
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
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
                            String cuisineIcon;
                            String distText;
                        
                            // Set displayed distance text in km if more than 1000m
                            if (dist > 1000) {
                              distText = '${(dist / 1000).toStringAsFixed(1)}km away';
                            } else {
                              distText = '${dist.toStringAsFixed(0)}m away';
                            }
                        
                            // Using emojis to represent cuisines; 'arbitrarily' chosen.
                            // Ideally icons would be custom made to suit each cuisine
                            switch (venue.cuisine.toLowerCase()) {
                              case 'japanese':
                                cuisineIcon = '⛩️';
                              case 'bakery':
                                cuisineIcon = '🍞';
                              case 'cafe':
                                cuisineIcon = '☕';
                              case 'thai' || 'chinese' || 'asian' || 'vietnamese':
                                cuisineIcon = '🥢';
                              case 'pizza':
                                cuisineIcon = '🍕';
                              case 'italian':
                                cuisineIcon = '🍝';
                              case 'greek':
                                cuisineIcon = '🏛️';
                              case 'mediterranean':
                                cuisineIcon = '🧆';
                              case 'burger' || 'fast food':
                                cuisineIcon = '🍔';
                              case 'mexican':
                                cuisineIcon = '🌮';
                              case 'hawaiian':
                                cuisineIcon = '🌴';
                              case 'bar':
                                cuisineIcon = '🍺';
                              case 'bbq':
                                cuisineIcon = '🥩';
                              case 'breakfast':
                                cuisineIcon = '🥞';
                              case 'french':
                                cuisineIcon = '🥐';
                              default:
                                cuisineIcon ='❓';
                            }
                        
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Builder(builder: (context) {
                                  if (venue.hasPatio) {
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
                                      ],
                                    );
                                  }
                                  return makeTag(cuisineIcon);
                                }),
                                const Padding(padding: EdgeInsets.all(3)),
                                Text(venue.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                Text(distText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
                              ]
                            );
                          }),
                        ),
                      ),
                      AspectRatio(aspectRatio: 1, child: 
                          ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8),
                                  topRight: Radius.circular(8)), 
                              child: Image(
                                  image: AssetImage(venue.image),
                                  fit: BoxFit.cover)))
                    ]
                  ),
                )
              )).toList()
            ),
          ),
        ],
      ),
    );
  }

  Container makeTag(String icon) {
    return Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
        padding: const EdgeInsets.all(3),
        child: Text(icon),
    );
  }
}
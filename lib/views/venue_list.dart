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
    
    return Container(
      height:MediaQuery.of(context).size.height,
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(17),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              children: venues.map((venue) => GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse(venue.url);
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 200, 221, 230)),
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [Text(venue.name), Text('${venue.distanceInMeters(latitude: latitude, longitude: longitude).toStringAsFixed(0)}m away')], mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start,),
                )
              )).toList()
            ),
          ),
        ],
      ),
    );
  }
}
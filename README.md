# Food Finder

## Student Information
Name: Brian Yu

CSE netid: brian127

email: brian127@uw.edu


## Design Vision

**Functionally:** I had planned to make a relatively barebones, one-tab scrollable interface that would present to the user a list of venues nearby sorted in order from nearest to furthest. Basic information such as cuisine genre and whether or not the venue had a patio would be provided in the form of 'tags' (little icons). If the user found interest in a location, tapping on the venue card would open an external browser directly to that venue's website (if applicable). This app serves more as a portal to browse locations before redirecting you elsewhere to refine your plans. Other information such as weather and location is also provided in the app bar or header.

**Aesthetically:** The original plan was to theme the app based on the weather (i.e. moody grey background in gloomy weather, bright yellow background in sunny weather). I ended up opting for a fixed app theme to (1) give myself less work and (2) so that the app didn't center around weather too much. It's a food app after all; who wants to plan their lunch in a dull grey app? I initially also wanted to layout the venues in a 2-wide grid (remnants of this attempt can be found in the code...) but ended up listing them one by one. There simply wasn't enough room to squeeze two venues side-by-side with the way I wanted to display each venue. As a bonus, I ended up downloading and adding images for each venue (and editing each entry in `venues.json` to have an image property). All venue's images are found on their respective websites, listed in `venues.json`.

**Nudging:** I altered my venue sorting algorithm to check the weather prior to sorting. If the weather wasn't sunny, it would sort by distance as usual. If the weather was sunny, however, it would prioritise sorting locations with patios by reducing their internal distance value before sorting. (This does not affect the actual distance displayed to the user).

A brainstorm sketch can be found under `assets/` folder titled `food_finder_sketch.jpg`.


## Resources Used

Comprehensive list of online resources and documentation used: 
- https://dart.dev/guides/libraries/futures-error-handling
- https://api.flutter.dev/flutter/dart-async/Future/then.html
- https://stackoverflow.com/questions/73352447/why-visual-studio-code-does-not-recognize-my-phone
- https://stackoverflow.com/questions/49713189/how-to-use-conditional-statement-within-child-attribute-of-a-flutter-widget-cen
- https://stackoverflow.com/questions/54783316/flutter-geolocator-package-not-retrieving-location
- https://developer.android.com/guide/topics/manifest/uses-permission-element
- https://pub.dev/packages/geolocator
- https://stackoverflow.com/questions/71110157/flutter-geolocator-returning-0-0
- https://api.flutter.dev/flutter/widgets/GridView-class.html
- https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html
- https://api.flutter.dev/flutter/painting/TextStyle-class.html
- https://stackoverflow.com/questions/57777737/flutter-give-container-rounded-border
- https://www.dhiwise.com/post/unravel-the-dart-delay-function-in-flutter
- https://stackoverflow.com/questions/70098876/creating-a-dynamic-list-of-animated-containers-that-can-have-different-propertie
- https://stackoverflow.com/questions/43149055/how-do-i-open-a-web-browser-url-from-my-flutter-code
- https://pub.dev/packages/url_launcher
- https://docs.flutter.dev/packages-and-plugins/using-packages
- https://stackoverflow.com/questions/62265548/flutter-how-to-access-property-from-its-state-class
- https://api.flutter.dev/flutter/widgets/GestureDetector-class.html
- https://stackoverflow.com/questions/62067082/unhandled-exception-cannot-hit-test-a-render-box-with-no-size
- https://stackoverflow.com/questions/64416480/android-scroll-view-overlaps-other-views-below-it
- https://stackoverflow.com/questions/57777737/flutter-give-container-rounded-border
- https://api.flutter.dev/flutter/widgets/AspectRatio-class.html
- https://docs.flutter.dev/cookbook/design/fonts
- https://stackoverflow.com/questions/56321151/how-to-put-icon-on-string-in-flutter
- https://stackoverflow.com/questions/53141752/set-the-space-between-elements-in-row-flutter
- https://stackoverflow.com/questions/57130239/changing-aspect-ratio-of-image-in-flutter
- https://stackoverflow.com/questions/57304512/how-to-make-one-side-circular-border-of-widget-with-flutter
- https://stackoverflow.com/questions/51513429/how-to-do-rounded-corners-image-in-flutter
- https://stackoverflow.com/questions/58369317/flutter-customscrollview-did-not-scroll-full-length
- https://stackoverflow.com/questions/56981817/customscrollview-slivers-with-contents-in-sliverfillremaining-not-scrolling
- https://api.flutter.dev/flutter/widgets/Image-class.html
- https://api.flutter.dev/flutter/painting/BoxFit.html
- https://stackoverflow.com/questions/52227846/how-can-i-add-shadow-to-the-widget-in-flutter
- https://api.flutter.dev/flutter/material/SliverAppBar-class.html
- https://stackoverflow.com/questions/74378112/how-use-changenotifier-and-consumer-in-custom-flutter-app-bar
- https://stackoverflow.com/questions/56549093/how-to-change-the-box-shadow-height-width-and-opacity-in-flutter
- https://www.dhiwise.com/post/creative-ways-to-enhance-ui-with-flutter-box-shadow
- https://www.geeksforgeeks.org/flutter-boxshadow-widget/
- https://stackoverflow.com/questions/57203505/flutter-stretch-columns-to-full-screen-height
- https://stackoverflow.com/questions/50554110/how-do-i-center-text-vertically-and-horizontally-in-flutter
- https://stackoverflow.com/questions/66516125/prevent-changing-text-size-based-device-screen-size-flutter
- https://stackoverflow.com/questions/68284367/row-mainaxisalignment-not-working-with-fittedbox
- https://api.flutter.dev/flutter/dart-core/num/abs.html

Thank you to Jacklyn Cui for auditing the app.


## Reflection Prompts

### New Learnings

A few new tools I learned and used during this project:
- Editing xml files to add android permissions in order to get the geolocator to work.
- Gained experience working with futures.
- Learned how to launch urls from an app.
- First time using scroll views (incorrectly haha).

I can see tools such as futures being extremely useful in future projects.

## Challenges

- Time management, hahaha...
- There was far too much I wanted to add to my app. Some extra components or features (e.g. adding photos) took so much extra time that resulted in me missing the initial submission cycle. Learning to hold my creative side back in future projects will be important.
- I do think this project was perhaps too open ended. I ended up planning out far more than I realized I could pull off within a week (taking into account all the work I also had to do elsewhere).


### Mistakes

Ugh where do I start? The number of times this darn app crashed on me was so frustrating. Learning to read the spec carefully is also a mistake I have to learn from. I ended up digging through forums online trying to figure out why my geolocator wasn't working just because I missed a line in the spec. I made lots of mistakes with general usage of different widgets as well (such as with scroll views), and especially when I was working with futures.


### Optional Challenges

I did end up adding url launching into my app. I hadn't realised it was an optional extension and had just added it on a whim. Funny to see I'm on a similar wavelength as the project designer!
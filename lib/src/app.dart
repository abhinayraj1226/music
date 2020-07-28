import 'package:flutter/material.dart';
import 'package:music/src/ui/music_list.dart';
import 'package:music/src/ui/track_details.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: MusicistDisplay()
          // TrackDetailsDisplay(trackId: "200362255", isSaved: false),
          ),
    );
  }
}

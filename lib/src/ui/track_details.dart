import 'package:flutter/material.dart';
import 'package:music/src/bloc/lyrics.dart';
import 'package:music/src/bloc/track_details_bloc.dart';
import 'package:music/src/models/lyrics.dart';
import 'package:music/src/models/track_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackDetailsDisplay extends StatefulWidget {
  final String trackId;
  bool isSaved;
  TrackDetailsDisplay({Key key, @required this.trackId, @required this.isSaved})
      : super(key: key);

  TrackDetailsDisplayState createState() => TrackDetailsDisplayState();
}

class TrackDetailsDisplayState extends State<TrackDetailsDisplay> {
  // bool isBookMarked = false;

  // void addToBookMarked(String trackId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> trackList = prefs.getStringList("trackList");
  //   if (trackList != null) {
  //     if (!(trackList.contains(trackId))) {
  //       trackList.add(trackId);
  //       print("somethinf");
  //       prefs.setStringList("trackList", trackList);
  //       setState(() {
  //         isBookMarked = true;
  //       });
  //     }
  //   } else {
  //     List<String> trackList = [];
  //     trackList.add(trackId);
  //     print("somethinf");
  //     prefs.setStringList("trackList", trackList);
  //     setState(() {
  //       widget.isSaved = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    blocTrack.fetchTrackDetails(widget.trackId);
    blocLyrics.fetchLyrics(widget.trackId);
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('Track Details'),
            actions: <Widget>[
              widget.isSaved
                  ? Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                          onTap: () {
                            // addToBookMarked(widget.trackId);
                          },
                          child: Icon(Icons.bookmark)))
                  : Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                          onTap: () {
                            // addToBookMarked(widget.trackId);
                          },
                          child: Icon(Icons.bookmark_border)))
            ]),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: blocTrack.trackDtl,
            builder: (context, AsyncSnapshot<TrackDetails> snapshot) {
              if (snapshot.hasData) {
                return buildList(snapshot);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Container(
                  alignment: Alignment.center,
                  child: Center(child: CircularProgressIndicator()));
            },
          ),
        ));
  }

  TextStyle titleStyle() {
    return TextStyle(
        fontSize: 25.0, color: Colors.white54, fontWeight: FontWeight.bold);
  }

  TextStyle bodyStyle() {
    return TextStyle(fontSize: 25.0, color: Colors.white);
  }

  Widget buildList(AsyncSnapshot<TrackDetails> snapshot) {
    bool explicit = false;
    if (snapshot.data.message.body.track.explicit == 1) {
      explicit = true;
    }
    return Container(
        margin: EdgeInsets.all(30),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Name",
                        style: titleStyle(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        snapshot.data.message.body.track.trackName,
                        style: bodyStyle(),
                      ),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Artist",
                        style: titleStyle(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        snapshot.data.message.body.track.artistName,
                        style: bodyStyle(),
                      ),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Album Name",
                        style: titleStyle(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        snapshot.data.message.body.track.albumName,
                        style: bodyStyle(),
                      ),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Explicit",
                        style: titleStyle(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        explicit ? "True" : "False",
                        style: bodyStyle(),
                      ),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Rating",
                        style: titleStyle(),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        snapshot.data.message.body.track.trackRating.toString(),
                        style: bodyStyle(),
                      ),
                    )
                  ],
                )),
            buildLyrics(),
          ],
        ));
  }

  Widget buildLyrics() {
    return StreamBuilder(
      stream: blocLyrics.lyrics,
      builder: (context, AsyncSnapshot<Lyrics> snapshot) {
        if (snapshot.hasData) {
          return lyricsDetail(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Container(
            alignment: Alignment.center,
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget lyricsDetail(AsyncSnapshot<Lyrics> snapshot) {
    return Container(
        child: Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Lyrics",
            style: titleStyle(),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            snapshot.data.message.body.lyrics.lyricsBody,
            style: bodyStyle(),
          ),
        )
      ],
    ));
  }
}

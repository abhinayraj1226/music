import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:music/src/bloc/lyrics.dart';
import 'package:music/src/bloc/track_details_bloc.dart';
import 'package:music/src/models/lyrics.dart';
import 'package:music/src/models/track_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackDetailsDisplay extends StatefulWidget {
  final String trackId, trackName;
  bool isSaved;
  TrackDetailsDisplay(
      {Key key,
      @required this.trackId,
      @required this.trackName,
      @required this.isSaved})
      : super(key: key);

  TrackDetailsDisplayState createState() => TrackDetailsDisplayState();
}

class TrackDetailsDisplayState extends State<TrackDetailsDisplay> {
  bool isBookMarked = false;

  void addToBookMarked() async {
    print("getting cns " + widget.trackId + " " + widget.trackName);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> trackList = prefs.getStringList("trackList");
    List<String> trackNameList = prefs.getStringList("trackNameList");

    if (trackList != null && trackNameList != null) {
      if (!(trackList.contains(widget.trackId))) {
        print("not contain adding... one");
        trackList.add(widget.trackId);
        trackNameList.add(widget.trackName);
        prefs.setStringList("trackList", trackList);
        prefs.setStringList("trackNameList", trackNameList);
        setState(() {
          widget.isSaved = !widget.isSaved;
        });
      } else {
        print(" contain removing... one");
        trackList.remove(widget.trackId);
        trackNameList.remove(widget.trackName);
        prefs.setStringList("trackList", trackList);
        prefs.setStringList("trackNameList", trackNameList);
        setState(() {
          widget.isSaved = !widget.isSaved;
        });
      }
    } else {
      print("new one");
      List<String> ttrackList = [];
      List<String> ttrackNameList = [];
      print("getting cns " + widget.trackId + " " + widget.trackName);
      ttrackNameList.add(widget.trackName);
      ttrackList.add(widget.trackId);

      prefs.setStringList("trackList", ttrackList);
      prefs.setStringList("trackNameList", ttrackNameList);
      setState(() {
        widget.isSaved = !widget.isSaved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            addToBookMarked();
                          },
                          child: Icon(Icons.bookmark)))
                  : Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                          onTap: () {
                            addToBookMarked();
                          },
                          child: Icon(Icons.bookmark_border)))
            ]),
        body: Builder(
          builder: (BuildContext context) {
            return OfflineBuilder(
                connectivityBuilder: (BuildContext context,
                    ConnectivityResult connectivity, Widget child) {
                  final bool connected =
                      connectivity != ConnectivityResult.none;
                  return Container(
                      child: connected
                          ? Container(child: mainScreenWidget())
                          : Container(
                              child: Center(
                                  child: Text(
                              "No Internet Connection",
                              style: titleStyle(),
                            ))));
                },
                child: Container());
          },
        ));
  }

  Widget mainScreenWidget() {
    blocTrack.fetchTrackDetails(widget.trackId);
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: blocTrack.trackDtl,
        builder: (context, AsyncSnapshot<TrackDetails> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.message.header.statusCode);
            if (snapshot.data.message.header.statusCode == 200) {
              return buildList(snapshot);
            } else {
              return Container(
                  child: Center(
                      child: Text(
                "Error: " + snapshot.data.message.header.statusCode.toString(),
                style: titleStyle(),
              )));
            }
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Container(
              alignment: Alignment.center,
              child: Center(child: CircularProgressIndicator()));
        },
      ),
    );
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
    if (snapshot.data.message.body.track.explicit != null) {
      if (snapshot.data.message.body.track.explicit == 1) {
        explicit = true;
      }
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
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
    blocLyrics.fetchLyrics(widget.trackId);
    return StreamBuilder(
      stream: blocLyrics.lyrics,
      builder: (context, AsyncSnapshot<Lyrics> snapshot) {
        if (snapshot.hasData) {
          print("lyrics code" +
              snapshot.data.message.header.statusCode.toString());
          if (snapshot.data.message.header.statusCode == 200) {
            return lyricsDetail(snapshot);
          } else {
            return Container(
                child: Center(
                    child: Text(
              "Error: " + snapshot.data.message.header.statusCode.toString(),
              style: titleStyle(),
            )));
          }
        } else if (snapshot.hasError) {
          return Container(
              child: Center(
                  child: Text(
            "Error: ",
            style: titleStyle(),
          )));
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

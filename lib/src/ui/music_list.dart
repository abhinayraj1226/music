import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:music/src/bloc/music_list_bloc.dart';
import 'package:music/src/models/music_list.dart';
import 'package:music/src/ui/bookmaked.dart';
import 'package:music/src/ui/track_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicistDisplay extends StatelessWidget {
  Future<bool> checkIsbookMarked(String trackId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> trackList = prefs.getStringList("trackList");

    bool isSvaed = false;
    if (trackList != null) {
      if (trackList.contains(trackId)) {
        isSvaed = true;
        print(isSvaed);
      }
    }
    return isSvaed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Trending'), actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BookMarked()));
                  },
                  child: Row(
                    children: [
                      Text("Bookmark ",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )),
                      Icon(Icons.collections_bookmark)
                    ],
                  ))),
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
                          ? Container(child: musicList())
                          : Container(
                              child: Center(
                                  child: Text(
                              "No Internet Connection",
                              style: titleStyle(),
                            ))));
                },
                child: Container());
          },
        )
        //
        );
  }

  Widget musicList() {
    blocMusicList.fetchAllMusic();
    return StreamBuilder(
      stream: blocMusicList.allMusic,
      builder: (context, AsyncSnapshot<MusicList> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.message.header.statusCode == 200) {
            print(snapshot.data.message.body.trackList.length);
            return buildList(snapshot);
          } else {
            return Container(
                alignment: Alignment.center,
                child: Center(
                    child: Column(children: [
                  Text(
                    "Error: " +
                        snapshot.data.message.header.statusCode.toString(),
                    style: titleStyle(),
                  ),
                  RaisedButton(
                      onPressed: () => {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => build(context)))
                          },
                      child: Text(
                        "Try Again !",
                        style: titleStyle(),
                      ))
                ])));
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

  TextStyle titleStyle() {
    return TextStyle(
        fontSize: 25.0, color: Colors.white54, fontWeight: FontWeight.bold);
  }

  Widget buildList(AsyncSnapshot<MusicList> snapshot) {
    return ListView.builder(
        // shrinkWrap: true, //just set this property
        padding: const EdgeInsets.all(0.0),
        itemCount: snapshot.data.message.body.trackList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            // elevation: 0.0,
            child: InkWell(
              child: new Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                  // padding: EdgeInsets.symmetric(
                  // horizontal: 10.0, vertical: 10.0),
                  child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 40, 0),
                            child: Image.asset(
                              'assets/images/music.png',
                              height: 40,
                            ),
                          ),
                          Container(
                            // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    "${snapshot.data.message.body.trackList[index].track.trackName}",
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    "${snapshot.data.message.body.trackList[index].track.albumName}",
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.white54),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Text(
                                    "${snapshot.data.message.body.trackList[index].track.artistName}",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  )))
                        ],
                      ))),
              onTap: () async {
                String trackId = snapshot
                    .data.message.body.trackList[index].track.trackId
                    .toString();
                String trackName = snapshot.data.message.body.trackList[index]
                            .track.trackName !=
                        null
                    ? snapshot
                        .data.message.body.trackList[index].track.trackName
                    : "NA";
                bool isSaved = await checkIsbookMarked(trackId);

                print("getting " + isSaved.toString());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrackDetailsDisplay(
                            trackId: trackId,
                            trackName: trackName,
                            isSaved: isSaved)));
              },
            ),
          );
        });
  }
}

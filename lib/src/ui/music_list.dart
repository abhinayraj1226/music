import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:music/src/bloc/music_list_bloc.dart';
import 'package:music/src/models/music_list.dart';
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
      }
      isSvaed = false;
    }
    return isSvaed;
  }

  @override
  Widget build(BuildContext context) {
    blocMusicList.fetchAllMusic();
    return Scaffold(
        appBar: AppBar(title: Text('Trending'), actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {},
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
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      child,
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        height: MediaQuery.of(context).size.height,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          color: connected ? null : Color(0xFFEE4400),
                          child: connected
                              ? StreamBuilder(
                                  stream: blocMusicList.allMusic,
                                  builder: (context,
                                      AsyncSnapshot<MusicList> snapshot) {
                                    if (snapshot.hasData) {
                                      return buildList(snapshot);
                                    } else if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    }
                                    return Container(
                                        alignment: Alignment.center,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  },
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "OFFLINE",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                      height: 12.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  );
                },
                child: Container());
          },
        )
        //
        );
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
                                Text(
                                  "${snapshot.data.message.body.trackList[index].track.trackName}",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                                Text(
                                  "${snapshot.data.message.body.trackList[index].track.albumName}",
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.white54),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
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
                bool isSaved = await checkIsbookMarked(trackId);

                print("getting " + isSaved.toString());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrackDetailsDisplay(
                            trackId: trackId, isSaved: isSaved)));
              },
            ),
          );
        });
  }
}

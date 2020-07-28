import 'package:flutter/material.dart';
import 'package:music/src/ui/track_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarked extends StatefulWidget {
  BookMarkedState createState() => BookMarkedState();
}

class BookMarkedState extends State<BookMarked> {
  List<String> trackList = [];
  List<String> trackNameList = [];
  bool isBookMarked = false;
  @override
  void initState() {
    super.initState();
    getBookmarked();
  }

  void getBookmarked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      trackList = prefs.getStringList("trackList");
      trackNameList = prefs.getStringList("trackNameList");
      if (trackList != null && trackNameList != null) {
        print("lenght of track " + trackList[0]);
        isBookMarked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('BookMarked'),
        ),
        body: isBookMarked
            ? ListView.builder(
                // shrinkWrap: true, //just set this property
                padding: const EdgeInsets.all(0.0),
                itemCount: trackList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: GestureDetector(
                          onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TrackDetailsDisplay(
                                                trackId: trackList[index],
                                                trackName: trackNameList[index],
                                                isSaved: true)))
                              },
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, right: 10.0),
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 40, 0),
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
                                              trackNameList[index],
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                          ],
                                          // child: Text(trackList[index])
                                        ))
                                      ])))));
                })
            : Container(
                child: Center(
                child: Text(
                  "No BookMarked !",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              )));
  }
}

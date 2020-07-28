import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:music/src/models/lyrics.dart';
import 'package:music/src/models/music_list.dart';
import 'dart:convert';

import 'package:music/src/models/track_details.dart';

class ApiProvider {
  Client client = Client();
  final _apiKey = '2999dbd0fe6752a78c3215387adcc043';

  Future<MusicList> fetchMusicList() async {
    print("entered");
    final response = await client.get(
        "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=$_apiKey");
    print(response.body.toString());
    var data = json.decode(response.body);
    var staatusCode = data["message"]["header"]["status_code"];

    if (staatusCode == 200) {
      print("getiing 200");
      // If the call to the server was successful, parse the JSON
      return MusicList.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      print("error");
      return MusicList.fromJson(json.decode(response.body));
    }
  }

  Future<TrackDetails> fetchTrackDetails(String trackId) async {
    print("entered");
    final response = await client.get(
        "https://api.musixmatch.com/ws/1.1/track.get?track_id=$trackId&apikey=$_apiKey");
    // https://api.musixmatch.com/ws/1.1/track.get?track_id=200357565&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7
    print(response.body.toString());
    var data = json.decode(response.body);
    // print("displayiong body part");
    // print();
    var staatusCode = data["message"]["header"]["status_code"];
    // print(data["message"]["body"]["status_code"]["track_list"]);
    if (staatusCode == 200) {
      print("getting 200 in trackDetails");
      // If the call to the server was successful, parse the JSON
      return TrackDetails.fromJson(json.decode(response.body));
    } else {
      print("wrong");
      // If that call was not successful, throw an error.
      return TrackDetails.fromJson(json.decode(response.body));
    }
  }

  Future<Lyrics> fetchLyrics(String trackId) async {
    print("entered" + trackId.toString());
    final response = await client.get(
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackId&apikey=$_apiKey");
    // https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=TRACK_ID&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7

    print(response.body.toString());
    var data = json.decode(response.body);
    var staatusCode = data["message"]["header"]["status_code"];
    if (staatusCode == 200) {
      print("getting 200 in lyrics");
      // If the call to the server was successful, parse the JSON
      return Lyrics.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      print("wrong");
      return Lyrics.fromJson(json.decode(response.body));
    }
  }
}

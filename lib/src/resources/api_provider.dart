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
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return MusicList.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<TrackDetails> fetchTrackDetails(String trackId) async {
    print("entered");
    final response = await client.get(
        "https://api.musixmatch.com/ws/1.1/track.get?track_id=$trackId&apikey=$_apiKey");
    // https://api.musixmatch.com/ws/1.1/track.get?track_id=200357565&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return TrackDetails.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<Lyrics> fetchLyrics(String trackId) async {
    print("entered" + trackId.toString());
    final response = await client.get(
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackId&apikey=$_apiKey");
    // https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=TRACK_ID&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7

    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Lyrics.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      // If the call to the server was successful, parse the JSON
      throw Exception('Failed to load post');
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}

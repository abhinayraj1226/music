import 'dart:async';
import 'package:music/src/models/lyrics.dart';
import 'package:music/src/models/music_list.dart';
import 'package:music/src/models/track_details.dart';
import 'package:music/src/resources/api_provider.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<MusicList> fetchAllMusic() => apiProvider.fetchMusicList();

  Future<TrackDetails> fetchTrackDetails(String trackId) =>
      apiProvider.fetchTrackDetails(trackId);

  Future<Lyrics> fetchLyricsByTrackId(String trackId) =>
      apiProvider.fetchLyrics(trackId);
}

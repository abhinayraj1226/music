import 'package:music/src/models/lyrics.dart';
import 'package:rxdart/subjects.dart';
import '../resources/repository.dart';

class LyricsBloc {
  final _repository = Repository();
  final _lyricssFetcher = PublishSubject<Lyrics>();

  Stream<Lyrics> get lyrics => _lyricssFetcher.stream;

  fetchLyrics(String trackId) async {
    Lyrics lyrics = await _repository.fetchLyricsByTrackId(trackId);
    _lyricssFetcher.sink.add(lyrics);
  }

  dispose() {
    _lyricssFetcher.close();
  }
}

final blocLyrics = LyricsBloc();

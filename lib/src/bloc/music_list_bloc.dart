import 'package:music/src/models/music_list.dart';
import 'package:rxdart/subjects.dart';
import '../resources/repository.dart';

class MusicListsBloc {
  final _repository = Repository();
  final _musicListFetcher = PublishSubject<MusicList>();

  Stream<MusicList> get allMusic => _musicListFetcher.stream;

  fetchAllMusic() async {
    MusicList musicList = await _repository.fetchAllMusic();
    _musicListFetcher.sink.add(musicList);
  }

  dispose() {
    _musicListFetcher.close();
  }
}

final blocMusicList = MusicListsBloc();

import 'package:music/src/models/track_details.dart';
import 'package:rxdart/subjects.dart';
import '../resources/repository.dart';

class TrackDetailsBloc {
  final _repository = Repository();
  final _trackDetailsFetcher = PublishSubject<TrackDetails>();

  Stream<TrackDetails> get trackDtl => _trackDetailsFetcher.stream;

  fetchTrackDetails(String trackId) async {
    TrackDetails trackDetails = await _repository.fetchTrackDetails(trackId);
    _trackDetailsFetcher.sink.add(trackDetails);
  }

  dispose() {
    _trackDetailsFetcher.close();
  }
}

final blocTrack = TrackDetailsBloc();

// To parse this JSON data, do
//
//     final trackDetails = trackDetailsFromJson(jsonString);

import 'dart:convert';

TrackDetails trackDetailsFromJson(String str) =>
    TrackDetails.fromJson(json.decode(str));

String trackDetailsToJson(TrackDetails data) => json.encode(data.toJson());

class TrackDetails {
  TrackDetails({
    this.message,
  });

  Message message;

  factory TrackDetails.fromJson(Map<String, dynamic> json) => TrackDetails(
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message.toJson(),
      };
}

class Message {
  Message({
    this.header,
    this.body,
  });

  Header header;
  Body body;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        header: json["header"] == null ? null : Header.fromJson(json["header"]),
        body: json["header"]["status_code"] != 200
            ? null
            : Body.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "header": header == null ? null : header.toJson(),
        "body": body == null ? null : body.toJson(),
      };
}

class Body {
  Body({
    this.track,
  });

  Track track;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        track: json["track"] == null ? null : Track.fromJson(json["track"]),
      );

  Map<String, dynamic> toJson() => {
        "track": track == null ? null : track.toJson(),
      };
}

class Track {
  Track({
    this.trackId,
    this.trackName,
    this.trackNameTranslationList,
    this.trackRating,
    this.commontrackId,
    this.instrumental,
    this.explicit,
    this.hasLyrics,
    this.hasSubtitles,
    this.hasRichsync,
    this.numFavourite,
    this.albumId,
    this.albumName,
    this.artistId,
    this.artistName,
    this.trackShareUrl,
    this.trackEditUrl,
    this.restricted,
    this.updatedTime,
    this.primaryGenres,
  });

  int trackId;
  String trackName;
  List<dynamic> trackNameTranslationList;
  int trackRating;
  int commontrackId;
  int instrumental;
  int explicit;
  int hasLyrics;
  int hasSubtitles;
  int hasRichsync;
  int numFavourite;
  int albumId;
  String albumName;
  int artistId;
  String artistName;
  String trackShareUrl;
  String trackEditUrl;
  int restricted;
  DateTime updatedTime;
  PrimaryGenres primaryGenres;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        trackId: json["track_id"] == null ? null : json["track_id"],
        trackName: json["track_name"] == null ? null : json["track_name"],
        trackNameTranslationList: json["track_name_translation_list"] == null
            ? null
            : List<dynamic>.from(
                json["track_name_translation_list"].map((x) => x)),
        trackRating: json["track_rating"] == null ? null : json["track_rating"],
        commontrackId:
            json["commontrack_id"] == null ? null : json["commontrack_id"],
        instrumental:
            json["instrumental"] == null ? null : json["instrumental"],
        explicit: json["explicit"] == null ? null : json["explicit"],
        hasLyrics: json["has_lyrics"] == null ? null : json["has_lyrics"],
        hasSubtitles:
            json["has_subtitles"] == null ? null : json["has_subtitles"],
        hasRichsync: json["has_richsync"] == null ? null : json["has_richsync"],
        numFavourite:
            json["num_favourite"] == null ? null : json["num_favourite"],
        albumId: json["album_id"] == null ? null : json["album_id"],
        albumName: json["album_name"] == null ? null : json["album_name"],
        artistId: json["artist_id"] == null ? null : json["artist_id"],
        artistName: json["artist_name"] == null ? null : json["artist_name"],
        trackShareUrl:
            json["track_share_url"] == null ? null : json["track_share_url"],
        trackEditUrl:
            json["track_edit_url"] == null ? null : json["track_edit_url"],
        restricted: json["restricted"] == null ? null : json["restricted"],
        updatedTime: json["updated_time"] == null
            ? null
            : DateTime.parse(json["updated_time"]),
        primaryGenres: json["primary_genres"] == null
            ? null
            : PrimaryGenres.fromJson(json["primary_genres"]),
      );

  Map<String, dynamic> toJson() => {
        "track_id": trackId == null ? null : trackId,
        "track_name": trackName == null ? null : trackName,
        "track_name_translation_list": trackNameTranslationList == null
            ? null
            : List<dynamic>.from(trackNameTranslationList.map((x) => x)),
        "track_rating": trackRating == null ? null : trackRating,
        "commontrack_id": commontrackId == null ? null : commontrackId,
        "instrumental": instrumental == null ? null : instrumental,
        "explicit": explicit == null ? null : explicit,
        "has_lyrics": hasLyrics == null ? null : hasLyrics,
        "has_subtitles": hasSubtitles == null ? null : hasSubtitles,
        "has_richsync": hasRichsync == null ? null : hasRichsync,
        "num_favourite": numFavourite == null ? null : numFavourite,
        "album_id": albumId == null ? null : albumId,
        "album_name": albumName == null ? null : albumName,
        "artist_id": artistId == null ? null : artistId,
        "artist_name": artistName == null ? null : artistName,
        "track_share_url": trackShareUrl == null ? null : trackShareUrl,
        "track_edit_url": trackEditUrl == null ? null : trackEditUrl,
        "restricted": restricted == null ? null : restricted,
        "updated_time":
            updatedTime == null ? null : updatedTime.toIso8601String(),
        "primary_genres": primaryGenres == null ? null : primaryGenres.toJson(),
      };
}

class PrimaryGenres {
  PrimaryGenres({
    this.musicGenreList,
  });

  List<dynamic> musicGenreList;

  factory PrimaryGenres.fromJson(Map<String, dynamic> json) => PrimaryGenres(
        musicGenreList: json["music_genre_list"] == null
            ? null
            : List<dynamic>.from(json["music_genre_list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "music_genre_list": musicGenreList == null
            ? null
            : List<dynamic>.from(musicGenreList.map((x) => x)),
      };
}

class Header {
  Header({
    this.statusCode,
    this.executeTime,
  });

  int statusCode;
  double executeTime;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
        statusCode: json["status_code"] == null ? null : json["status_code"],
        executeTime: json["execute_time"] == null
            ? null
            : json["execute_time"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode == null ? null : statusCode,
        "execute_time": executeTime == null ? null : executeTime,
      };
}

// To parse this JSON data, do
//
//     final lyrics = lyricsFromJson(jsonString);

import 'dart:convert';

Lyrics lyricsFromJson(String str) => Lyrics.fromJson(json.decode(str));

String lyricsToJson(Lyrics data) => json.encode(data.toJson());

class Lyrics {
  Lyrics({
    this.message,
  });

  Message message;

  factory Lyrics.fromJson(Map<String, dynamic> json) => Lyrics(
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
    this.lyrics,
  });

  LyricsClass lyrics;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        lyrics: json["lyrics"] == null
            ? null
            : LyricsClass.fromJson(json["lyrics"]),
      );

  Map<String, dynamic> toJson() => {
        "lyrics": lyrics == null ? null : lyrics.toJson(),
      };
}

class LyricsClass {
  LyricsClass({
    this.lyricsId,
    this.explicit,
    this.lyricsBody,
    this.scriptTrackingUrl,
    this.pixelTrackingUrl,
    this.lyricsCopyright,
    this.updatedTime,
  });

  int lyricsId;
  int explicit;
  String lyricsBody;
  String scriptTrackingUrl;
  String pixelTrackingUrl;
  String lyricsCopyright;
  DateTime updatedTime;

  factory LyricsClass.fromJson(Map<String, dynamic> json) => LyricsClass(
        lyricsId: json["lyrics_id"] == null ? null : json["lyrics_id"],
        explicit: json["explicit"] == null ? null : json["explicit"],
        lyricsBody: json["lyrics_body"] == null ? null : json["lyrics_body"],
        scriptTrackingUrl: json["script_tracking_url"] == null
            ? null
            : json["script_tracking_url"],
        pixelTrackingUrl: json["pixel_tracking_url"] == null
            ? null
            : json["pixel_tracking_url"],
        lyricsCopyright:
            json["lyrics_copyright"] == null ? null : json["lyrics_copyright"],
        updatedTime: json["updated_time"] == null
            ? null
            : DateTime.parse(json["updated_time"]),
      );

  Map<String, dynamic> toJson() => {
        "lyrics_id": lyricsId == null ? null : lyricsId,
        "explicit": explicit == null ? null : explicit,
        "lyrics_body": lyricsBody == null ? null : lyricsBody,
        "script_tracking_url":
            scriptTrackingUrl == null ? null : scriptTrackingUrl,
        "pixel_tracking_url":
            pixelTrackingUrl == null ? null : pixelTrackingUrl,
        "lyrics_copyright": lyricsCopyright == null ? null : lyricsCopyright,
        "updated_time":
            updatedTime == null ? null : updatedTime.toIso8601String(),
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

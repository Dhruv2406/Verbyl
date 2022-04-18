import 'package:verbyl_project/models/song.dart';

class Charts{
  Charts({
    this.songs
  });

  List<Songs>? songs;

  factory Charts.fromJson(Map<String, dynamic> json) => Charts(
    songs: List<Songs>.from(json["songs"].map((x) => Songs.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "songs": List<dynamic>.from(songs!.map((x) => x.toJson())),
  };
}

class ChartsDataShazam {
  String? title;
  String? subtitle;
  String? imageURL;

  ChartsDataShazam({
    this.title,this.subtitle,this.imageURL
  });

  factory ChartsDataShazam.fromJson(Map<String, dynamic> json) => ChartsDataShazam(
    title: json["title"],
    subtitle: json["subtitle"],
    imageURL: json["images"]["background"],
  );

}
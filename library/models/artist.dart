// To parse this JSON data, do
//
//     final artist = artistFromJson(jsonString);

import 'dart:convert';
import 'package:verbyl_project/models/song.dart';

ArtistData artistFromJson(String str) => ArtistData.fromJson(json.decode(str));

// String artistToJson(Artist data) => json.encode(data.toJson());

class ArtistData {
  ArtistData({
    this.data,
    this.artistId,
    this.artistName,
    this.imageUrl,
    //this.next,
  });

  List<Datum>? data;
  int? artistId;
  String? artistName;
  String? imageUrl;
  // String next;

  factory ArtistData.fromJson(Map<String, dynamic> json) => ArtistData(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    artistId: json["data"][0]["artist"]["id"],
    artistName: json["data"][0]["artist"]["name"],
    imageUrl: json["data"][0]["artist"]["picture_big"],
    // next: json["next"],
  );


  // Map<String, dynamic> toJson() => {
  //   "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  //   "total": total,
  //   // "next": next,
  // };

}

//
// class ArtistDatum {
//   ArtistDatum({
//     this.datum,
//     this.contributors,
//   });
//
//   Datum? datum;
//   List<Contributor>? contributors;
//
//   factory ArtistDatum.fromJson(Map<String, dynamic> json) => ArtistDatum(
//     datum: Datum.fromJson(json),
//     contributors: List<Contributor>.from(json["contributors"].map((x) => Contributor.fromJson(x))),
//   );
//
//   // Map<String, dynamic> toJson() => {
//   //   "id": id,
//   //   "readable": readable,
//   //   "title": title,
//   //   "title_short": titleShort,
//   //   "title_version": titleVersionValues.reverse[titleVersion],
//   //   "link": link,
//   //   "duration": duration,
//   //   "rank": rank,
//   //   "explicit_lyrics": explicitLyrics,
//   //   "explicit_content_lyrics": explicitContentLyrics,
//   //   "explicit_content_cover": explicitContentCover,
//   //   "preview": preview,
//   //   "contributors": List<dynamic>.from(contributors.map((x) => x.toJson())),
//   // };
// }
//
// // class Album {
// //   Album({
// //     this.id,
// //     this.title,
// //     this.cover,
// //     this.coverSmall,
// //     this.coverMedium,
// //     this.coverBig,
// //     this.coverXl,
// //     this.md5Image,
// //     this.tracklist,
// //     this.type,
// //   });
// //
// //   int? id;
// //   String? title;
// //   String? cover;
// //   String? coverSmall;
// //   String? coverMedium;
// //   String? coverBig;
// //   String? coverXl;
// //   String? md5Image;
// //   String? tracklist;
// //   String? type;
// //
// //   factory Album.fromJson(Map<String, dynamic> json) => Album(
// //     id: json["id"],
// //     title: json["title"],
// //     cover: json["cover"],
// //     coverSmall: json["cover_small"],
// //     coverMedium: json["cover_medium"],
// //     coverBig: json["cover_big"],
// //     coverXl: json["cover_xl"],
// //     md5Image: json["md5_image"],
// //     tracklist: json["tracklist"],
// //     type: json["type"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "id": id,
// //     "title": title,
// //     "cover": cover,
// //     "cover_small": coverSmall,
// //     "cover_medium": coverMedium,
// //     "cover_big": coverBig,
// //     "cover_xl": coverXl,
// //     "md5_image": md5Image,
// //     "tracklist": tracklist,
// //     "type": type,
// //   };
// // }
//
// class ArtistClass {
//   ArtistClass({
//     this.id,
//     this.name,
//     this.tracklist,
//     this.type,
//   });
//
//   int? id;
//   String? name;
//   String? tracklist;
//   String? type;
//
//   factory ArtistClass.fromJson(Map<String, dynamic> json) => ArtistClass(
//     id: json["id"],
//     name: json["name"],
//     tracklist: json["tracklist"],
//     type: json["type"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "tracklist": tracklist,
//     "type": type,
//   };
// }
//
// class Contributor {
//   Contributor({
//     this.id,
//     this.name,
//     this.link,
//     this.share,
//     this.picture,
//     this.pictureSmall,
//     this.pictureMedium,
//     this.pictureBig,
//     this.pictureXl,
//     this.radio,
//     this.tracklist,
//     this.type,
//     this.role,
//   });
//
//   int? id;
//   String? name;
//   String? link;
//   String? share;
//   String? picture;
//   String? pictureSmall;
//   String? pictureMedium;
//   String? pictureBig;
//   String? pictureXl;
//   bool? radio;
//   String? tracklist;
//   String? type;
//   String? role;
//
//   factory Contributor.fromJson(Map<String, dynamic> json) => Contributor(
//     id: json["id"],
//     name: json["name"],
//     link: json["link"],
//     share: json["share"],
//     picture: json["picture"],
//     pictureSmall: json["picture_small"],
//     pictureMedium: json["picture_medium"],
//     pictureBig: json["picture_big"],
//     pictureXl: json["picture_xl"],
//     radio: json["radio"],
//     tracklist: json["tracklist"],
//     type: json["type"],
//     role: json["role"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "link": link,
//     "share": share,
//     "picture": picture,
//     "picture_small": pictureSmall,
//     "picture_medium": pictureMedium,
//     "picture_big": pictureBig,
//     "picture_xl": pictureXl,
//     "radio": radio,
//     "tracklist": tracklist,
//     "type": type,
//     "role": role,
//   };
// }

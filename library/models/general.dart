import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:verbyl_project/models/user.dart';

class ChartsDemo {
  ChartsDemo({
    this.title = "",
    this.country = "",
    this.color,
  });
  String title;
  String country;
  Color? color;
}

class DemoArtist {
  DemoArtist({
    this.name = "",
    this.imageLink = "",
  });
  String name;
  String imageLink;
}

class Song {
  Song({
    this.name = "",
    this.imageLink = "",
  });
  String name;
  String imageLink;
}

class PlaylistDemo {
  String name;
  List<Song>? songs;
  PlaylistDemo({this.name = "",this.songs});

//List<Song> songs = List<Song>.empty(growable: true);
}

List<PlaylistDemo> userPlaylistDemo = [
  PlaylistDemo(
      name: "LOFI Songs",
      songs: [
        Song(name: "Levitating",imageLink: ""),
        Song(name: "In My Blood",imageLink: ""),
        Song(name: "Mood",imageLink: ""),
      ]
  ),
  PlaylistDemo(
      name: "Playlist 1",
      songs: [
        Song(name: "Levitating",imageLink: ""),
        Song(name: "In My Blood",imageLink: ""),
        Song(name: "Mood",imageLink: ""),
      ]
  ),
  PlaylistDemo(
      name: "Playlist 2",
      songs: [
        Song(name: "Levitating",imageLink: ""),
        Song(name: "In My Blood",imageLink: ""),
        Song(name: "Mood",imageLink: ""),
      ]
  ),
];

List<VerbylUser> users = [
  VerbylUser.named(
    name: "Divyam Mistry",
    email: "divsmistry30@gmail.com",
    location: "Bilimora, Gujarat",
    avatarIndex: 1,
    followingArtists: 3,
    playlists: 3,
  ),
  VerbylUser.named(
    name: "Arnish Mistry",
    email: "arnishmistry@gmail.com",
    location: "Surat, Gujarat",
    avatarIndex: 1,
    followingArtists: 3,
    playlists: 3,
  ),
];
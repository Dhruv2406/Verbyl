import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'song.dart';

class MusicPlayerModel{

  PlayingQueue queue = PlayingQueue([]);
  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = const Duration();
  Duration position = const Duration();

  bool isPlaying = true;

  void play(){
    this.isPlaying = true;
  }

  void pause(){
    this.isPlaying = false;
  }

  bool playNext(){
    if(queue.currentIndex == queue.songs.length - 1) return false;
    this.position = Duration(seconds: 0);
    this.isPlaying = true;
    ++queue.currentIndex;
    ++queue.previousIndex;
    return true;
  }

  bool playPrevious(){
    if(queue.currentIndex == 0) return false;
    this.position = Duration(seconds: 0);
    this.isPlaying = true;
    --queue.currentIndex;
    --queue.previousIndex;
    return true;
  }

}

class PlayingQueue{
  List<Datum> songs = [];
  int previousIndex = -2;
  int currentIndex = -1;

  PlayingQueue(List<Datum> songs){
    this.songs = songs;
  }

  void loadSoloTrack(Datum song){
      currentIndex = 0;
      previousIndex = -1;
      this.songs = [];
      this.songs.add(song);
  }

  void loadSongs(List<Datum> songs){
    this.songs = [];
    currentIndex=0;
    previousIndex=-1;
    for(var s in songs){
      this.songs.add(s);
    }
  }

  void addSong(Datum song){
    for(int i=0;i<songs.length;++i){
      if(songs[i].id == song.id){
        return;
      }
    }
    songs.add(song);
  }

  void addSongs(List<Datum> songs){
    print("hERE");
    for(var s in songs){
      print(s.title);
      this.songs.add(s);
    }
    print("Length : " + this.songs.length.toString());
  }

}
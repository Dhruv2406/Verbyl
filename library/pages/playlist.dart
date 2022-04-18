import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/pages/mini_music_player.dart';
import 'package:verbyl_project/pages/song_card.dart';
import 'package:verbyl_project/services/data.dart';

import '../models/general.dart';
import '../models/playlist.dart';
import '../services/helpers.dart';
import '../models/song.dart';
import '../theme.dart';
import 'search.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;
  const PlaylistPage({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  // bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          backgroundColor: bgDark,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset("assets/images/playlist.png",width: size.width),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: widget.playlist.name.toString() + "\n",
                                style: GoogleFonts.montserrat(color: textLight,fontSize: 24),
                                children: [
                                  // TextSpan(
                                  //     text: widget.playlist.songs!.length.toString() + " songs",
                                  //     style: GoogleFonts.montserrat(color: Colors.grey.shade400,fontSize: 16),
                                  // ),
                                ]
                              ),
                            ),
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: IconButton(
                                onPressed: (){
                                  // player.queue.loadSongs(widget.playlist);
                                  player.isPlaying = !player.isPlaying;
                                  setState(() {
                                  });
                                },
                                icon: Icon(
                                  // isPlaying
                                  //     ? CupertinoIcons.pause_circle_fill
                                  //     :
                                  CupertinoIcons.play_circle_fill,
                                  size: 60,
                                  color: textLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 470,
                      child: FutureBuilder(
                          future: getPlaylistSongs(widget.playlist.pid.toString()),
                          builder: (ctx,snapshot){
                            if(snapshot.hasError){
                              return const Center(child: CircularProgressIndicator(color: Colors.red,));
                            }
                            else if(snapshot.connectionState == ConnectionState.done){
                              List<Datum> songs = snapshot.data as List<Datum>;
                              return ListView.builder(
                                  itemCount: songs.length,
                                  itemBuilder: (ctx,i){
                                    return SongCard(songs: songs[i]);
                                  }
                              );
                            }
                            return const Center(child: CircularProgressIndicator());
                          }
                      ),
                    ),
                    const SizedBox(height: 5,),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios,color: textLight,),
              )),
            ],
          ),
          persistentFooterButtons: [
            MiniMusicPlayer()
          ],
        ),
    );
  }
}


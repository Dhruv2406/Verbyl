import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/pages/song_card.dart';
import 'package:verbyl_project/services/data.dart';
import '../models/song.dart';
import '../theme.dart';
import 'mini_music_player.dart';

class LikedSongs extends StatefulWidget {
  const LikedSongs({Key? key}) : super(key: key);

  @override
  _LikedSongsState createState() => _LikedSongsState();
}

class _LikedSongsState extends State<LikedSongs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      persistentFooterButtons: const [
        MiniMusicPlayer(),
      ],
      backgroundColor: bgDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Liked Songs",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: textLight,
                  ) //TextStyle
              ),
              background: Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.shade900,
                        Colors.redAccent.shade400,
                        Colors.redAccent.shade100,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ), //FlexibleSpaceBar
            expandedHeight: 240,
            backgroundColor: Colors.redAccent.shade400,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),//<Widget>[]
          ), //SliverAppBar
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 500,
                child: FutureBuilder(
                    future: getLikedSongs(),
                    builder: (ctx, ss) {
                      if(ss.hasData && ss.connectionState == ConnectionState.done){
                        List<Datum> songList = ss.data as List<Datum>;
                        return ListView.builder(
                          itemBuilder: (context, index) {
                              return LikedSongCard(songs: songList[index], likeSongStateSetter: setState);
                            },
                            itemCount: songList.length,
                        );
                      }
                      if(ss.hasError) return Center(child: CircularProgressIndicator(color: Colors.red,));
                      return Center(child: CircularProgressIndicator(color: primary,));
                    },
                ),
              ),
            ]),
          ),
        ],
      ),
    ));
  }
}

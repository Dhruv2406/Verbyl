import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/models/artist.dart';
import 'package:verbyl_project/pages/mini_music_player.dart';
import 'package:verbyl_project/pages/song_card.dart';
import 'package:verbyl_project/theme.dart';

import '../services/data.dart';

class ArtistPage extends StatefulWidget {
  final ArtistData artistData;
  final int i;
  const ArtistPage({Key? key, required this.artistData, required this.i}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  bool isPlaying = false, following = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        persistentFooterButtons: const [
          MiniMusicPlayer(),
        ],
        backgroundColor: bgDark,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                          widget.artistData.artistName.toString(),
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: textLight,
                          ) //TextStyle
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Icon(Icons.verified_rounded,color: Colors.purple.shade300,size: 20,),
                  ],
                ), //Text
                background: Stack(children: [
                  Hero(
                    tag: Text("artist${widget.i}"),
                    child: Center(
                      child: Image.network(
                        widget.artistData.imageUrl.toString(),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.grey.shade700,
                            Colors.purple.shade900,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ), //Images.network
                ]),
              ), //FlexibleSpaceBar
              expandedHeight: 390,
              backgroundColor: bgDark,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ), //IconButton
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              following = !following;
                            });
                            if(following) followArtist(
                              widget.artistData.artistId.toString(),
                              widget.artistData.artistName.toString(),
                            );
                            else unfollowArtist(widget.artistData.artistId.toString());
                          },
                          child: SizedBox(
                            height: 40,
                            width: 140,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: primary,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  following
                                      ? Icon(
                                    CupertinoIcons.person_fill,
                                    color: textLight,
                                    size: 16,
                                  )
                                      : Icon(
                                    CupertinoIcons.person,
                                    color: textLight,
                                    size: 16,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  following
                                      ? Text(
                                    "Following",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        color: textLight),
                                  )
                                      : Text(
                                    "Follow",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        color: textLight),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isPlaying = !isPlaying;
                              });
                            },
                            icon: Icon(
                              isPlaying
                                  ? CupertinoIcons.pause_circle_fill
                                  : CupertinoIcons.play_circle_fill,
                              size: 50,
                              color: textLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ), //SliverAppBar
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => SongCard(
                  songs: widget.artistData.data![index],
                ),
                childCount: widget.artistData.data!.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

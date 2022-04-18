import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:verbyl_project/models/playlist.dart';
import 'package:verbyl_project/models/song.dart';
import 'package:verbyl_project/pages/artistPage.dart';
import 'package:verbyl_project/pages/playing_queue.dart';
import 'package:verbyl_project/theme.dart';

import '../services/data.dart';
import '../services/helpers.dart';

class MusicPlayer extends StatefulWidget {
  // final Datum song;
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

// bool isLoading = true;

class _MusicPlayerState extends State<MusicPlayer> {
  // AudioPlayer audioPlayer = AudioPlayer();
  // Duration duration = const Duration();
  // Duration position = const Duration();
  //
  // bool isPlaying = false, isShuffled = false;
  bool isLiked = false;

  void getAudio(bool changeSong) async {
    if (!changeSong) return;
    var url = player.queue.songs[player.queue.currentIndex].preview.toString();
    print("Current Index:" + player.queue.currentIndex.toString());
    if (player.isPlaying) {
      print("before res");
      var res = await player.audioPlayer.pause();
      print("res : $res");
      if (res == 1) {
        setState(() {
          player.isPlaying = false;
        });
      }
    }
    else {
      print("Song Playing");
      var res = await player.audioPlayer.play(url, isLocal: true);
      if (res == 1) {
        setState(() {
          player.isPlaying = true;
        });
      }
    }
    player.audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        player.duration = d;
        // checkEnd();
      });
    });
    player.audioPlayer.onAudioPositionChanged.listen((Duration d) {
      setState(() {
        player.position = d;
      });
    });
    print("ff");
    print(player.position);
    player.audioPlayer.onPlayerCompletion.listen((event) {
      setState((){});
    });
    // if (player.duration.inSeconds == player.position.inSeconds) {
    //   player.position = Duration(seconds: 0);
    //   print(player.position);
    //   setState(() {
    //     print("Song Ended");
    //   });
    // }
  }

  // late Duration _visibleValue;
  // bool listenOnlyUserInterraction = false;
  // double get percent => _visibleValue.inMilliseconds / 30;

  PaletteColor appbar = PaletteColor(textLight, 2);
  PaletteColor color = PaletteColor(primary, 2);
  PaletteColor dark = PaletteColor(primary, 2);

  _updatePalette() async {
    color = PaletteColor(primary, 2);
    dark = PaletteColor(primary, 2);
    print("_updatePalette starts");
    print(player.queue.currentIndex);
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(player.queue.songs[player.queue.currentIndex].album!.coverBig.toString()),
    );
    setState(() {
      //appbar = PaletteColor(generator.vibrantColor!.color, 2);
      if (generator.vibrantColor != null) {
        dark = PaletteColor(generator.vibrantColor!.color, 2);
      } else {
        dark = PaletteColor(generator.darkMutedColor!.color, 2);
      }
      color = PaletteColor(generator.dominantColor!.color, 2);
    });
    Helpers().predictMood(
        player.queue.songs[player.queue.currentIndex].title.toString(),
        player.queue.songs[player.queue.currentIndex].id.toString()
    ).then((value){
      setMood(value);
      addSongToRecentlyPlayed(player.queue.songs[player.queue.currentIndex], cityId, value, DateTime.now());
    });
    print("_updatePalette ends");
  }

  String mood = "Loading...";
  void setMood(String value) {
    setState(() {
      mood = value.toString().toUpperCase();
    });
  }

  late Map<dynamic, bool> playlistCheckBox = {};

  @override
  void initState() {
    setState(() {
      _updatePalette();
      //testFunction().then((value){isLoading = false;});
    });
    // API Hard limit - 100 (uncomment when presenting)
    //Helpers().predictMood(widget.song.title.toString()).then((value) => setMood(value));
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            color.color,
            bgDark,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: bgDark.withOpacity(0.5),
            elevation: 0.0,
            toolbarHeight: 70,
            title: SizedBox(
              width: 0.6 * size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "NOW PLAYING",
                    style: TextStyle(
                      color: appbar.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    player.queue.songs[player.queue.currentIndex].title
                        .toString(),
                    style: TextStyle(
                      color: appbar.color.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: appbar.color,
                size: 36,
              ),
              onPressed: () {
                setState(() {
                  player.isPlaying = player.isPlaying;
                });
                Navigator.pop(context);
              },
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'View Artist':
                      print("View Artist");
                      Helpers()
                          .getArtistData(player.queue
                              .songs[player.queue.currentIndex].artist!.name!
                              .toString())
                          .then((value) => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => ArtistPage(
                                      artistData: value,
                                      i: 0,
                                    ),
                                  ),
                                )
                              });
                      break;
                    case 'Add to playlist':
                      print("Add to playlist");
                      playlistCheckBox = {};
                      showModalBottomSheet(
                        context: context,
                        builder: (c) {
                          return Container(
                              color: bgDark.withOpacity(0.95),
                              child: StatefulBuilder(
                                builder: (ctx, setModalState) {
                                  return SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   crossAxisAlignment:
                                          //       CrossAxisAlignment.center,
                                          //   children: [
                                          //     Text(
                                          //       "  Add to playlist",
                                          //       style: GoogleFonts.montserrat(
                                          //         fontSize: 18,
                                          //         color: textLight,
                                          //       ),
                                          //     ),
                                          //     IconButton(
                                          //       onPressed: () {
                                          //         Navigator.pop(context);
                                          //       },
                                          //       icon: Icon(
                                          //         Icons.cancel_rounded,
                                          //         color: textLight,
                                          //         size: 26,
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          SizedBox(
                                            height: 300,
                                            child: FutureBuilder(
                                              future: getUserPlaylists(
                                                  uid.toString()),
                                              builder: (ctx, ss) {
                                                if (ss.connectionState ==
                                                    ConnectionState.done) {
                                                  print("Playlist length = " +
                                                      playlist.length.toString());
                                                  for(Playlist p in playlist){
                                                    playlistCheckBox.putIfAbsent(p, () => false);
                                                  }
                                                  return makeAddToPlaylistCard();
                                                }
                                                if (ss.hasError) {
                                                  print(ss.error);
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color: Colors.red,
                                                  ));
                                                }
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: primary,
                                                ));
                                              },
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                height: 45,
                                                width: 0.3 * size.width,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: textLight.withOpacity(0.8),
                                                  ),
                                                  onPressed: () {
                                                    playlistCheckBox = {};
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("CANCEL",
                                                    style: GoogleFonts.montserrat(
                                                      color: primary,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 45,
                                                width: 0.5 * size.width,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: primary,
                                                  ),
                                                  onPressed: (){
                                                    List<Playlist> playlists = [];
                                                    playlistCheckBox.forEach((key, value) {
                                                      if(value) playlists.add(key);
                                                    });
                                                    addSongToPlaylists(player.queue.songs[player.queue.currentIndex], playlists).then((value){
                                                      Navigator.of(context).pop();
                                                    });
                                                  },
                                                  child: Text("ADD TO PLAYLIST",
                                                    style: GoogleFonts.montserrat(
                                                      color: textLight,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                        }
                      );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {
                    'View Artist',
                    'Add to playlist',
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 45,
              ),
              songImage(player
                  .queue.songs[player.queue.currentIndex].album!.coverBig
                  .toString()),
              Container(
                height: 40,
                width: 0.8 * size.width,
                color: dark.color,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.wand_stars_inverse,
                      color: textLight,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      mood,
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        color: textLight,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 20,)
              // mood.isNotEmpty
              //     // ? predictedMood()
              // ? Container(
              //     height: 40,
              //     width: 0.8 * size.width,
              //     color: dark.color,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Icon(
              //           CupertinoIcons.wand_stars_inverse,
              //           color: textLight,
              //         ),
              //         const SizedBox(
              //           width: 10,
              //         ),
              //         Text(
              //           mood,
              //           style: GoogleFonts.montserrat(
              //             fontSize: 20,
              //             color: textLight,
              //           ),
              //         ),
              //       ],
              //     ),
              //   )
              //     : SizedBox(
              //   height: 40,
              //   width: 60,
              //   child: Center(
              //     child: SizedBox(
              //       height: 30,
              //       child: MusicVisualizer(
              //         barCount: 5,
              //         colors: [
              //           Colors.white,
              //           Colors.purpleAccent.shade400,
              //           Colors.white,
              //           Colors.purpleAccent.shade400,
              //           Colors.white
              //         ],
              //         duration: const [900, 700, 600, 800, 500],
              //       ),
              //     ),
              //   ),
              // ),
              // isLoading
              //     ? Container(child: Text(test[0].toString()),)
              //     // ? Container(
              //     //     height: 40,
              //     //     width: 0.8 * size.width,
              //     //     color: dark.color,
              //     //     child: Row(
              //     //       mainAxisAlignment: MainAxisAlignment.center,
              //     //       crossAxisAlignment: CrossAxisAlignment.center,
              //     //       children: [
              //     //         Icon(
              //     //           CupertinoIcons.wand_stars_inverse,
              //     //           color: textLight,
              //     //         ),
              //     //         const SizedBox(
              //     //           width: 10,
              //     //         ),
              //     //         Text(
              //     //           mood,
              //     //           style: GoogleFonts.montserrat(
              //     //             fontSize: 20,
              //     //             color: textLight,
              //     //           ),
              //     //         ),
              //     //       ],
              //     //     ),
              //     //   )
              //     : SizedBox(
              //         height: 40,
              //         width: 60,
              //         child: Center(
              //           child: SizedBox(
              //             height: 30,
              //             child: MusicVisualizer(
              //               barCount: 5,
              //               colors: [
              //                 Colors.white,
              //                 Colors.purpleAccent.shade400,
              //                 Colors.white,
              //                 Colors.purpleAccent.shade400,
              //                 Colors.white
              //               ],
              //               duration: const [900, 700, 600, 800, 500],
              //             ),
              //           ),
              //         ),
              //       ),
              const SizedBox(
                height: 45,
              ),
              musicPlayerControls(song: player.queue.songs[player.queue.currentIndex]),
            ],
          ),
        ),
      ),
    );
  }

  // Widget predictedMood(){
  //   String songName = player.queue.songs[player.queue.currentIndex].title.toString();
  //   Size size = MediaQuery.of(context).size;
  //   return SizedBox(
  //     child: FutureBuilder(
  //       future: testFunction(),
  //       //future: Helpers().predictMood(songName),
  //       builder: (ctx,ss){
  //         if(ss.connectionState == ConnectionState.done){
  //           // setMood(ss.data.toString());
  //           String m = ss.data.toString();
  //           // print(mood);
  //           print(m);
  //           return SizedBox(
  //             height: 30,
  //             width: 0.8 * size.width,
  //             child: Center(
  //                 child: Text("MOOD : $m",
  //               style: GoogleFonts.montserrat(
  //                   fontSize: 20,
  //                   color: textLight
  //               ),
  //             )),
  //           );
  //         }
  //         if(ss.hasError){
  //           print("ERROR" + ss.error.toString());
  //           return const SizedBox(
  //             height: 30,
  //             width: 30,
  //             child: CircularProgressIndicator(color: Colors.red,),
  //           );
  //         }
  //         return SizedBox(
  //           height: 30,
  //           width: 30,
  //           child: CircularProgressIndicator(color: primary,),
  //           // child: MusicVisualizer(
  //           //   barCount: 5,
  //           //   colors: [
  //           //     Colors.white,
  //           //     Colors.purpleAccent.shade400,
  //           //     Colors.white,
  //           //     Colors.purpleAccent.shade400,
  //           //     Colors.white
  //           //   ],
  //           //   duration: const [900, 700, 600, 800, 500],
  //           // ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget songDetails({required Datum song}) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 0.5 * size.width,
                child: Text(
                  song.title.toString().trim(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: textLight,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  if (player.queue.songs[player.queue.currentIndex]
                          .explicitLyrics ==
                      true)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        height: 14,
                        width: 14,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(2),
                          ),
                        ),
                        child: Center(
                            child: Text(
                          "E",
                          style: TextStyle(
                            fontSize: 9,
                            color: bgDark,
                          ),
                        )),
                      ),
                    )
                  else
                    const SizedBox(),
                  SizedBox(
                    width: 0.6 * size.width,
                    child: Text(
                      song.artist!.name.toString().trim(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: isLiked
                ? Icon(
                    Icons.favorite_rounded,
                    color: textLight,
                    size: 30,
                  )
                : Icon(
                    Icons.favorite_border_outlined,
                    color: textLight,
                    size: 30,
                  ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
              if(isLiked) likeSong(player.queue.songs[player.queue.currentIndex].id.toString());
              else unlikeSong(player.queue.songs[player.queue.currentIndex].id.toString());
            },
          ),
          IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: textLight,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => PlayingQueuePage()));
            },
          ),
        ],
      ),
    );
  }

  Widget musicPlayerControls({required Datum song}) {
    Size size = MediaQuery.of(context).size;
    double val = 0.0;

    String getPosition(Duration position) {
      String sec = position.inSeconds.toString();
      if (position.inSeconds.toDouble() <= 9.0) sec = "0" + sec;
      return sec;
    }

    String getDuration(Duration duration) {
      String sec = duration.inSeconds.toString();
      if (duration.inSeconds.toDouble() <= 9.0) sec = "0" + sec;
      return sec;
    }

    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: bgDark.withOpacity(0.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          songDetails(song: player.queue.songs[player.queue.currentIndex]),
          const SizedBox(
            height: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: SliderTheme(
                      data: const SliderThemeData(
                          trackHeight: 1,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 5)),
                      child: Slider(
                        min: 0.0,
                        inactiveColor: Colors.grey,
                        activeColor: Colors.white,
                        max: player.duration.inSeconds.toDouble(),
                        value: player.position.inSeconds.toDouble(),
                        onChangeEnd: (newValue) {
                          // print("Song Ended");
                          // setState(() {
                          //   //listenOnlyUserInterraction = false;
                          //   //widget.seekTo(_visibleValue);
                          // });
                        },
                        onChangeStart: (_) {
                          setState(() {
                            //listenOnlyUserInterraction = true;
                          });
                        },
                        onChanged: (newValue) {
                          // if()
                          setState(() {
                            player.audioPlayer
                                .seek(Duration(seconds: newValue.toInt()));
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "00:${getPosition(player.position)}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      "00:${getDuration(player.duration)}",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              // isShuffled = !isShuffled;
                            });
                          },
                          icon:
                              // isShuffled
                              //     ? Icon(
                              //         Icons.shuffle,
                              //         color: primary,
                              //         size: 30,
                              //       )
                              //     :
                              const Icon(
                            Icons.shuffle,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        height: 40,
                        width: 40,
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            mood = "Loading...";
                            if (player.playPrevious()) {
                              getAudio(true);
                              _updatePalette();
                              // testFunction().then((value){isLoading = false;});
                            } else {
                              getAudio(false);
                              _updatePalette();
                              // testFunction().then((value){isLoading = false;});
                            }
                          });
                        },
                        icon: Icon(
                          Icons.skip_previous,
                          size: 40,
                          color: textLight,
                        ),
                      ),
                    ],
                  ),
                  height: 100,
                  width: 110,
                ),
                Spacer(),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  height: 90,
                  width: 100,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        getAudio(true);
                      });
                    },
                    icon: Icon(
                      player.isPlaying
                          ? CupertinoIcons.pause_circle_fill
                          : CupertinoIcons.play_circle_fill,
                      size: 80,
                      color: textLight,
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 100,
                  width: 110,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          print("Pressed Next:");
                          print(player);
                          setState(() {
                            mood = "Loading...";
                            // player.isPlaying = !player.isPlaying;
                            if (player.playNext()) {
                              getAudio(true);
                              _updatePalette();
                              // testFunction().then((value){isLoading = false;});
                            } else {
                              getAudio(false);
                              _updatePalette();
                              // testFunction().then((value){isLoading = false;});
                            }
                          });
                        },
                        icon: Icon(
                          Icons.skip_next,
                          color: textLight,
                          size: 40,
                        ),
                      ),
                      Spacer(),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.arrow_2_circlepath,
                            color: textLight,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget songImage(String imageUrl) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 0.8 * size.width,
              width: 0.8 * size.width,
              child: Hero(
                tag: "songImage",
                child: (imageUrl != "null" && imageUrl != "")
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.fill,
                      )
                    : Image.asset('assets/images/placeholder.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makeAddToPlaylistCard() {
    return StatefulBuilder(
        builder: (BuildContext ctx, StateSetter setRecommendState) {
      return SizedBox(
        height: 400,
        child: Column(
          children: playlistCheckBox.keys
              .map((e) => Theme(
                    data: Theme.of(ctx).copyWith(
                      unselectedWidgetColor: textLight,
                    ),
                    child: CheckboxListTile(
                        contentPadding: const EdgeInsets.fromLTRB(25, 0, 15, 0),
                        title: Text(e.name.toString(),style: GoogleFonts.montserrat(
                          color: textLight,
                        ),),
                        value: playlistCheckBox[e],
                        onChanged: (bool? value) {
                          setRecommendState(() {
                            playlistCheckBox[e] = value!;
                          });
                        }),
                  ))
              .toList(),
        ),
      );
    });
  }
}

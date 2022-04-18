import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:verbyl_project/models/music_player.dart';
import 'package:verbyl_project/pages/music_player.dart';
import 'package:verbyl_project/pages/search.dart';
import 'package:verbyl_project/theme.dart';
import '../services/helpers.dart';
import '../models/song.dart';

class MiniMusicPlayer extends StatefulWidget {
  const MiniMusicPlayer({Key? key}) : super(key: key);

  @override
  _MiniMusicPlayerState createState() => _MiniMusicPlayerState();
}

class _MiniMusicPlayerState extends State<MiniMusicPlayer> {
  // bool isPlaying = true;

  void getAudio() async {
    var url = player.queue.songs[player.queue.currentIndex].preview.toString();
    print("Current Index:" + player.queue.currentIndex.toString());
    if (player.isPlaying) {
      var res = await player.audioPlayer.pause();
      if (res == 1) {
        setState(() {
          player.isPlaying = false;
        });
      }
    } else {
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
    if (player.duration.inSeconds == player.position.inSeconds) {
      player.position = Duration(seconds: 0);
      print("Song Ended");
      print(player.position);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String imageURL = player.queue.currentIndex != -1
        ? player.queue.songs[player.queue.currentIndex].album!.cover.toString()
        : "";
    String title = player.queue.currentIndex != -1
        ? player.queue.songs[player.queue.currentIndex].title.toString()
        : "";
    String artist = player.queue.currentIndex != -1
        ? player.queue.songs[player.queue.currentIndex].artist!.name.toString()
        : "";
    bool? explicitLyrics = player.queue.currentIndex != -1
        ? player.queue.songs[player.queue.currentIndex].explicitLyrics
        : false;
    print(imageURL);
    return GestureDetector(
      onTap: () {
        if (title.isNotEmpty && artist.isNotEmpty) {
          Navigator.push(context,
              MaterialPageRoute(builder: (ctx) => const MusicPlayer()));
        }
      },
      child: Column(
        children: [
          Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.purple.shade700.withOpacity(0.4),
                Colors.purpleAccent.shade400.withOpacity(0.35),
                Colors.purpleAccent.shade100.withOpacity(0.25),
              ]),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Hero(
                      tag: "songImage",
                      child: (imageURL != "null" && imageURL != "")
                          ? Image.network(
                              imageURL,
                              height: 50,
                              width: 50,
                            )
                          : Image.asset(
                              'assets/images/placeholder.png',
                              height: 50,
                              width: 50,
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 0.5 * size.width,
                        child: Text(
                          (title.isEmpty) ? "Playing Queue is empty" : title,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                              color: textLight, fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          if (explicitLyrics == true)
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
                            width: 0.5 * size.width,
                            child: Text((artist.isEmpty) ? "" : artist,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    color: Colors.grey, fontSize: 14)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  player.isPlaying
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              // player.isPlaying = false;
                              if (title.isNotEmpty && artist.isNotEmpty) {
                                getAudio();
                              }
                            });
                          },
                          icon: Icon(
                            Icons.pause_rounded,
                            size: 35,
                            color: textLight,
                          ))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              // player.isPlaying = true;
                              if (title.isNotEmpty && artist.isNotEmpty) {
                                getAudio();
                              }
                            });
                          },
                          icon: Icon(
                            Icons.play_arrow_rounded,
                            size: 35,
                            color: textLight,
                          )),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:verbyl_project/pages/music_player.dart';
// import 'package:verbyl_project/pages/search.dart';
// import 'package:verbyl_project/theme.dart';
// import '../services/helpers.dart';
// import '../models/song.dart';
//
// class MiniMusicPlayer extends StatefulWidget {
//   const MiniMusicPlayer({Key? key}) : super(key: key);
//
//   @override
//   _MiniMusicPlayerState createState() => _MiniMusicPlayerState();
// }
//
// class _MiniMusicPlayerState extends State<MiniMusicPlayer> {
//   // bool isPlaying = true;
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return FutureBuilder(
//         future: Helpers().getData("liggi"),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             final _songs = snapshot.data as Songs;
//             String imageURL = _songs.data![0].album!.cover.toString();
//             return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (ctx) => MusicPlayer()));
//               },
//               child: Container(
//                 height: 80,
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.all(Radius.circular(15)),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(5.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         width: 10,
//                       ),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Hero(
//                           tag: "songImage",
//                           child: (imageURL != "null")
//                               ? Image.network(
//                                   imageURL,
//                                   height: 50,
//                                   width: 50,
//                                 )
//                               : Image.asset('assets/images/placeholder.png'),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 15,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             width: 0.5 * size.width,
//                             child: Text(
//                               _songs.data![0].title.toString(),
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.montserrat(
//                                   color: textLight, fontSize: 16),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               if (_songs.data![0].explicitLyrics == true)
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 5),
//                                   child: Container(
//                                     height: 14,
//                                     width: 14,
//                                     decoration: const BoxDecoration(
//                                       color: Colors.grey,
//                                       borderRadius: BorderRadius.all(
//                                         Radius.circular(2),
//                                       ),
//                                     ),
//                                     child: Center(
//                                         child: Text(
//                                       "E",
//                                       style: TextStyle(
//                                         fontSize: 9,
//                                         color: bgDark,
//                                       ),
//                                     )),
//                                   ),
//                                 )
//                               else
//                                 const SizedBox(),
//                               SizedBox(
//                                 width: 0.5 * size.width,
//                                 child: Text(
//                                     _songs.data![0].artist!.name.toString(),
//                                     overflow: TextOverflow.ellipsis,
//                                     style: GoogleFonts.montserrat(
//                                         color: Colors.grey, fontSize: 14)),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const Spacer(),
//                       isPlaying
//                           ? IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   isPlaying = false;
//                                 });
//                               },
//                               icon: Icon(
//                                 Icons.pause_rounded,
//                                 size: 35,
//                                 color: textLight,
//                               ))
//                           : IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   isPlaying = true;
//                                 });
//                               },
//                               icon: Icon(
//                                 Icons.play_arrow_rounded,
//                                 size: 35,
//                                 color: textLight,
//                               )),
//                       const SizedBox(
//                         width: 10,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }
//           return Container(
//             height: 80,
//             width: double.infinity,
//             decoration: const BoxDecoration(
//               color: Colors.black54,
//               borderRadius: BorderRadius.all(Radius.circular(15)),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Shimmer.fromColors(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         color: Colors.white,
//                         child: const Center(
//                             child: Icon(
//                           Icons.music_note_rounded,
//                           color: Colors.black,
//                         )),
//                       ),
//                     ),
//                     baseColor: Colors.grey,
//                     highlightColor: Colors.grey.shade600,
//                   ),
//                   const SizedBox(
//                     width: 20,
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Shimmer.fromColors(
//                         baseColor: Colors.grey,
//                         highlightColor: Colors.grey.shade600,
//                         child: Container(
//                           height: 10,
//                           width: 70,
//                           color: Colors.white,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Shimmer.fromColors(
//                         baseColor: Colors.grey,
//                         highlightColor: Colors.grey.shade600,
//                         child: Container(
//                           height: 10,
//                           width: 170,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   isPlaying
//                       ? IconButton(
//                           onPressed: () {
//                             setState(() {
//                               isPlaying = false;
//                             });
//                           },
//                           icon: Icon(
//                             Icons.pause_rounded,
//                             size: 35,
//                             color: textLight,
//                           ))
//                       : IconButton(
//                           onPressed: () {
//                             setState(() {
//                               isPlaying = true;
//                             });
//                           },
//                           icon: Icon(
//                             Icons.play_arrow_rounded,
//                             size: 35,
//                             color: textLight,
//                           )),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }

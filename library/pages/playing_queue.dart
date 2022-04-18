import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/models/charts.dart';
import 'package:verbyl_project/pages/song_card.dart';
import 'package:verbyl_project/theme.dart';
import '../models/song.dart';
import '../services/helpers.dart';
import 'mini_music_player.dart';

class PlayingQueuePage extends StatefulWidget {
  const PlayingQueuePage({Key? key}) : super(key: key);

  @override
  _PlayingQueuePageState createState() => _PlayingQueuePageState();
}

class _PlayingQueuePageState extends State<PlayingQueuePage> {
  late Map<dynamic, bool> songCheckBox = {};

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
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Playing Queue",
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
                          Colors.deepPurple.shade600,
                          Colors.purpleAccent.shade400,
                          Colors.purpleAccent.shade100,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ), //FlexibleSpaceBar
              expandedHeight: 240,
              backgroundColor: Colors.purpleAccent.shade400,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ), //<Widget>[]
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                      "NOW PLAYING",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: textLight,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Stack(
                    children: [
                      SongCard(
                        songs: player.queue.songs[player.queue.currentIndex],
                      ),
                      (player.isPlaying)
                          ? Positioned(
                              left: 20,
                              top: 15,
                              child: Container(
                                color: Colors.black54,
                                height: 50,
                                width: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                      "https://m.media-amazon.com/images/G/01/digital/music/player/web/sixteen_frame_equalizer_accent.gif"),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  (player.queue.songs.length != player.queue.currentIndex + 1)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            "UP NEXT",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: textLight,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "RECOMMENDED",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: textLight,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              TextButton(
                                onPressed: () {
                                  List<Datum> list = [];
                                  songCheckBox.forEach((key, value) {
                                    if (value) list.add(key);
                                  });
                                  setState(() {
                                    player.queue.addSongs(list);
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.purpleAccent.shade100),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "ADD",
                                      style: TextStyle(
                                        color: Colors.purpleAccent.shade100,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            (player.queue.songs.length != player.queue.currentIndex + 1)
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return SongCard(
                            songs: player.queue
                                .songs[player.queue.currentIndex + index + 1]);
                      },
                      childCount: (player.queue.songs.length == 1)
                          ? 0
                          : player.queue.songs.length -
                              player.queue.currentIndex -
                              1,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildListDelegate([
                      SizedBox(
                        child: FutureBuilder(
                            future: Helpers().getRecommendedSongs(
                                player.queue.songs[player.queue.currentIndex]
                                    .title
                                    .toString(),
                                player.queue.songs[player.queue.currentIndex]
                                    .artist!.name
                                    .toString()),
                            builder: (ctx, ss) {
                              if (ss.connectionState == ConnectionState.done &&
                                  ss.hasData) {
                                List<Datum?> list = ss.data as List<Datum?>;
                                for (var s in list) {
                                  songCheckBox.putIfAbsent(s, () => false);
                                }
                                // return ListView.builder(
                                //   itemBuilder: (context, index) {
                                //       return Row(
                                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //         children: [
                                //           RecommendedSongs(
                                //               shazamSongData: list[index]!
                                //           ),
                                //           Checkbox(value: false, onChanged: (){}),
                                //         ],
                                //       );
                                //     },
                                //     itemCount: list.length,
                                // );
                                return StatefulBuilder(builder:
                                    (BuildContext ctx,
                                        StateSetter setRecommendState) {
                                  return Column(
                                    children: songCheckBox.keys
                                        .map((e) => Theme(
                                              data: Theme.of(context).copyWith(
                                                unselectedWidgetColor:
                                                    textLight,
                                              ),
                                              child: CheckboxListTile(
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 25, 0),
                                                  title: RecSongCard(
                                                    songs: e,
                                                  ),
                                                  value: songCheckBox[e],
                                                  onChanged: (bool? value) {
                                                    setRecommendState(() {
                                                      songCheckBox[e] = value!;
                                                    });
                                                  }),
                                            ))
                                        .toList(),
                                  );
                                });
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: primary,
                                  ),
                                );
                              }
                            }),
                      ),
                    ]),
                  ),
                // : const SliverToBoxAdapter(child: SizedBox(),),
          ],
        ),
      ),
    );
  }
}

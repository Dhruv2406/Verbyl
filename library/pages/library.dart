import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/pages/artistPage.dart';
import 'package:verbyl_project/pages/liked_songs.dart';
import 'package:verbyl_project/pages/playlist.dart';
import 'package:verbyl_project/pages/recently_played.dart';
import 'package:verbyl_project/services/data.dart';
import '../models/general.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import '../services/helpers.dart';
import '../theme.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  bool isLoading = false, isClicked = false, isCorrect = false;

  TextEditingController dialogController = TextEditingController();
  showCreatePlaylistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgDark,
          title: Text(
            'Create a Playlist',
            style: GoogleFonts.montserrat(
              color: textLight,
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setModalState) {
              return SizedBox(
                height: 120,
                child: Column(
                  children: [
                    TextField(
                      style: GoogleFonts.montserrat(
                        color: textLight,
                      ),
                      controller: dialogController,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: textLight),
                        ),
                        hintText: "Enter Playlist Name",
                        hintStyle: GoogleFonts.montserrat(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(
                            'CANCEL',
                            style: GoogleFonts.montserrat(
                              color: textLight,
                            ),
                          ),
                          onPressed: () {
                            dialogController.clear();
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : isClicked
                                  ? const Icon(Icons.done)
                                  : Text(
                                      'OK',
                                      style: GoogleFonts.montserrat(
                                        color: textLight,
                                      ),
                                    ),
                          onPressed: () {
                            if(isClicked) return;
                            setModalState(() {
                              isLoading = true;
                            });
                            if(isLoading && mounted){
                              addUserPlaylists(
                                  uid.toString(),
                                  dialogController.text,
                                  DateTime.now()
                              ).then((value){
                                setModalState((){
                                  isLoading = false;
                                  isClicked = true;
                                  isCorrect = true;
                                  Navigator.of(context).pop();
                                });
                                Flushbar(
                                  flushbarPosition: FlushbarPosition.TOP,
                                  duration: const Duration(seconds: 3),
                                  flushbarStyle: FlushbarStyle.FLOATING,
                                  messageText: Text("Created new playlist named " + dialogController.text,
                                    style: GoogleFonts.montserrat(color: textLight),
                                  ),
                                  margin: const EdgeInsets.all(8),
                                  borderRadius: BorderRadius.circular(8),
                                  backgroundColor: flushBarDark,
                                  messageColor: textLight,
                                  icon: Icon(
                                    Icons.done_rounded,
                                    size: 28.0,
                                    color: Colors.green[400],
                                  ),
                                ).show(context);
                              });
                            }
                            // int index = userPlaylistDemo.indexWhere((element) => element.name == dialogController.text);
                            // if(index >= 0){
                            //   Navigator.pop(context);
                            //   Flushbar(
                            //     flushbarPosition: FlushbarPosition.TOP,
                            //     duration: const Duration(seconds: 3),
                            //     flushbarStyle: FlushbarStyle.FLOATING,
                            //     messageText: Text("Playlist already exists",
                            //       style: GoogleFonts.montserrat(color: textLight),
                            //     ),
                            //     margin: const EdgeInsets.all(8),
                            //     borderRadius: BorderRadius.circular(8),
                            //     backgroundColor: flushBarDark,
                            //     messageColor: textLight,
                            //     icon: Icon(
                            //       Icons.error,
                            //       size: 28.0,
                            //       color: Colors.red[400],
                            //     ),
                            //   ).show(context);
                            //   debugPrint("Playlist already exists");
                            // }
                            // else{
                            //   userPlaylistDemo.add(PlaylistDemo(name: dialogController.text,songs: []));
                            //   users[0].playlists++;
                            //   Navigator.pop(context);
                            //   Flushbar(
                            //     flushbarPosition: FlushbarPosition.TOP,
                            //     duration: const Duration(seconds: 3),
                            //     flushbarStyle: FlushbarStyle.FLOATING,
                            //     messageText: Text("Created new playlist named " + dialogController.text,
                            //       style: GoogleFonts.montserrat(color: textLight),
                            //     ),
                            //     margin: const EdgeInsets.all(8),
                            //     borderRadius: BorderRadius.circular(8),
                            //     backgroundColor: flushBarDark,
                            //     messageColor: textLight,
                            //     icon: Icon(
                            //       Icons.done_rounded,
                            //       size: 28.0,
                            //       color: Colors.green[400],
                            //     ),
                            //   ).show(context);
                            // }
                            debugPrint(dialogController.text);
                            dialogController.clear();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Your Library",
          style: GoogleFonts.montserrat(color: textLight),
        ),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint("Before sorting");
              for (var element in userPlaylistDemo) {
                debugPrint(element.name);
              }
              setState(() {
                userPlaylistDemo.sort((a, b) {
                  return a.name
                      .toString()
                      .toLowerCase()
                      .compareTo(b.name.toString().toLowerCase());
                });
              });
              debugPrint("After sorting");
              for (var element in userPlaylistDemo) {
                debugPrint(element.name);
              }
            },
            icon: Stack(
              children: [
                Icon(
                  Icons.sort_rounded,
                  color: textLight,
                ),
                Positioned(
                  right: -2,
                  bottom: 0,
                  child: Icon(
                    Icons.south_rounded,
                    color: textLight,
                    size: 15,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              showCreatePlaylistDialog(context);
            },
            icon: Icon(
              Icons.add,
              color: textLight,
            ),
          ),
        ],
      ),
      backgroundColor: bgDark,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    makeListCard(
                        title: "Liked\nSongs",
                        color: Colors.redAccent.shade400,
                        icon: const Icon(Icons.favorite_rounded),
                        func: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => LikedSongs(),
                              ));
                        }),
                    makeListCard(
                        title: "Recently\nPlayed",
                        color: Colors.blueAccent.shade400,
                        icon: const Icon(
                          Icons.history_rounded,
                        ),
                        func: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => RecentlyPlayed(),
                              ));
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder(
                future: getUserPlaylists(uid.toString()),
                builder: (ctx,ss){
                  if(ss.connectionState == ConnectionState.done){
                    print("Playlist length = " + playlist.length.toString());
                    return Column(
                      children: [
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: textLight,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemCount: playlist.length,
                            itemBuilder: (context, index) {
                              return makePlaylistCard(
                                plist: playlist[index],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  if(ss.hasError){
                    print(ss.error);
                    return const Center(child: CircularProgressIndicator(color: Colors.red,));
                  }
                  return Center(child: CircularProgressIndicator(color: primary,));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeListCard(
      {required String title,
      required Icon icon,
      required Color color,
      required Function() func}) {
    return GestureDetector(
      child: Container(
        height: 60,
        width: 0.45 * MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: color.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Icon(
                  icon.icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: textLight,
              ),
            ),
          ],
        ),
      ),
      onTap: func,
    );
  }

  Widget makePlaylistCard({required Playlist plist}) {
    String title = plist.name.toString();
    String creationDate = plist.creationDate.toString();
    Icon icon = const Icon(CupertinoIcons.music_note_list);
    Color color = Colors.purple.shade400;
    return GestureDetector(
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Icon(
                    icon.icon,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: textLight,
                    ),
                  ),
                  Text(creationDate,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    //remove playlist from user list
                    int index = userPlaylistDemo
                        .indexWhere((element) => element.name == title);
                    if (index >= 0) {
                      users[0].playlists--;
                      userPlaylistDemo.removeAt(index);
                      String msg = title + " removed from your playlists";
                      Flushbar(
                        duration: const Duration(seconds: 3),
                        flushbarPosition: FlushbarPosition.TOP,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        messageText: Text(
                          msg,
                          style: GoogleFonts.montserrat(color: textLight),
                        ),
                        margin: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: flushBarDark,
                        messageColor: textLight,
                        icon: Icon(
                          Icons.done_rounded,
                          size: 28.0,
                          color: Colors.green[400],
                        ),
                      ).show(context);
                      debugPrint(msg);
                    } else {
                      debugPrint("cant remove " + title + " from your playlists");
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.delete_outline_outlined,
                    color: textLight,
                  )),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (ctx) => PlaylistPage(
                  playlist: plist,
                )));
        debugPrint(title);
      },
    );
  }
}

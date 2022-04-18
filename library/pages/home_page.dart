import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/models/artist.dart';
import 'package:verbyl_project/my_events.dart';
import 'package:verbyl_project/pages/artistPage.dart';
import 'package:verbyl_project/pages/charts_page.dart';
import 'package:verbyl_project/pages/song_card.dart';
import 'package:verbyl_project/services/data.dart';
import 'package:verbyl_project/services/location.dart';
import '../main.dart';
import '../models/general.dart';
import '../models/song.dart';
import '../services/helpers.dart';
import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var email = "";
  bool loading = true;

  // Future<String> getData() async {
  //   debugPrint("user before await: ");
  //   var user = await magic.user.getMetadata();
  //   debugPrint("user : " + user.email.toString());
  //   email = user.email.toString();
  //   setState(() {
  //     userEmail = email;
  //     loading = false;
  //   });
  //   return email;
  // }

  @override
  void initState() {
    //fun2();
    super.initState();
  }

  void fun2() {
    int? lll = sss?.songs?.length;
    if (lll == null) {
      lll = 20;
      print("lll = null");
    }
    print("Data:");
    for (int i = 0; i < lll; ++i) {
      // ignore: avoid_print
      print("Chart song" + i.toString());
      print(sss?.songs?[i].data?.toString());
    }
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      getTopSongsByLocation(cityId.toString());
    });
    return;
  }
  @override
  Widget build(BuildContext context) {
    String greeting() {
      var hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Good morning';
      }
      if (hour < 17) {
        return 'Good afternoon';
      }
      return 'Good Evening';
    }
    print("verbylUserLocation" + verbylUserLocation);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: Scaffold(
          backgroundColor: bgDark,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: primary,
            elevation: 0.0,
            title: Text(greeting(), style: GoogleFonts.montserrat(fontSize: 20)),
            actions: [
              CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Text(
                  authenticationController.userEmail.isEmpty
                      ? "?"
                      : authenticationController.userEmail[0].toUpperCase(),
                  style: GoogleFonts.montserrat(color: textLight, fontSize: 20),
                ),
              ),
              const SizedBox(
                width: 20,
              )
              // IconButton(onPressed: () {
              //   //Navigator.push(context, MaterialPageRoute(builder: (ctx) => MyEvent()));
              // }, icon: Icon(CupertinoIcons.bell_solid,color: textLight,)),
            ],
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [primary, bgDark],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      showCharts(),
                      const SizedBox(
                        height: 10,
                      ),
                      showArtists(),
                      const SizedBox(
                        height: 10,
                      ),
                      (cityId != "0") ? SizedBox(
                        height: 450,
                        child: FutureBuilder(
                            future: getTopSongsByLocation(cityId),
                            builder: (ctx, ss) {
                              if (ss.hasData && ss.connectionState == ConnectionState.done) {
                                List<Datum> songList = ss.data as List<Datum>;
                                return Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "  Top Hits in " + verbylUserLocation.toString(),
                                        style: GoogleFonts.montserrat(
                                          color: textLight,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          return SongCard(songs: songList[index]);
                                        },
                                        itemCount: songList.length,
                                      ),
                                      height: 400,
                                    ),
                                  ],
                                );
                              }
                              if (ss.hasError) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: const SizedBox(),
                                );
                              }
                              return Align(
                                alignment: Alignment.topCenter,
                                child: const SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }),
                      ) : SizedBox(),
                      (uid != 0) ? FutureBuilder(
                          future: getUserFollowingArtists(),
                          builder: (ctx, ss) {
                            if (ss.hasData && ss.connectionState == ConnectionState.done) {
                              List<ArtistData> artistList = ss.data as List<ArtistData>;
                              if(artistList.isNotEmpty) return Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("  Artists you follow",
                                      style: GoogleFonts.montserrat(
                                        color: textLight,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        return ArtistCard(artist: artistList[index].data![0].artist!,);
                                      },
                                      itemCount: artistList.length,
                                    ),
                                    height: 400,
                                  ),
                                ],
                              );
                              return const SizedBox();
                            }
                            if (ss.hasError) {
                              return Align(
                                alignment: Alignment.topCenter,
                                child: const SizedBox(),
                              );
                            }
                            return Align(
                              alignment: Alignment.topCenter,
                              child: const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }) : SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ChartsDemo> topCharts = [
    ChartsDemo(title: "Top 20 India", country: "IN", color: Colors.blue),
    ChartsDemo(title: "Top 20 US", country: "US", color: Colors.orange),
    ChartsDemo(title: "Top 20 Canada", country: "CA", color: Colors.green),
  ];

  List<DemoArtist> topArtists = [
    DemoArtist(
        name: "DJ Snake",
        imageLink:
            "https://e-cdns-images.dzcdn.net/images/artist/02b4b508aa974d5f6e8348e2186dd49f/250x250-000000-80-0-0.jpg"),
    DemoArtist(
        name: "Dua Lipa",
        imageLink:
            "https://e-cdns-images.dzcdn.net/images/artist/e6a04d735093a46dcc8be197681d1199/250x250-000000-80-0-0.jpg"),
    DemoArtist(
        name: "Shawn Mendes",
        imageLink:
            "https://e-cdns-images.dzcdn.net/images/artist/9106de4de092ecb05ec8862d3415337d/250x250-000000-80-0-0.jpg"),
  ];

  Widget showCharts() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  Top Charts",
          style: GoogleFonts.montserrat(
            color: textLight,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 170,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topCharts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgDark.withOpacity(0.75),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            designChartImage(
                                country: topCharts[index].country.toString(),
                                index: index),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              topCharts[index].title.toString(),
                              style: GoogleFonts.montserrat(
                                color: textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => ChartsPage(
                                  countryCode:
                                      topCharts[index].country.toString(),
                                  color: topCharts[index].color,
                                )));
                  },
                );
              }),
        ),
      ],
    );
  }

  Widget designChartImage({required String country, required int index}) {
    List<Color> list = [Colors.blue, Colors.red, Colors.green];
    return Container(
      height: 100,
      width: 125,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(7.5)),
          gradient: LinearGradient(
            colors: [list[index], list[index]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Top 20",
            style: GoogleFonts.montserrat(
              color: textLight,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Divider(
            color: textLight,
            indent: 20,
            endIndent: 20,
            thickness: 1.5,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            country.toUpperCase(),
            style: GoogleFonts.montserrat(
              color: textLight,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget showArtists() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "  Top Artists",
          style: GoogleFonts.montserrat(
            color: textLight,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: topCharts.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Helpers()
                        .getArtistData(topArtists[index].name)
                        .then((value) => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => ArtistPage(
                                            artistData: value,
                                            i: index,
                                          )))
                            });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgDark.withOpacity(0.75),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        // boxShadow: const [
                        //   BoxShadow(
                        //     color: Colors.black54,
                        //     offset: Offset(
                        //       15.0,
                        //       15.0,
                        //     ),
                        //     blurRadius: 20.0,
                        //     spreadRadius: 0.0,
                        //   ), //BoxShadow
                        // ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Hero(
                                tag: Text("artist$index"),
                                child: Image.network(
                                  topArtists[index].imageLink,
                                  height: 125,
                                  width: 125,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              topArtists[index].name.toString(),
                              style: GoogleFonts.montserrat(
                                color: textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

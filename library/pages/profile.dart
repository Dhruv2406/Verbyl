import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:verbyl_project/authentication/setup_profile.dart';
import 'package:verbyl_project/models/general.dart';
import 'package:verbyl_project/services/data.dart';
import 'package:verbyl_project/services/location.dart';
import '../main.dart';
import '/authentication/login_email.dart';
import '../theme.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    getUserData(authenticationController.userEmail).then((value){
      debugPrint("Got user data from initState profile.dart");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgDark,
        title: Text(
          "Your Profile",
          style: GoogleFonts.montserrat(),
        ),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              //AuthenticationController ac = AuthenticationController(FirebaseAuth.instance);
              authenticationController.signOut().then((value){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginEmail()));
              });
            }, icon: Icon(Icons.logout,color: textLight,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 0.275 * size.height,
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade900.withOpacity(0.7),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/${users[0].avatarIndex}.png"),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SetupAvatar()));
                              setState(() {});
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                verbylUserName.toString(),
                                style: GoogleFonts.montserrat(
                                  color: textLight,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.mail_solid,
                                    color: textLight,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    verbylUserEmail.toString(),
                                    style: GoogleFonts.montserrat(
                                      color: textLight,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Icons.people_rounded,
                              //       color: Colors.purple.shade200,
                              //     ),
                              //     const SizedBox(
                              //       width: 5,
                              //     ),
                              //     Text(
                              //       users[0].followingArtists.toString(),
                              //       style: GoogleFonts.montserrat(
                              //         color: textLight,
                              //       ),
                              //     ),
                              //     const SizedBox(
                              //       width: 20,
                              //     ),
                              //     Icon(
                              //       Icons.queue_music_rounded,
                              //       color: Colors.purple.shade200,
                              //     ),
                              //     const SizedBox(
                              //       width: 5,
                              //     ),
                              //     Text(
                              //       users[0].playlists.toString(),
                              //       style: GoogleFonts.montserrat(
                              //         color: textLight,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FutureBuilder(
                        future: getLocation(),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                            var result = snapshot.data as StringAndBool;
                            var address = result.address;
                            if (result.isLocationDenied) {
                              return Container(
                                height: 80,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: bgDark,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "Location services are disabled",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.grey.shade400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: primary.withOpacity(0.6),
                                              borderRadius:
                                              const BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                            ),
                                            width: 60,
                                            height: 100,
                                            child: Icon(
                                              CupertinoIcons
                                                  .arrow_2_circlepath,
                                              color: textLight,
                                              size: 24,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: bgDark,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Your Location",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.grey.shade400,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          address.toString(),
                                          style: GoogleFonts.montserrat(
                                            color: textLight,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: primary.withOpacity(0.6),
                                            borderRadius:
                                            const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          width: 60,
                                          height: 100,
                                          child: Icon(
                                            CupertinoIcons.arrow_2_circlepath,
                                            color: textLight,
                                            size: 24,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: bgDark,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primary,
                              ),
                            ),
                          );
                        },
                      ),
                      // if(isLocationPermissionDenied) Container(
                      //   height: 80,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     color: bgDark,
                      //     borderRadius: const BorderRadius.all(
                      //       Radius.circular(15.0),
                      //     ),
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment:
                      //     MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.all(15.0),
                      //         child: Text(
                      //           "Location services are disabled",
                      //           style: GoogleFonts.montserrat(
                      //             color: Colors.grey.shade400,
                      //             fontSize: 16,
                      //           ),
                      //         ),
                      //       ),
                      //       GestureDetector(
                      //         onTap: () async {
                      //           setState(() {
                      //             getLocation().then((value){
                      //               verbylUserLocation = value.address;
                      //               isLocationPermissionDenied = value.isLocationDenied;
                      //             });
                      //           });
                      //         },
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Container(
                      //               decoration: BoxDecoration(
                      //                 color: primary.withOpacity(0.6),
                      //                 borderRadius:
                      //                 const BorderRadius.all(
                      //                   Radius.circular(10.0),
                      //                 ),
                      //               ),
                      //               width: 60,
                      //               height: 100,
                      //               child: Icon(
                      //                 CupertinoIcons
                      //                     .arrow_2_circlepath,
                      //                 color: textLight,
                      //                 size: 24,
                      //               )),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // if(verbylUserLocation.isNotEmpty) Container(
                      //   height: 80,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     color: bgDark,
                      //     borderRadius: const BorderRadius.all(
                      //       Radius.circular(15.0),
                      //     ),
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment:
                      //     MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.all(15.0),
                      //         child: Column(
                      //           mainAxisAlignment:
                      //           MainAxisAlignment.center,
                      //           crossAxisAlignment:
                      //           CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               "Your Location",
                      //               style: GoogleFonts.montserrat(
                      //                 color: Colors.grey.shade400,
                      //                 fontSize: 14,
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               height: 5,
                      //             ),
                      //             Text(
                      //               verbylUserLocation.toString(),
                      //               style: GoogleFonts.montserrat(
                      //                 color: textLight,
                      //                 fontSize: 18,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       GestureDetector(
                      //         onTap: () async {
                      //           setState(() {
                      //             getLocation().then((value){
                      //               verbylUserLocation = value.address;
                      //               isLocationPermissionDenied = value.isLocationDenied;
                      //             });
                      //           });
                      //         },
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Container(
                      //               decoration: BoxDecoration(
                      //                 color: primary.withOpacity(0.6),
                      //                 borderRadius:
                      //                 const BorderRadius.all(
                      //                   Radius.circular(10.0),
                      //                 ),
                      //               ),
                      //               width: 60,
                      //               height: 100,
                      //               child: Icon(
                      //                 CupertinoIcons.arrow_2_circlepath,
                      //                 color: textLight,
                      //                 size: 24,
                      //               )),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              FutureBuilder(
                future: getMoodStats(),
                  builder: (ctx,ss) {
                if(ss.hasData && ss.connectionState == ConnectionState.done){
                  List<int> list = ss.data as List<int>;
                  List<SongsDataMoods> songDataMoods = [
                    SongsDataMoods("Happy",list[0]),
                    SongsDataMoods("Energetic",list[1]),
                    SongsDataMoods("Calm",list[2]),
                    SongsDataMoods("Sad",list[3]),
                  ];
                  // for(int i=0; i<4; i++){
                  //   songDataMoods[i].numberOfSongs = list[i];
                  // }
                  List<charts.Series<SongsDataMoods,String>> series = [
                    charts.Series(
                      data: songDataMoods,
                      id: "Songs By Mood",
                      domainFn: (SongsDataMoods s, _) => s.mood,
                      measureFn: (SongsDataMoods s, _) => s.numberOfSongs,
                      colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
                    ),
                  ];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 0.3 * size.height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purple.shade200,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: charts.BarChart(series),
                      ),
                    ),
                  );
                }
                else if(ss.hasError) {
                  print(ss.error);
                  return Center(child: CircularProgressIndicator(color: Colors.red,));
                }
                return SizedBox();
              }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SongsDataMoods{
  final String mood;
  late final int numberOfSongs;
  SongsDataMoods(this.mood,this.numberOfSongs);
}

// TextButton(
// onPressed: () async {
// try {
// print("try");
// await magic.user.logout();
// debugPrint(await magic.user.isLoggedIn().toString());
// } catch (e) {
// debugPrint("Divyam Error : " + e.toString());
// }
// Navigator.pushReplacement(context,
// MaterialPageRoute(builder: (context) => const LoginEmail())
// );
// },
// child: Text("Logout")),

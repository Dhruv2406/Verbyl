import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/models/charts.dart';
import 'package:verbyl_project/pages/song_card.dart';
import 'package:verbyl_project/services/helpers.dart';

import '../theme.dart';
import 'mini_music_player.dart';

class ChartsPage extends StatefulWidget {
  String countryCode;
  Color? color;
  ChartsPage({Key? key, required this.countryCode,required this.color}) : super(key: key);

  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgDark,
        persistentFooterButtons: const [
          MiniMusicPlayer(),
        ],
        appBar: AppBar(
          backgroundColor: widget.color,
          title: Text("Top 20 Charts - " + widget.countryCode.toUpperCase().toString(),
            style: GoogleFonts.montserrat(),
          ),
        ),
        body: FutureBuilder(
          future: Helpers().getCharts(widget.countryCode, 20),
          builder: (ctx,ss){
            if(ss.connectionState == ConnectionState.done && ss.hasData){
              List<dynamic>? shazamSongData = ss.data as List?;
              debugPrint("RunTimeType = " + shazamSongData.runtimeType.toString());
              return ListView.builder(
                  itemCount: shazamSongData?.length,
                  itemBuilder: (ctx,i){
                    return ChartSongCard(shazamSongData: shazamSongData![i], index: i+1,);
                  });
            }
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}

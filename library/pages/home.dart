import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'mini_music_player.dart';
import '/theme.dart';
import 'home_page.dart';
import 'library.dart';
import 'profile.dart';
import 'search.dart';

int navBarIndex = 0;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgDark,
        body: buildBody(),
        bottomNavigationBar: buildBottomNavy(navIndex: navBarIndex),
        persistentFooterButtons: const [
          MiniMusicPlayer(),
        ],
      ),
    );
  }

  Widget buildBody(){
    switch (navBarIndex) {
      case 1 :
        return Search();
      case 2 :
        return Library();
      case 3 :
        return Profile();
      case 0 :
      default :
        return HomePage();
    }
  }

  Widget buildBottomNavy({required int navIndex}){
    navBarIndex = navIndex;
    const primary = Colors.purpleAccent;
    const inactiveColor = Colors.grey;
    return Stack(
      children: [
        BottomNavyBar(
          showElevation: false,
          backgroundColor: bgDark,
          selectedIndex: navBarIndex,
          onItemSelected: (index) => setState(() {
            navBarIndex = index;
          }),
          items: [
            BottomNavyBarItem(
              icon: const Icon(CupertinoIcons.house_fill),
              title: Text('Home',
                style: GoogleFonts.montserrat(color: primary),
              ),
              activeColor: primary,
              inactiveColor: inactiveColor.shade600,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              inactiveColor: inactiveColor.shade600,
              textAlign: TextAlign.center,
              icon: const Icon(CupertinoIcons.search),
              title: Text('Search',
                style: GoogleFonts.montserrat(color: primary),
              ),
              activeColor: primary,
            ),
            BottomNavyBarItem(
              inactiveColor: inactiveColor.shade600,
              textAlign: TextAlign.center,
              icon: const Icon(CupertinoIcons.music_albums_fill),
              title: Text('Library',
                style: GoogleFonts.montserrat(color: primary),
              ),
              activeColor: primary,
            ),
            BottomNavyBarItem(
              inactiveColor: inactiveColor.shade600,
              textAlign: TextAlign.center,
              icon: const Icon(CupertinoIcons.profile_circled),
              title: Text('Profile',
                style: GoogleFonts.montserrat(color: primary),
              ),
              activeColor: primary,
            ),
          ],
        ),
        const SizedBox(height: 10,),
      ],
    );
  }

}


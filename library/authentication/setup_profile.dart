import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbyl_project/authentication/validators.dart';
import 'package:verbyl_project/models/general.dart';
import 'package:verbyl_project/pages/profile.dart';
import 'package:verbyl_project/theme.dart';

import '../pages/home.dart';

int selectedAvatar = 1;

class SetupAvatar extends StatefulWidget {
  const SetupAvatar({Key? key}) : super(key: key);

  @override
  _SetupAvatarState createState() => _SetupAvatarState();
}

class _SetupAvatarState extends State<SetupAvatar> {
  TextEditingController nameController = TextEditingController();
  String name = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: bgDark,
          appBar: AppBar(
            backgroundColor: bgDark,
            elevation: 1.5,
            centerTitle: true,
            title: Text(
              "Choose your avatar",
              style: GoogleFonts.montserrat(
                color: textLight,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   child: Text(
                  //     "1. Enter your name",
                  //     style: GoogleFonts.montserrat(
                  //       fontSize: 20,
                  //       color: textLight,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 25,
                  // ),
                  // Center(
                  //   child: SizedBox(
                  //     height: 0.1 * size.height,
                  //     width: 0.85 * size.width,
                  //     child: TextField(
                  //       style: GoogleFonts.montserrat(color: textLight),
                  //       controller: nameController,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           name = value.trim();
                  //         });
                  //       },
                  //       decoration: InputDecoration(
                  //         border: OutlineInputBorder(
                  //             borderSide: BorderSide(color: textLight),
                  //             borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                  //         enabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: textLight),
                  //             borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                  //         errorBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: textLight),
                  //             borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                  //         focusedErrorBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: textLight),
                  //             borderRadius: const BorderRadius.all(Radius.circular(5.0))),
                  //         prefixIcon: const Padding(
                  //           padding: EdgeInsets.only(left: 20.0, right: 10.0),
                  //           child: Icon(
                  //             Icons.account_circle_outlined,
                  //             color: Color(0xfff2f2f2),
                  //           ),
                  //         ),
                  //         labelText: "Name",
                  //         labelStyle: GoogleFonts.montserrat(color: textLight),
                  //         errorStyle: GoogleFonts.montserrat(),
                  //         errorText: name.isNotEmpty ? NameValidator.validate(name) : "",
                  //       ),
                  //       // ignore: prefer_const_literals_to_create_immutables
                  //       autofillHints: [AutofillHints.name],
                  //       keyboardType: TextInputType.text,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   child: Text(
                  //     "2. Choose your Avatar",
                  //     style: GoogleFonts.montserrat(
                  //       fontSize: 20,
                  //       color: textLight,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      shrinkWrap: true,
                      children: List.generate(4, (index) {
                        return showAvatars(index: index + 1);
                      },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 56,
                        width: 0.4 * size.width,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: textLight.withOpacity(0.8),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel",
                            style: GoogleFonts.montserrat(
                              color: primary,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 56,
                        width: 0.4 * size.width,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: primary,
                          ),
                          onPressed: () async {
                            if(selectedAvatar >= 1 && selectedAvatar <= 4) {
                              setState(() {
                                //avatarIndex = selectedAvatar;
                                users[0].avatarIndex = selectedAvatar;
                              });
                              debugPrint("Avatar id: " + selectedAvatar.toString());
                              //save details to DB
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
                              setState(() {});
                            }
                          },
                          child: Text("Save Avatar",
                            style: GoogleFonts.montserrat(
                              color: textLight,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    ),
    );
  }
  
  Widget showAvatars({required int index}){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: (){
          setState(() {
            selectedAvatar = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.purple.shade900.withOpacity(0.7),
            border: (selectedAvatar == index) ? Border.all(
              color: textLight,
              width: 2.0,
            ) : null,
            borderRadius: const BorderRadius.all(Radius.circular(15.0),),
            image: DecorationImage(
              image: AssetImage("assets/images/$index.png"),
            ),
          ),
        ),
      ),
    );
  }

}

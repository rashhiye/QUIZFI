import 'package:flutter/material.dart';
import 'package:myapp/pages/about_us.dart';
import 'package:myapp/pages/client/joinroom.dart';
import 'package:myapp/pages/feedback.dart';
import 'package:myapp/pages/homepage.dart';
import 'package:myapp/pages/quickplay/generation.dart';
import 'package:myapp/pages/server/createroom.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/themes/dark.dart';
import 'package:flutter/services.dart';


class Menupage extends StatefulWidget {
  const Menupage({super.key});
  @override
  State<Menupage> createState() => _MenupageState();
}

class _MenupageState extends State<Menupage> {
  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  showAvatarSelectionPopup(BuildContext context) {
    int? code;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: bgColor,
              actionsAlignment: MainAxisAlignment.spaceAround,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                "Choose Your Avatar",
                style: TextStyle(
                  color: text,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Create 3 rows of avatars
                        for (int i = 0; i < 3; i++) ...[
                          // Row containing avatars
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int j = 1; j <= 3; j++) ...[
                          // Loop for columns
                              GestureDetector(
                                  onTap: () {
                              setState(() {
                                code = i * 3 + j;
                              });
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, // Circular shape
                                border: Border.all(
                                  color: (code == i * 3 + j)
                                      ? ltfg
                                      : Colors.transparent, // Border color
                                  width: 3.0, // Border width
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/avatar/${i * 3 + j}.png'), // Replace with your image path
                                  fit: BoxFit
                                      .cover, // Ensure the image covers the circle
                                ),
                              ),
                            ),
                          ),
                          if (j != 3)
                            SizedBox(
                              width: 10,
                            ),
                        ],
                      ],
                    ),
                    if (i != 3)
                      SizedBox(
                        height: 10,
                      ),
                  ],
                ],
              ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: fgColor,
                  ),
                  child: const Text("Back"),
                ),
                // OK button
                TextButton(
                  onPressed: () {
                    if (code != null) {
                      changeAvatar("$code");
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: text,
                  ),
                  child: const Text("Set Avatar"),
                ),
              ],
            );
          });
        }).then((_) {
      // This block executes after the popup is dismissed
      setState(() {}); // Refresh the UI
    });
  }

  void showRenamePopup(BuildContext context) {
    TextEditingController textController = TextEditingController();
    String status = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Use StatefulBuilder to trigger a rebuild only for the dialog.
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Rename"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          r'^[a-zA-Z]+$')), // Allow only alphabetic characters.
                    ],
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: "Enter new name",
                    ),
                  ),
                  Text(
                    status,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
              actions: [
                // Cancel button to dismiss the dialog
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text("Cancel"),
                ),
                // OK button
                TextButton(
                  onPressed: () {
                    if (textController.text.isEmpty) {
                      setState(() {
                        status =
                            "Please enter your name";
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          status = '';
                        });
                      });
                    } else {
                      // Proceed with renaming if the name is not empty
                      setState(() {
                        rename(textController.text
                            .toString()); // Call your rename logic here
                      });
                      Navigator.pop(
                          context); // Close the dialog after renaming.
                    }
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    Color col = fgColor;
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          toolbarHeight: 50,
          title: Row(
            children: [
              Text(
                "QuizFI",
                style: TextStyle(
                  fontSize: screenwidth * 0.075,
                  fontWeight: FontWeight.bold,
                  color: text,
                ),
              ),
            ],
          ),
          iconTheme: IconThemeData(color: text, size: screenwidth * 0.085),
        ),
        drawer: Drawer(
          backgroundColor: bgColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Smaller DrawerHeader
              SizedBox(
                height: 120, // Adjust the height here
                child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: fgColor,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(
                                'assets/images/avatar/${HomePage.avatar}.png'), // Replace with your logo path
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Welcome, ${HomePage.Name}', // Dynamic name
                                style: TextStyle(
                                  color: wht,
                                  fontSize: 18, // Adjust font size if needed
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Let\'s get started!',
                                style: TextStyle(
                                  color: wht,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ])),
              ),
              ListTile(
                leading: Icon(
                  Icons.face,
                  color: text,
                ),
                title: Text('Change Avatar',
                    style: TextStyle(
                      color: text,
                    )),
                onTap: () {
                  showAvatarSelectionPopup(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.brightness_4_rounded,
                  color: text,
                ),
                title: Text('Theme',
                    style: TextStyle(
                      color: text,
                    )),
                trailing: Switch(
                    value: HomePage.theme,
                    inactiveThumbColor: fgColor,
                    trackOutlineColor: WidgetStatePropertyAll(fgColor),
                    onChanged: (value) {
                      setState(() {
                        setTheme(value);
                        print(value);
                      });
                    }),
              ),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: text,
                ),
                title: Text('Rename',
                    style: TextStyle(
                      color: text,
                    )),
                onTap: () {
                  // Add navigation or other functionality here
                  showRenamePopup(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  color: text,
                ),
                title: Text('logout',
                    style: TextStyle(
                      color: text,
                    )),
                onTap: () {
                  showLogoutConfirmation(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.feedback_rounded,
                  color: text,
                ),
                title: Text('Support & Feedback',
                    style: TextStyle(
                      color: text,
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  SupportFeedbackPage())
                  ); // Add navigation or other functionality here
                  //Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info_outline_rounded,
                  color: text,
                ),
                title: Text('About us',
                    style: TextStyle(
                      color: text,
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => aboutus()),
                  ); // Add navigation or other functionality here
                  //Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  _buildCard(
                    context,
                    title: "QUICK PLAY!",
                    description:
                        "Enter Quick Play, choose a topic, and challenge an AI host in an \texciting and fun single-player quiz!",
                    buttonText: "PLAY NOW",
                    loc: 'assets/images/menu1.svg',
                    size: screenwidth * 0.00065,
                    bg: wht,
                    fg: col,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildCard(
                    context,
                    title: "CREATE ROOM",
                    description:
                       "Create your own quiz room,invite friends,and host thrilling real-time quizzes to test participants",
                         buttonText: "CREATE ROOM",
                    loc: 'assets/images/menu2.svg',
                    size: screenwidth * 0.00053,
                    bg: col,
                    fg: wht,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildCard(
                    context,
                    title: "JOIN ROOM",
                    description:
                          "Join a quiz room instantly, take on epic challenges, and compete with friends in live, real-time quizzes!",
                    buttonText: "JOIN A ROOM",
                    loc: 'assets/images/menu3.svg',
                    size: screenwidth * 0.00065,
                    bg: wht,
                    fg: col,
                  ),
                ],
              ),
            ])));
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonText,
    required String loc,
    required double size,
    required Color bg,
    required Color fg,
  }) {
    double screenwidth = MediaQuery.of(context).size.width;
    ;
    return Container(
      width: screenwidth * 0.9,
      
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: fg, width: 4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: screenwidth * 0.55,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenwidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: fg,
                    ),
                  ),
                  SizedBox(height: screenwidth * 0.01),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: screenwidth * 0.045, color: fg),
                  ),
                  SizedBox(height: screenwidth * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      if (buttonText == "PLAY NOW") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Quickplay()),
                        );
                      } else if (buttonText == "CREATE ROOM") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateRoomScreen()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Joinroom()),
                        );
                      }

                      // Button action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bg,
                      side: BorderSide(color: fg, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 24),
                    ),
                    child: Text(
                      buttonText,
                      style: TextStyle(color: fg, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset(
                loc,
                width: screenwidth * size,
                //height: screenheight * 0.1,
                alignment: Alignment.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

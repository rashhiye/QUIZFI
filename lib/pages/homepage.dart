import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myapp/pages/menupage.dart';
import 'package:myapp/themes/dark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
//comment itt vachath delete cheyyanda

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String Name = '';
  static String avatar = "";
  static bool theme = false;
  static late SharedPreferences prefs;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  String status = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPrefs();
  }

  initPrefs() async {
    HomePage.prefs = await SharedPreferences.getInstance();
    HomePage.Name = HomePage.prefs.getString('name')!;
    HomePage.avatar = HomePage.prefs.getString('avatar')!;
    HomePage.theme = HomePage.prefs.getBool('theme')!;
    if (HomePage.Name.isNotEmpty) {
      setTheme(HomePage.theme);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Menupage()));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: wht,
      body: Center(
        child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: screenheight * 0.2),
              SvgPicture.asset(
                'assets/images/lg.svg',
                width: screenwidth * 0.25,
                height: screenheight * 0.25,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 0.05),
              Container(
                child: Text(
                  "Create,share,and challenge \n your friends with quizzes anytime,\nanywhere!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Paul',
                      fontSize: screenwidth * 0.055,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: screenheight * 0.103),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[a-zA-Z]+$')), // Allows only letters
                  ],
                  controller: nameController,
                  decoration: const InputDecoration(
                      // labelText: "Enter your name",
                      label: Text("Enter your name"),
                      alignLabelWithHint: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 18.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.isEmpty) {
                        setState(() {
                          status = "Please enter your name";
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              status = '';
                            });
                          });
                        });
                        return;
                      }
                      await HomePage.prefs
                          .setString('name', nameController.text);
                      await HomePage.prefs.setString('avatar', "profile");
                      await HomePage.prefs.setBool('theme', false);
                      HomePage.avatar = "profile";
                      HomePage.Name = nameController.text;
                      HomePage.theme = false;
                      setTheme(false);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Menupage()));
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: fgColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Text("GET STARTED!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: wht,
                        ))),
              ),
              Text(
                status,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.red),
              ),
            ]),
      ),
    );
  }
}

logout() {
  HomePage.prefs.remove('name');
  HomePage.prefs.remove('avatar');
  HomePage.prefs.remove('theme');
}

rename(String str) {
  HomePage.prefs.setString('name', str);
  HomePage.Name = str;
}

changeAvatar(String str) {
  HomePage.prefs.setString('avatar', str);
  HomePage.avatar = str;
}

changeTheme(bool val) {
  HomePage.prefs.setBool('theme', val);
  HomePage.theme = val;
}

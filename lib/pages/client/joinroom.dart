import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:myapp/pages/client/waitingroom.dart';
import 'package:myapp/pages/loadingpage.dart';
import 'package:myapp/pages/homepage.dart';
import 'package:myapp/themes/dark.dart';

class Joinroom extends StatefulWidget {
  const Joinroom({super.key});
  static Socket? socket;
  static String pre = '';
  @override
  _JoinroomState createState() => _JoinroomState();
}

bool question = false;
String qus = 'NIL';

class _JoinroomState extends State<Joinroom> {
  final TextEditingController _ipController = TextEditingController();
  final int port = 3000;
  String status = '';
  bool join = true;

  Future<void> connectToServer() async {
    LoadingDialog.show(context);
    final info = NetworkInfo();
    String? ip = await info.getWifiIP();
    if (_ipController.text.split('.').length - 1 != 3) {
      setState(() {
        status = 'Incorrect ip address';
      });
    } else if (ip!.isEmpty || ip.substring(0, 3) == '100') {
      setState(() {
        status =
            'NETWORK ERROR: Ensure that your wifi is connected to the hostpot provided by the Quiz Master';
      });
    } else {
      try {
        Joinroom.socket = await Socket.connect(_ipController.text, port)
            .timeout(const Duration(seconds: 3));
        C_send('${HomePage.Name}:${HomePage.avatar}');
        startListening();
      } on TimeoutException catch (e) {
        Joinroom.socket?.destroy();
        setState(() {
          status =
              'Something went wrong. Check wether the quiz master host the room and try again.';
        });
        print(e);
      } catch (e) {
        Joinroom.socket?.destroy();
        setState(() {
          status = 'Something went wrong: $e';
        });
      }
    }
    LoadingDialog.hide(context);
    _ipController.clear();
    setState(() {});
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        status = '';
      });
    });
  }

  void startListening() {
    Joinroom.socket!.listen(
      (data) {
        final message = String.fromCharCodes(data).trim();
        if (join) {
          status = message;
          if (status == 'connected to server') {
            join = false;
            question = true;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Waitingroom(key: waitingRoomKey)),
            );
          }
        } else if (question) {
          qus = message;
          if (qus != 'NIL') {
            question = false;
          }
        }
      },
      onDone: () => LoadingDialog.restartApp(context),
      //onError: () =>LoadingDialog.restartApp(context) ,
    );
  }

  @override
  void dispose() {
    Joinroom.socket?.close();
    question = false;
    qus = 'NIL';
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    question = false;
    qus = 'NIL';
    join = true;
  }

  @override
  Widget build(BuildContext context) {
    Color col = fgColor;
    double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: col,
        elevation: 0,
        title: const Text(
          'Finding Room',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: wht,
        ),
      ),
      resizeToAvoidBottomInset:
          true, // Prevents overflow when the keyboard appears
      body: GestureDetector(
        onTap: () =>
            FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom:
                  MediaQuery.of(context).viewInsets.bottom, // Keyboard height
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Adjust height dynamically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/images/joinroom.svg',
                  semanticsLabel: 'Join Room Illustration',
                  width: screenwidth * 0.4,
                  height: screenwidth * 0.4,
                ),
                const SizedBox(height: 20),
                Text(
                  "Connect to the Quiz Master's Wi-Fi, then enter the IP address provided by the Quiz Master and join the room.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Paul',
                    fontSize: screenwidth * 0.055,
                    color: blk,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text("Note:If you go back while playing you will be removed from the game",style: TextStyle(fontSize: screenwidth * 0.03,color: blk),),
                const SizedBox(height: 20),
                TextField(
                  controller: _ipController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: wht,
                    hintText: 'Enter Server IP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await connectToServer();
                  },
                  child: Material(
                    color: Colors.transparent, // Make background transparent
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(30), // Define the border radius
                      splashColor: fgColor.withOpacity(0.3), // Splash color
                      onTap: () async {
                        await connectToServer();
                      },
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [fgColor, ltfg],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                              30), // Match the InkWell radius
                          boxShadow: [
                            BoxShadow(
                              color: fgColor.withOpacity(0.5),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          "JOIN",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron',
                            color: wht,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  status,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String C_receive() {
  question = true;
  return (qus);
}

void C_send(String message) {
  if (Joinroom.socket != null) {
    Joinroom.socket!.write(message);
  }
}

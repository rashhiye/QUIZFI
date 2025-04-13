import 'package:flutter/material.dart';
import 'package:myapp/pages/client/joinroom.dart';
import 'package:myapp/pages/client/clientplay.dart';
//import 'package:myapp/pages/menupage.dart';
import 'package:myapp/themes/dark.dart';
import 'package:myapp/pages/loadingpage.dart';
import 'package:back_pressed/back_pressed.dart';

final GlobalKey<_WaitingroomState> waitingRoomKey = GlobalKey();

class Waitingroom extends StatefulWidget {
  const Waitingroom({super.key});
  @override
  State<Waitingroom> createState() => _WaitingroomState();
}

class _WaitingroomState extends State<Waitingroom> {
  String data = '';
  fetchQus() async {
    String qus = ' ';
    while (qus[0] != 'Q' || Joinroom.pre == qus) {
      await Future.delayed(const Duration(seconds: 1));
      qus = C_receive();
      setState(() {
        data = "${Joinroom.pre.split('\n').first} \n ${qus.split('\n').first}";
      });
      if (qus[0] == 'Q' && Joinroom.pre != qus) {
        Joinroom.pre = qus;
        List<String> s = qus.split('|');
        String quse = s[0].substring(1, s[0].length);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Question(
                  strr: quse, size: int.parse(s[1]), d: int.parse(s[2]))),
        );
        return;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchQus();
  }

  @override
  Widget build(BuildContext context) {
    return OnBackPressed(
        perform: () {
          LoadingDialog.exitConfirmation(context);
        },
        child: Scaffold(
          backgroundColor: bgColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Circular Progress Indicator
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                  strokeWidth: 6.0,
                ),
                const SizedBox(height: 20),
                // Descriptive Text
                Text(
                  'Waiting for quiz master to start quiz',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: fgColor,
                  ),
                ),
                const SizedBox(height: 50),
                // Animated Quiz Icon
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    'https://img.icons8.com/ios/100/000000/quiz.png', // Example quiz icon
                    color: fgColor,
                  ),
                ),
                // Text(data,
                //     textAlign: TextAlign.left,
                //     style: TextStyle(color: Colors.red))
              ],
            ),
          ),
        ));
  }
}

void triggerFetchQus() {
  if (waitingRoomKey.currentState != null) {
    waitingRoomKey.currentState!.fetchQus();
  }
}

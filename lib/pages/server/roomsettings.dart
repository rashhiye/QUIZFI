import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:animated_toggle/animated_toggle.dart';
import 'package:myapp/pages/loadingpage.dart';
import 'package:myapp/pages/server/createroom.dart';
import 'package:myapp/themes/dark.dart';
import 'package:myapp/pages/client/clientscore.dart';
import 'package:myapp/pages/server/progresslist.dart';

class Roomsettings extends StatefulWidget {
  const Roomsettings({super.key});
  static int totalqus = 0;
  @override
  State<Roomsettings> createState() => _RoomsettingsState();
}

class _RoomsettingsState extends State<Roomsettings> {
  String _selectedDifficulty = 'Easy';
  final List<String> _difficulty = ['Easy', 'Medium', 'Hard'];
  final List<int> _NQuestions =
      List<int>.from(Iterable<int>.generate(10, (index) => index + 1));
  String? _selectedQuestions = '1';
  int _selectedduration = 10;
  final List<String> _duration = ['5', '10', '15', '20'];

  final TextEditingController _content = TextEditingController();
  String str =
      '1: Question 1?\nA. BoptionA\nB. 1optionB\nC. 1optionC\nD. 1optionD\nAnswer: D\n\n2: Question2?\nA. 2optionA\nB. 2optionB\nC. 2optionC\nD. 2optionD\nAnswer: C\n\n3: Question3?\nA. 3optionA\nB. 3optionB\nC. 3optionC\nD. 3optionD\nAnswer: A\n\n4: Question 4?\nA. 4optionA\nB. 4optionB\nC. 4optionC\nD. 4optionD\nAnswer: B\n\n5: Question 5?\nA. 5optionA\nB. 5optionB\nC. 5optionC\nD. 5optionD\nAnswer: D';
      final ourUrl ="https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyDuB9rSKCnjUDhnHZYXS6BBgA8X9miIMiY";  
  final header = {'Content-Type': 'application/json'};

  getData() async {
    LoadingDialog.show(context);
    if (_content.text == '') {
      LoadingDialog.hide(context);
      LoadingDialog.error(context,
          err: "Quiz generation is not possible without topic");
      return;
    }
    var data = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Write $_selectedQuestions $_selectedDifficulty quiz questions about ${_content.text}\nIn the given format\n[Question no]:[Question]\nA. [option a]\nB. [option b]\nC. [option c]\nD. [option d]\nAnswer: [answer option (A,B,C,D)]"
            }
          ]
        }
      ]
    };
    print(data);
    await http
        .post(Uri.parse(ourUrl), headers: header, body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result["candidates"][0]["content"]["parts"][0]["text"]);
        str = result["candidates"][0]["content"]["parts"][0]["text"];
        if (str == '' || !str.contains("1:")) {
          LoadingDialog.hide(context);
          if (str.contains("1"))
            LoadingDialog.error(context,
                err: "Question generation failed.try again after some time");
          else
            LoadingDialog.error(context,
                err:
                    "Question generation failed.try again after some time\n$str");
        } else if (["$_selectedQuestions:", "A.", "B.", "C.", "D."]
            .every((sub) => str.contains(sub))) {
          LoadingDialog.hide(context);
          int index = str.indexOf("1:");
          String strr =index != -1 ? str.substring(index) : "";

          Roomsettings.totalqus = int.parse(_selectedQuestions ?? "1");
          S_send('Q$strr|${_selectedQuestions ?? "1"}|$_selectedduration');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Progress(),
              ));
        } else {
          LoadingDialog.hide(context);
          LoadingDialog.error(context,
              err:
                  "something went wrong in question generation. try again after some time");
        }
      } else {
        print("Error occurred");
      }
    }).catchError((e) {
      LoadingDialog.hide(context);
      List<String> msg = e.toString().split(" ");
      if (msg[0] == "ClientException") {
        LoadingDialog.error(context,
            err:
                "Network Eror \nUnable generate question due to poor network. Check the internet connectivity and try again");
      } else {
        LoadingDialog.error(context, err: e.toString());
      }
    });
    setState(() {});
  }

  fetchScore() async {
    String sc = '';
    while (sc == '') {
      await Future.delayed(const Duration(seconds: 1));
      sc = S_receive();
      print(score);
      if (score != '') {
        List<String> score = sc.split(':');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScoreBoardScreen(scores: score)),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color col = fgColor;
    return Scaffold(
      backgroundColor: bgColor, // Light purple background
      appBar: AppBar(
        backgroundColor: col, // Make AppBar transparent
        elevation: 0, // Remove shadow
        title: const Text('Room Settings',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: wht, // Set the color of the back button
        ),
        // Title text
      ),
      body: PopScope(
        onPopInvoked: (bool result) async {
          resume();
        },
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: <Widget>[
            const SizedBox(height: 15),
            Text("Topic",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: fgColor)),
            const SizedBox(height: 8),
            TextField(
              controller: _content,
              decoration: InputDecoration(
                hintText: 'Enter The Topic',
                hintStyle: TextStyle(
                  color: ltfg,
                  fontSize: 16,
                ),
                filled: true, // Enable filling for the background color
                fillColor: wht, // Background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: ltfg, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text("Difficulty",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: fgColor)),
            Center(
              child: AnimatedHorizontalToggle(
                taps: _difficulty,
                width: MediaQuery.of(context).size.width - 40,
                height: 45,
                duration: const Duration(milliseconds: 100),
                activeColor: fgColor,
                background: ltfg,
                inActiveTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                activeVerticalPadding: 4,
                activeHorizontalPadding: 4,
                onChange: (currentIndex, targetIndex) {
                  setState(() {
                    _selectedDifficulty = _difficulty[currentIndex];
                  });
                },
              ),
            ),
            const SizedBox(height: 30),

            // Number of Players Dropdown
            Text("No. of Question",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: fgColor)),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true, // Enable filling for the background color
                fillColor: wht, // Background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: ltfg, width: 2),
                ),
              ),
              hint: Text('Choose No of Question',
                  style: TextStyle(
                    color: fgColor,
                  )),
              value: _selectedQuestions,
              items: _NQuestions.map((num) {
                return DropdownMenuItem(
                    value: num.toString(), child: Text(num.toString()));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedQuestions = value;
                });
              },
            ),
            const SizedBox(height: 30),
            Text("Question duration",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: fgColor)),
            Center(
              child: AnimatedHorizontalToggle(
                initialIndex: 1,
                taps: _duration,
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                duration: const Duration(milliseconds: 100),
                activeColor: fgColor,
                background: ltfg,
                inActiveTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: wht,
                ),
                activeVerticalPadding: 4,
                activeHorizontalPadding: 4,
                onChange: (currentIndex, targetIndex) {
                  setState(() {
                    _selectedduration = int.parse(_duration[currentIndex]);
                    print(_selectedduration);
                  });
                },
              ),
            ),
            const SizedBox(height: 50),
            Center(
                child: GestureDetector(
              onTap: () async {
                if (CreateRoomScreen.clients.isNotEmpty) {
                  await getData();
                } else {
                  LoadingDialog.error(context,
                      err:
                          "There is no players. You cant start game without players.");
                }
              },
              child: Container(
                width: 200,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [fgColor, ltfg],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: fgColor.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  "START",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Orbitron',
                    color: wht,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

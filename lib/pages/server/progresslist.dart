import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; //sc
import 'package:screenshot/screenshot.dart'; //sc
import 'package:share_plus/share_plus.dart'; //scimport 'package:flutter/material.dart';
import 'package:myapp/pages/loadingpage.dart';
import 'package:myapp/pages/server/roomsettings.dart';
import 'hive_manager.dart';
import 'package:myapp/themes/dark.dart';
import 'package:back_pressed/back_pressed.dart';

// import 'package:myapp/pages/server/createroom.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});
  static List<String> score = [];
  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  ScreenshotController screenshotController = ScreenshotController();
  String status = '';
  String data = '';
  String ip = '';
  List<Player> _players = [];
  List<Player> test = [];
  bool _isProcessing = false;
  void fetchScores() async {
    while (!HiveManager.checkback()) {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isProcessing && Progress.score.isNotEmpty) {
        _isProcessing = true;
        processScores();
      } else {
        refreshPlayerList();
      }
    }
  }

  void processScores() async {
    while (Progress.score.isNotEmpty) {
      String sc = Progress.score.removeAt(0);
      List<String> score = sc.split(':');
      final playerIndex =
          _players.indexWhere((player) => player.ip == score[5].trim());
      setState(() async {
        data = await HiveManager.updatePlayerScore(playerIndex, sc);
        refreshPlayerList();
      });
    }
    _isProcessing = false;
  }

  void refreshPlayerList() {
    setState(() {
      _players = HiveManager.getAllPlayers();
      test = List.from(_players);
      test.sort((a, b) => b.point.compareTo(a.point));
    });
  }

  Future<void> takeScreenshotAndShare() async {
    //sc function
    final Uint8List? image = await screenshotController.capture();
    if (image == null) return;

    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/screenshot.png';
    final File file = File(filePath);
    await file.writeAsBytes(image);

    Share.shareXFiles([XFile(filePath)], text: "Congratulation Winners.Check out your rank");
  }

  @override
  void initState() {
    super.initState();
    Progress.score.clear();
    refreshPlayerList();
    HiveManager.initPlayers();
    fetchScores();
  }

  @override
  void dispose() {
    super.dispose();
    HiveManager.initPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return OnBackPressed(
        perform: () {
          if (HiveManager.checkback()) {
            Navigator.pop(context);
            Roomsettings.totalqus = 0;
          } else {
            LoadingDialog.backConfirmation(context);
          }
        },
        child: Scaffold(
          body: Screenshot(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [bgColor.withBlue(bgColor.blue - 2), bgColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child:Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Leaderboard",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: fgColor,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: test.length,
                        itemBuilder: (context, index) {
                          return Card(
                              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              color: Colors.blue[50],
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                      'assets/images/avatar/${test[index].avatar}.png'),
                                ),
                                title: Row(children: [
                                  Text(
                                    test[index].name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Score: ${test[index].point}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ]),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "correct:${test[index].correct.toString()} ",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    Text(
                                      "wrong:${test[index].wrong.toString()} ",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    Text(
                                      "skip:${test[index].skip.toString()} ",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                    Text(
                                      "time:${test[index].time.toString()}",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              controller: screenshotController
            ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              takeScreenshotAndShare();
            },
            child: Icon(
              Icons.share,
              size: 20,
            ),
          ),
        ));
  }
}

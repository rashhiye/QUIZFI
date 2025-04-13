import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:http/http.dart';
import 'package:myapp/pages/loadingpage.dart';
import 'package:myapp/pages/server/roomsettings.dart';
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:myapp/themes/dark.dart';
import 'package:myapp/pages/server/hive_manager.dart';
import 'package:myapp/pages/server/progresslist.dart';

bool _isListening = false;

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});
  static ServerSocket? _serverSocket;
  static final List<Socket> clients = [];
  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

bool sc = false;
String score = '';

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  TextEditingController ipc = TextEditingController();
  String status = '';
  bool start = true;
  bool add = true;
  String? ip = '';
  final int port = 3000;
  List<Player> _players = [];

  Future<void> startServer() async {
    try {
      await getLocalIpAddress();
      CreateRoomScreen._serverSocket = await ServerSocket.bind(ip, port);
      startListening();
    } catch (e) {
      setState(() {
        status = 'Could not start server: $e';
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            status = '';
          });
        });
      });
    }
  }

  /// Refresh player list from the database
  void refreshPlayerList() {
    setState(() {
      _players = HiveManager.getAllPlayers();
    });
  }

  void startListening() {
    if (CreateRoomScreen._serverSocket == null) return;
    _isListening = true;
    //status=await HiveManager.addPlayer('deva:1', '192.168.1.1');
    CreateRoomScreen._serverSocket!.listen((client) {
      if (_isListening) {
        CreateRoomScreen.clients.add(client);
        client.listen(
          (data) {
            final message = String.fromCharCodes(data).trim();
            if (_isListening && RegExp(r'^[a-zA-Z]').hasMatch(message[0])) {
              setState(() async {
                await HiveManager.addPlayer(
                    message, client.remoteAddress.address.toString()); //status
                refreshPlayerList();
              });
              //int playerIndex = CreateRoomScreen._clients.indexOf(client);
              //HiveManager.addMessage(playerIndex, message).then((_) {
              //  refreshPlayerList(); // Refresh UI after updating messages
              // });
              client.write('connected to server');
            } else {
              Progress.score.add(message);
            }
            // } else {
            //   status = 'Game started ,No entry';
            //   setState(() {});
            //   Future.delayed(Duration(seconds: 2), () {
            //     setState(() {
            //       status = '';
            //     });
            //   });
            // }
          },
          onError: (error) {
            setState(() {
              CreateRoomScreen.clients.remove(client);
              HiveManager.deletePlayer(client.remoteAddress.address.toString());
              status = 'Error: $error';
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  status = '';
                  refreshPlayerList();
                });
              });
            });
          },
          onDone: () {
            setState(() async {
              if (client.remoteAddress.address.isNotEmpty) {
                await HiveManager.deletePlayer(//status
                    client.remoteAddress.address.toString());
                CreateRoomScreen.clients.remove(client);
                refreshPlayerList();
                // Future.delayed(const Duration(seconds: 2), () {
                //   setState(() {
                //     status = '';
                //   });
                // });
              }
            });
          },
        );
      }
    });
    setState(() {});
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        status = '';
      });
    });
  }

  Future<void> getLocalIpAddress() async {
    final info = NetworkInfo();
    ip = await info.getWifiIP();
    setState(() {
      ipc.text = ip.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _isListening = false;
    _players.clear();
    Roomsettings.totalqus = 0;
    databaseinit();
    startServer();
  }

  void databaseinit() async {
    await HiveManager.initHive(); //status
    await HiveManager.clearDatabase();
    refreshPlayerList();
  }

  @override
  void dispose() {
    super.dispose();
    CreateRoomScreen._serverSocket?.close();
    for (var client in CreateRoomScreen.clients) {
      client.destroy();
    }
    HiveManager.clearDatabase();
    _isListening = false;
    _players.clear();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Enable your hotspot to allow players to connect. And use this id to join ",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: screenwidth * 0.055,
                  fontFamily: 'Paul',
                  fontWeight: FontWeight.w600,
                  color: blk),
            ),
          ),

          SizedBox(
            height: screenheight * 0.075,
            width: screenwidth - 20,
            child: Text(
              ip.toString(),
              style: TextStyle(
                fontSize: screenwidth * 0.07,
                fontWeight: FontWeight.w600,
                color: col,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Text(
          //   status,
          //   textAlign: TextAlign.left,
          //   style: const TextStyle(color: Colors.red),
          // ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: wht,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header for the Player List
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      gradient: LinearGradient(
                        colors: [fgColor, ltfg],
                      ),
                    ),
                    child: Text(
                      "players  Information",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: wht,
                        fontFamily: 'Paul',
                      ),
                    ),
                  ),
                  // Scrollable List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: _players.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 10,
                              backgroundImage: AssetImage(
                                  'assets/images/avatar/${_players[index].avatar}.png'), // Replace with your logo path
                            ),
                            title: Text(
                              "${_players[index].name} :  ${_players[index].ip}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: fgColor,
                              ),
                            ),
                            trailing: IconButton(
                                icon: const Icon(
                                    Icons.person_remove_alt_1_rounded),
                                iconSize: 15.0, // Size of the icon
                                color: Colors.red, // Color of the icon
                                tooltip:
                                    'Close', // Tooltip on hover or long press
                                onPressed: () {
                                  for (var client in CreateRoomScreen.clients) {
                                    if (client.remoteAddress.address ==
                                        _players[index].ip) {
                                      setState(() async {
                                        await HiveManager.deletePlayer(//status
                                            client.remoteAddress.address
                                                .toString());
                                        //status ="Removed ${_players[index].name} (${_players[index].ip})";
                                        refreshPlayerList();
                                      });
                                      CreateRoomScreen.clients.remove(client);
                                      client.destroy();
                                      break;
                                    }
                                  }
                                  //CreateRoomScreen._clients.remove(_players[index]);
                                }),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Start Button
          GestureDetector(
            onTap: () {
              _isListening = false;
              if (CreateRoomScreen.clients.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Roomsettings()),
                );
              } else {
                LoadingDialog.error(context,
                    err:
                        "There is no players. You can't start game without players.");
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
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

void S_send(String msg) {
  for (var client in CreateRoomScreen.clients) {
    client.write(msg);
  }
}

String S_receive() {
  sc = true;
  return (score);
}

void resume() {
  print('resume');
  if (CreateRoomScreen._serverSocket != null && !_isListening) {
    _isListening = true;
  }
}

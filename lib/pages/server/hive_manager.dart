//import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/pages/server/roomsettings.dart';

part 'hive_manager.g.dart';

@HiveType(typeId: 0)
class Player extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String ip;

  @HiveField(2)
  late String? avatar;

  @HiveField(3)
  late int correct;

  @HiveField(4)
  late int wrong;

  @HiveField(5)
  late int skip;

  @HiveField(6)
  late double time;

  @HiveField(7)
  late double point;

  Player(
      {required this.name,
      required this.ip,
      required this.avatar,
      this.correct = 0,
      this.wrong = 0,
      this.skip = 0,
      this.time = 0,
      this.point = 0});
}

class HiveManager {
  static const String _boxName = 'players';
  bool isInitialized = false;

  static Future<String> initHive() async {
    try {
      if (Hive.isBoxOpen(_boxName)) return "already init";
      await Hive.initFlutter();
      Hive.registerAdapter(PlayerAdapter());
      await Hive.openBox<Player>(_boxName);
      return "Hive initialized successfully.";
    } catch (e) {
      return "Hive initialization failed: $e";
    }
  }

  static Future<String> addPlayer(String msg, String ip) async {
    List<String> info = msg.split(':');
    try {
      final box = Hive.box<Player>(_boxName);
      final player = Player(name: info[0], ip: ip, avatar: info[1]);
      await box.add(player);
      return "${info[0]} added";
    } catch (e) {
      return " $e failed to add ${info[0]} ..${info[1]}";
    }
  }

  static Future<String> deletePlayer(String ip) async {
    final box = Hive.isBoxOpen(_boxName) ? Hive.box<Player>(_boxName) : null;
    if (box == null) {
      return ('Box "$_boxName" is not open.');
    }
    // Find the player with the matching IP
    final keyToDelete = box.keys.firstWhere(
      (key) => box.get(key)?.ip == ip,
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await box.delete(keyToDelete).onError((error, stackTrace) {
        return error.toString();
      }); // Delete the player
      return ('Player with IP "$ip" has been removed.');
    } else {
      return ('No player found with IP "$ip".');
    }
  }

  static List<Player> getAllPlayers() {
    final box = Hive.isBoxOpen(_boxName) ? Hive.box<Player>(_boxName) : null;
    if (box == null) {
      print('Box "$_boxName" is not open.');
      return [];
    }
    return box.values.toList();
    //return box.values.map((player) => {'name': player.name, 'ip': player.ip}).toList();
  }

  static void initPlayers() {
    final box = Hive.isBoxOpen(_boxName) ? Hive.box<Player>(_boxName) : null;
    if (box == null) {
      print('Box "$_boxName" is not open.');
    } else {
      List<Player> players = box.values.toList();
      for (Player player in players) {
        player.point = 0.0;
        player.correct = 0;
        player.wrong = 0;
        player.skip = 0;
        player.time = 0;
        player.save();
      }
    }
    //return box.values.map((player) => {'name': player.name, 'ip': player.ip}).toList();
  }

  static String pre = '';
  static Future<String> updatePlayerScore(int index, String sc) async {
    if (pre == sc) {
      return 'repeat';
    }
    try {
      pre = sc;
      List<String> score = sc.split(':');
      final box = Hive.box<Player>(_boxName);
      final player = box.getAt(index);
      if (player != null) {
        try {
          int d = int.parse(score[0].trim());
          player.correct = int.parse(score[1].trim());
          player.wrong = int.parse(score[2].trim());
          player.skip = int.parse(score[3].trim());
          player.time = double.parse(score[4].trim());
          int n = player.correct + player.wrong + player.skip;
          double pt = (((player.correct * 1 - player.wrong * 0.25) *
                      (d * n - player.time)) *
                  100) /
              (n * d * n);
          player.point = double.parse(pt.toStringAsFixed(1));
          await player.save();
          return ("added $score to $index"); // Save the updated player back to the database
        } catch (e) {
          return e.toString();
        }
      }
    } catch (e) {
      return e.toString();
    }
    return "failed";
  }

  //static Future<void> addMessage(int playerIndex, String message) async {
  //final box = Hive.box<Player>(_boxName);
  // final player = box.getAt(playerIndex);
  //if (player != null) {
  // player.messages.add(message); // Add the message to the player's list
  // await player.save(); // Save changes to the database
  // } else {
  //   print('Player not found at index $playerIndex');
  // }
//}
  static bool checkback() {
    final box = Hive.isBoxOpen(_boxName) ? Hive.box<Player>(_boxName) : null;
    for (Player player in box!.values.toList()) {
      if (player.correct + player.wrong + player.skip !=
          Roomsettings.totalqus) {
        print(
            "${player.correct},${player.wrong},${player.wrong},${Roomsettings.totalqus}");
        return false;
      }
    }
    return true;
  }

  static Future<void> clearDatabase() async {
    if (Hive.isBoxOpen(_boxName)) {
      final box = Hive.box<Player>(_boxName);
      await box.clear();
      print("database cleared");
    } else {
      print('Box "$_boxName" is not open, cannot clear.');
    }
  }
}

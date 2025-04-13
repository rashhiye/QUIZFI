import 'package:flutter/material.dart';
import 'package:myapp/pages/loadingpage.dart';
import 'package:myapp/pages/quickplay/singlescore.dart';
import 'package:myapp/themes/dark.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'dart:async';

class option {
  String opt = '';
  bool iscorret = false;
  Color co = wht;
  option({required this.opt});
}

class Data {
  String quse = '';
  option a;
  option b;
  option c;
  option d;
  Data(
      {required this.quse,
      required this.a,
      required this.b,
      required this.c,
      required this.d});
}

class Question extends StatefulWidget {
  final String strr;
  final int size;
  final int duration;
  const Question(
      {super.key,
      required this.strr,
      required this.size,
      required this.duration});
  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  String _message = '';
  late String str;
  late int n;
  late int _duration;
  List<Data> da = [];
  List<option> o = [];
  int countT = 0;
  int countF = 0;
  int skipped = 0;
  int q = -1;
  String skip = "skip";
  final CountDownController _controller = CountDownController();
  late Timer _timer;
  double _elapsedseconds = 0; // Tracks elapsed time in seconds
  bool _isRunning = false; // Tracks whether the timer is running
  bool _isPaused = false; // Tracks whether the timer is paused

  void _startTimer() {
    if (!_isRunning) {
      _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        if (!_isPaused) {
          setState(() {
            _elapsedseconds += 0.01;
          });
        }
      });
      setState(() {
        _isRunning = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //if (str == '') Navigator.pop(context);
    str = widget.strr;
    n = widget.size;
    _duration = widget.duration;
    cut();
    //create();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void cut() {
    List<String> st = str.split(RegExp('\n'));
    int a = 0, b = 1, c = 0; //a=line no,b=question no,c=option no
    String q = '', ans;
    try {
      while (b <= n) {
        if (st[a][0] == b.toString()) {
          c = 0;
          o.clear();
          while (c < 6) {
            if (c == 0) {
              q = st[a].substring(3, st[a].length);
              print(q);
            } else if (c < 5) {
              o.add(option(opt: st[a].substring(3, st[a].length)));
              print(o[c - 1].opt);
            } else {
              ans = st[a].substring(8, st[a].length);
              switch (ans) {
                case 'A':
                  o[0].iscorret = true;
                  print("a");
                case 'B':
                  o[1].iscorret = true;
                  print("b");
                case 'C':
                  o[2].iscorret = true;
                  print("c");
                case 'D':
                  o[3].iscorret = true;
                  print("d");
              }
            }
            c++;
            a++;
          }
          a++;
        }
        da.add(
          Data(quse: q, a: o[0], b: o[1], c: o[2], d: o[3]),
        );
        b++;
      }
      print("finish");
      _startTimer();
      create();
    } catch (e) {
      print(e);
      Navigator.pop(context);
      //LoadingDialog.error(context, err: e.toString());
    }
  }

  void create() {
    _controller.restart(duration: _duration);
    q++;
    if (q == n - 1) {
      skip = "finish";
    }
    if (q < n) {
      setState(() {
        _message = da[q].quse;
      });
    } else {
      q--;
      _isRunning = false;
      print(_elapsedseconds.toStringAsFixed(1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ScoreBoardScreen(
                  scores: [
                    (n).toString(),
                    _duration.toString(),
                    countT.toString(),
                    countF.toString(),
                    skipped.toString(),
                    _elapsedseconds.toStringAsFixed(1)
                  ],
                )),
      );
    }
  }

  ElevatedButton options(option t) {
    double width = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: () => onpress(t),
      style: ElevatedButton.styleFrom(
        backgroundColor: t.co,
        minimumSize: Size.fromHeight(width * 0.15),
        padding: EdgeInsets.symmetric(vertical: width * 0.004),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        t.opt,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color iscorrect(option t) {
    if (t.iscorret == true) {
      countT++;
      return (Colors.green);
    } else {
      countF++;
      da[q].a.co = (da[q].a.iscorret == true) ? (Colors.green) : wht;
      da[q].b.co = (da[q].b.iscorret == true) ? (Colors.green) : wht;
      da[q].c.co = (da[q].c.iscorret == true) ? (Colors.green) : wht;
      da[q].d.co = (da[q].d.iscorret == true) ? (Colors.green) : wht;
      return (Colors.red);
    }
  }

  bool isProcessing = false;
  onpress(option o) {
    if (isProcessing) return;
    setState(() {
      _isPaused = true;
      isProcessing = true;
      _controller.pause();
      o.co = iscorrect(o);

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          o.co = wht;
          isProcessing = false;
          _isPaused = false;
          create();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor, // Light purple background
      appBar: AppBar(
        backgroundColor: fgColor, // Make AppBar transparent
        elevation: 0, // Remove shadow
        title: const Text('Lets Play',
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CircularCountDownTimer(
              duration: _duration,
              initialDuration: 0,
              controller: _controller,
              width: width / 8,
              height: width / 8,
              ringColor: Colors.grey[300]!,
              fillColor: ltfg,
              backgroundColor: fgColor,
              strokeWidth: 8.0,
              strokeCap: StrokeCap.round,
              textStyle: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textFormat: CountdownTextFormat.S,
              isReverse: true,
              isReverseAnimation: true,
              isTimerTextShown: true,
              onComplete: () {
                skipped++;
                create();
              },
            ),
            Text(
              _message,
              style: TextStyle(
                fontSize: 20.0,
                color: blk,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            options(da[q].a),
            const SizedBox(height: 5),
            options(da[q].b),
            const SizedBox(height: 5),
            options(da[q].c),
            const SizedBox(height: 5),
            options(da[q].d),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () async {
                if (!isProcessing) {
                  skipped++;
                  da[q].a.co =
                      (da[q].a.iscorret == true) ? (Colors.green) : wht;
                  da[q].b.co =
                      (da[q].b.iscorret == true) ? (Colors.green) : wht;
                  da[q].c.co =
                      (da[q].c.iscorret == true) ? (Colors.green) : wht;
                  da[q].d.co =
                      (da[q].d.iscorret == true) ? (Colors.green) : wht;
                  create();
                }
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
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: fgColor.withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  skip,
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
          ],
        ),
      ),
    );
  }
}

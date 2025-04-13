import 'package:flutter/material.dart';
import 'package:myapp/pages/client/waitingroom.dart';
import 'package:myapp/themes/dark.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:back_pressed/back_pressed.dart';
import 'package:myapp/pages/loadingpage.dart';

class ScoreBoardScreen extends StatelessWidget {
  final List<String> scores;
  const ScoreBoardScreen({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double n = double.parse(scores[2]);
    double d = double.parse(scores[3]);
    double t = double.parse(scores[4]);
    double f = double.parse(scores[5]);
    double ti = double.parse(scores[7]);
    double score = (((t * 1 - f * 0.25) * (d * n - ti)) * 100) / (n * d * n);
    return OnBackPressed(
        perform: () {
          LoadingDialog.exitConfirmation(context);
        },
        child: Scaffold(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3825460822.
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [bgColor.withBlue(bgColor.blue - 2), bgColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CONGRATULATIONS',
                      style: TextStyle(
                        fontFamily: 'Paul',
                        fontSize: width * 0.095,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: fgColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Avatar
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: width * 0.15,
                          backgroundColor: Colors.purple.shade100,
                          backgroundImage: AssetImage(
                              'assets/images/avatar/${scores[1]}.png'),
                        ),
                        // Positioned(
                        //   bottom:0,
                        //   child: Icon(
                        //     Icons.military_tech,
                        //     size: 40,
                        //     color: fgColor,
                        //   ),
                        // )
                      ],
                    ),
                    const SizedBox(height: 5),

                    // User Name
                    Text(
                      scores[0],
                      style: TextStyle(
                        fontFamily: 'Paul',
                        fontSize: width * 0.075,
                        fontWeight: FontWeight.bold,
                        color: fgColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Score Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: ltfg.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      score.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: fgColor,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Score',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: fgColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              SizedBox(
                                width: width - 170,
                                child: Text(
                                  'Well done! You have finished the quiz successfully! Keep going—you’re doing great and can achieve even more!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: fgColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: fgColor,
                            thickness: 2,
                            indent: 0,
                            endIndent: 0,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ScoreCard(
                                'CORRECT',
                                scores[4],
                                n,
                              ),
                              ScoreCard('WRONG', scores[5], n),
                              ScoreCard('SKIPPED', scores[6], n),
                              ScoreCard('TIME', scores[7], d * n),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => const Waitingroom()),
  (route) => true, // This will remove all previous routes
);

                            triggerFetchQus();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: wht,
                            backgroundColor: fgColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: const Text('Back to Room'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            LoadingDialog.restartApp(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: wht,
                            backgroundColor: fgColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: const Text('Exit Room'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

ScoreCard(String label, String value, double n) {
  return CircularPercentIndicator(
    radius: 23.5,
    circularStrokeCap: CircularStrokeCap.round,
    lineWidth: 6.0,
    percent: double.parse(value) / n,
    center: Text(value, style: TextStyle(color: fgColor)),
    backgroundColor: ltfg.withOpacity(0.4),
    progressColor: fgColor,
    footer: Text(
      label,
      style: TextStyle(color: fgColor),
    ),
  );
}

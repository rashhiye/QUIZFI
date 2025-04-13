// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:myapp/themes/dark.dart';
import 'dart:async';

class aboutus extends StatefulWidget {
  const aboutus({super.key});

  @override
  _aboutusState createState() => _aboutusState();
}

class _aboutusState extends State<aboutus> {
  final ScrollController _scrollController = ScrollController();
  late Timer _scrollTimer;
  bool _isScrollingDown = true;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();

  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      // Scroll down if the flag is true
      if (_isScrollingDown) {
        if (_scrollController.offset < _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(_scrollController.offset + 1); // Adjust scroll speed
        } else {
          _isScrollingDown = false; // Switch direction
        }
      } else {
        // Scroll up if the flag is false
        if (_scrollController.offset > 0) {
          _scrollController.jumpTo(_scrollController.offset - 1); // Adjust scroll speed
        } else {
          _isScrollingDown = true; // Switch direction
        }
      }
    });
  }
  void _stopAutoScroll() {
    if (_scrollTimer.isActive) {
      _scrollTimer.cancel();
    }
  }

  @override
  void dispose() {
    _scrollTimer.cancel(); // Cancel the timer to avoid memory leaks
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor:fgColor, // Make AppBar transparent
        elevation: 0, // Remove shadow
        title: const Text('About Us!',
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
        // Title text`
      ),
      body:GestureDetector(
        onTap: _stopAutoScroll, // Stop scrolling on a tap
        onPanDown: (_) => _stopAutoScroll(), // Stop scrolling when the user drags or scrolls
        child:  SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/images/about/rashi.jpeg'), // Replace with your logo path
                      ),
                      Text("Rashid K.P",style:TextStyle(color:blk) ,),
                      Text("UI Designer",style:TextStyle(color:blk) ,)
                    ]),
                    Column(children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/images/about/devanandu.jpeg'), // Replace with your logo path
                      ),
                      Text("Devanandu K.K.T ",style:TextStyle(color:blk) ,),
                      Text("Backend Developer",style:TextStyle(color:blk) ,)
                    ]),
                    Column(children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/images/about/fadhi.jpeg'), // Replace with your logo path
                      ),
                      Text("Fadhi",style:TextStyle(color:blk) ,),
                      Text("UI Designer",style:TextStyle(color:blk) ,)
                    ])
                  ],
                ),
              )),
              const SizedBox(height: 20),
              Text(
                "About Us",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: blk,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Welcome to QuizFI, your trusted platform for dynamic and engaging quizzes designed to enhance knowledge and foster intellectual growth.At QuizFI, we aim to redefine the learning experience by combining the thrill of competition with the joy of discovery in a seamless and user-centric application.Our platform is designed to cater to students, professionals, and trivia enthusiasts, offering a versatile space where learning meets entertainment. Whether you’re preparing for competitive exams, sharpening your skills, or indulging in fun trivia, QuizFI provides the tools, insights, and community to make the journey enriching and impactful."
              ,textAlign: TextAlign.justify,style:TextStyle(color:blk) ,),
              const SizedBox(height: 10),
              Text(
                "Our Vision",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                  ,color:blk ,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "To become the premier platform for interactive learning and skill-building, inspiring a global community to embrace lifelong learning with curiosity and confidence."
               ,textAlign: TextAlign.justify,style:TextStyle(color:blk) ,),
              const SizedBox(height: 10),
              Text(
                "Our Mission",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: blk,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "->To deliver an innovative, reliable, and intuitive platform that transforms learning into an enjoyable experience.\n ->To foster intellectual growth by promoting curiosity, critical thinking, and healthy competition.\n ->To empower users with personalized insights to help them excel in their learning journey."
               ,textAlign: TextAlign.justify,style:TextStyle(color:blk) ,),
              const SizedBox(height: 10),
              Text(
                "Why QuizFI?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: blk,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "1. Comprehensive Quizzes: Access a diverse range of quiz categories, from academics to general knowledge and beyond."
                "\n2. Real-Time Engagement: Join real-time quiz challenges, connect with global participants, and compete for top rankings."
                "\n3. Performance Analytics: Gain valuable insights into your progress with detailed metrics on strengths and improvement areas."
                "\n4. User-Centric Design: Enjoy a smooth and interactive experience tailored to learners of all ages and skill levels."
                "\n5. Secure and Reliable: Benefit from a robust platform built with industry-standard security and performance in mind."
              ,textAlign: TextAlign.justify,style:TextStyle(color:blk) ,),
              const SizedBox(height: 10),
              Text(
                "Our Story",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: blk,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "QuizFI is the brainchild of a team of visionary developers – Muhammed Fadhi, Devanandu, and Muhammed Rashid. Drawing from our collective expertise in technology and a shared passion for education, we envisioned QuizFI as a platform that bridges the gap between learning and enjoyment. With a strong commitment to innovation and excellence, our team is dedicated to creating a platform that empowers users to unlock their potential, connect with a like-minded community, and embark on a rewarding journey of self-improvement."
              ,textAlign: TextAlign.justify,style:TextStyle(color:blk) ,),
              const SizedBox(height: 10),
              Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: blk,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Email : gctprojectteam1@gmail.com",
                style:TextStyle(color:blk) ,
              ),
              const SizedBox(height: 200), // Extra space for smooth scrolling
            ],
          ),
        ),
      ),
      ),
    );
  }
}
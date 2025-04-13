import 'package:flutter/material.dart';
import 'package:myapp/pages/homepage.dart';
import 'package:myapp/pages/client/joinroom.dart';

class LoadingDialog {
  // Function to show a loading dialog
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Loading..."),
            ],
          ),
        );
      },
    );
  }

  static void error(BuildContext context,
      {String err = "something went wrong"}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
              ),
              Text("Error"),
              Text(err),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("ok"))
            ],
          ),
        );
      },
    );
  }

  // Function to hide the dialog
  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
  }

  static void exitConfirmation(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Exit"),
        content: const Text("Do you want to exit from the room?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog with "No"
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              restartApp(context);
            }, // Close dialog with "Yes"
            child: const Text("Yes"),
          ),
        ],
      ),
    ); // Return false if dialog is dismissed without a selection
  }

  static void backConfirmation(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Exit"),
        content: const Text(
            "Game is on going, If you exit from room you will lose all the data.Are you sure you want to exit from the room"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            }, // Close dialog with "No"
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              restartApp(context);
            }, // Close dialog with "Yes"
            child: const Text("Yes"),
          ),
        ],
      ),
    ); // Return false if dialog is dismissed without a selection
  }

  static void restartApp(BuildContext context) {
    Joinroom.socket?.close();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false, // Remove all routes
    );
  }
}

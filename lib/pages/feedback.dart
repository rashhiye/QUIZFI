import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myapp/themes/dark.dart';
import 'package:myapp/pages/homepage.dart';

class SupportFeedbackPage extends StatefulWidget {
  SupportFeedbackPage({Key? key}) : super(key: key);

  @override
  _SupportFeedbackPageState createState() => _SupportFeedbackPageState();
}

class _SupportFeedbackPageState extends State<SupportFeedbackPage> {
  // List of probable errors and solutions based on history
  String status = '';
  final List<Map<String, String>> errorSolutions = [
    
  {
    'issue': 'IP address not showing.',
    'solution': 'Ensure your cellular data or Wi-Fi is turned on. If on a mobile network, try switching between Wi-Fi and mobile data to resolve connectivity issues. Check if the app has permission to access the network.'
  },
  {
    'issue': 'Questions are repeating during the quiz.',
    'solution': 'The quiz API has a limit of 1200 tokens per minute, which may cause repetition if too many requests are made in a short period. Please wait a few moments or try restarting the app to allow for fresh questions.'
  },
  {
    'issue': 'Connectivity issues during the game.',
    'solution': 'Ensure you have a stable internet connection. If you are connected to a host’s hotspot, make sure the host’s device has a reliable connection. Try switching to a different network or restarting the app if the issue persists.'
  },
  {
    'issue': 'Server connection lost while switching pages.',
    'solution': "Check your internet connection. If you're on mobile data, ensure the connection is stable. When switching between pages, the app may disconnect from the server temporarily. Try reconnecting or refreshing the app to restore the connection."
  },
  {
    'issue': 'App is not syncing user data.',
    'solution': 'Ensure your device has an active internet connection. If on Wi-Fi, verify that the connection is stable. If using mobile data, confirm that the app has the necessary permissions to access the network.'
  }


  ];

  // Function to send feedback via email
  Future<void> sendEmail() async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: 'gctprojectteam1@gmail.com',
    queryParameters: {
      'subject': 'QuizFI\tSupport\tRequest',
      'body':'Hello\ti\tam\t${HomePage.Name},\n'
    },
  );

  try {
    await launch(emailUri.toString()); // Use launch() instead of canLaunchUrl()
  } catch (e) {
    debugPrint('Error launching email client: $e');
  }
}


  //   if (await canLaunchUrl(emailUri)) {
  //     await launchUrl(emailUri);
  //     return "done";
  //   } else {
  //     debugPrint('Could not launch email client.');
  //     return "error";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fgColor, // Make AppBar transparent
        elevation: 0, // Remove shadow
        title: const Text('Support and Feedback',
            style: TextStyle(
              fontSize: 28,
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
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Help? Contact Us!',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: blk),
            ),
            const SizedBox(height: 16),
            Text(
              "Please check the listed issues to see if any match the problem you're experiencing. If you can’t find a solution, contact our support team directly for further assistance. We're here to help resolve any issues you may be facing!",
              style: TextStyle(fontSize: 16, color: blk),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: errorSolutions.length,
                itemBuilder: (context, index) {
                  final issue = errorSolutions[index]['issue'];
                  final solution = errorSolutions[index]['solution'];
                  return Card(
                    color: Theme.of(context).cardColor,
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      title: Text(issue ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(solution ?? ''),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: sendEmail,
              child: const Center(
                child: Text('Contact Us', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

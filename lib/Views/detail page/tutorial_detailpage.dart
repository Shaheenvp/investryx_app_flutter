import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class TutorialsDetailScreen extends StatefulWidget {
  const TutorialsDetailScreen({super.key});

  @override
  State<TutorialsDetailScreen> createState() => _TutorialsDetailScreenState();
}

class _TutorialsDetailScreenState extends State<TutorialsDetailScreen> {

  void _launchURL() async {
    final Uri url = Uri.parse("https://youtu.be/yUZGVgzeL_4?si=6EvtcJp8-8SpJ8rj");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $url";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Tutorials', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          centerTitle: true,

        ),
        body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main heading
                  const Text(
                    'Business For Sale',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'Business For Sale Sell Your Business',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Description Text
                  const Text(
                    'At Viral Pitch We Expect At A Day’s Start Is You, Bettr And Happier Than Yesterday. '
                        'We Have Got Ycovered Share Your Concern Or Check Our Frequently Asked Questions Listed Below.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Image with play button
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/tut6.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: IconButton(
                              icon: const Icon(Icons.play_arrow,
                                  size: 40, color: Color(0xffFFCC00)),
                              onPressed: _launchURL,

                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Repeated description text
                  const Text(
                    'At Viral Pitch we expect at a day’s start is you, bettr and happier than yesterday. We have got ycovered share your concern or check our frequently askead questions listed below.At Viral Pitch we expect at a day’s start is you, bettr and happier than yesterday. We have got ycovered share your concern or check our frequently askead questions listed below.At Viral Pitch we expect at a day’s start is you, bettr and happier than yesterday. We have got ycovered share your concern or check our frequently askead questions listed below',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            ),
        );
    }
}

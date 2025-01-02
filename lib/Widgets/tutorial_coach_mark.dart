import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';


class FabTutorialCoachMark {
  final BuildContext context;
  final GlobalKey fabKey;

  FabTutorialCoachMark(this.context, this.fabKey);

  static Future<bool> shouldShowTutorial() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return !(prefs.getBool('fab_tutorial_shown') ?? false);
    } catch (e) {
      debugPrint('Error checking tutorial status: $e');
      return true;
    }
  }

  void showTutorial() async {
    // Check if tutorial should be shown
    bool shouldShow = await shouldShowTutorial();
    if (!shouldShow) return;

    // Create tutorial coach mark
    TutorialCoachMark tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      skipWidget: const Text(
        "SKIP",
        style: TextStyle(color: Colors.white),
      ),
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        _markTutorialAsShown();
      },
      onClickTarget: (target) {
        // Optional: Add any specific behavior when clicking on the tutorial target
      },
      onSkip: () {
        _markTutorialAsShown();
        return false;
      },
    );

    // Show the tutorial
    tutorialCoachMark.show(context: context);
  }

  Future<void> _markTutorialAsShown() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('fab_tutorial_shown', true);
      debugPrint('Tutorial marked as shown');
    } catch (e) {
      debugPrint('Error marking tutorial as shown: $e');
    }
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "Fab-Tutorial",
        keyTarget: fabKey,
        alignSkip: AlignmentDirectional.bottomEnd,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "What would you like to do?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Tap here to choose an option: Sell a Business, Post as an Investor, Franchise Your Brand, or Register as an Advisor/Business Broker.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ];
  }
}

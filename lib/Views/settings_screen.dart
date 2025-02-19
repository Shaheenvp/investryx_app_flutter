import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:project_emergio/Views/FAQ%20page.dart';
import 'package:project_emergio/Views/Suggestion%20page.dart';
import 'package:project_emergio/Views/contact%20us%20page.dart';
import 'package:project_emergio/Views/manage%20profile%20screen.dart';
import 'package:project_emergio/Views/pricing%20screen.dart';
import 'package:project_emergio/Views/tutorial%20page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'Auth Screens/ForgotPassword/change password.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  static const String _notificationPrefKey = 'notifications_enabled';

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  // Load saved notification settings
  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool(_notificationPrefKey) ?? true;
    });
    // Sync the loaded setting with OneSignal
    _updateOneSignalNotificationSettings(_notificationsEnabled);
  }

  // Update OneSignal notification settings
  Future<void> _updateOneSignalNotificationSettings(bool enabled) async {
    if (enabled) {
      // Enable notifications
      await OneSignal.Notifications.requestPermission(true);
      await OneSignal.Notifications.clearAll();
      await OneSignal.User.pushSubscription.optIn();
    } else {
      // Disable notifications
      await OneSignal.Notifications.clearAll();
      await OneSignal.User.pushSubscription.optOut();
    }

    // Save the setting
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationPrefKey, enabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Settings'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Section
              const ListTile(
                leading: Icon(Icons.person, color: Colors.black),
                title: Text(
                  'Account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              _buildSettingsOption(
                'Manage Profile',
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageProfileScreen()));
                },
              ),
              _buildSettingsOption(
                'Change Password',
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen()));
                },
              ),
              const SizedBox(height: 16),

              // Notifications Section
              const ListTile(
                leading: Icon(Icons.notifications, color: Colors.black),
                title: Text(
                  'Notifications',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SwitchListTile(
                title: const Text('Notifications'),
                value: _notificationsEnabled,
                onChanged: (bool value) async {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  await _updateOneSignalNotificationSettings(value);
                },
                activeColor: const Color(0xffFFCC00),
              ),
              const SizedBox(height: 16),

              // Others Section
              const ListTile(
                leading: Icon(Icons.more_horiz, color: Colors.black),
                title: Text(
                  'Others',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              _buildSettingsOption(
                'Pricings',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  PricingScreenNew()));
                },
              ),
              _buildSettingsOption(
                'Contact Us',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  ContactUsPage()));
                },
              ),
              _buildSettingsOption(
                'Tutorial',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TutorialsScreen()));
                },
              ),
              _buildSettingsOption(
                'Suggestions',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  SuggestionScreen()));
                      },
              ),
              _buildSettingsOption(
                'FAQ',
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FaqScreen()));
                },
              ),
              const SizedBox(height: 16),


            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build settings option
  Widget _buildSettingsOption(String title, VoidCallback onPressed) {
    return ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onPressed,
        );
    }
}

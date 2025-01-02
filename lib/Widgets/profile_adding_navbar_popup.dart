import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:project_emergio/Views/Profiles/Business/Business%20addPage.dart';
import 'package:project_emergio/Views/Profiles/advisor/advisor_profile_add_screen.dart';
import 'package:project_emergio/Views/Profiles/franchise/Franchise%20Form.dart';
import 'package:project_emergio/Views/Profiles/investor/Investor%20form.dart';


class BusinessOptionsDialog extends StatelessWidget {
  const BusinessOptionsDialog({Key? key}) : super(key: key);

  static const Color primaryYellow = Color(0xFFFFD700);
  static const Color darkYellow = Color(0xFFFFB800);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What would you like to do?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 24),
            _buildOption(
              icon: Icons.trending_up,
              title: 'Sell Business / Find Investor',
              description: 'List your business or connect with investors',
              onTap: () {
                Get.to(() => BusinessInfoPage(isEdit: false, type: 'business',));
                HapticFeedback.mediumImpact();
              },
            ),
            _buildOption(
              icon: Icons.paid,
              title: 'Buy / Invest in a Business',
              description: 'Browse opportunities and invest',
              onTap: () {
                Get.to(() => InvestorFormScreen(isEdit: false,type: 'investor',));
                HapticFeedback.mediumImpact();
              },
            ),
            _buildOption(
              icon: Icons.store,
              title: 'Franchise your Brand',
              description: 'Expand your business through franchising',
              onTap: () {
                Get.to(() => FranchiseFormScreen(isEdit: false,type: 'franchise',));
                HapticFeedback.mediumImpact();
              },
            ),
            _buildOption(
              icon: Icons.person_outline,
              title: 'Register as Advisor / Broker',
              description: 'Join as a business professional',
              onTap: () {
                Get.to(() => AddAdvisorProfileScreen());
                HapticFeedback.mediumImpact();
              },
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: primaryYellow.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryYellow.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: darkYellow,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
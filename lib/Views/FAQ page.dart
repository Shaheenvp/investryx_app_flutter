import 'package:flutter/material.dart';
import '../Widgets/custom_profile_appbar_widget.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String selectedCategory = 'Business';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarWidget(
        title: "FAQs",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Help You With Anything And Everything On Investryx',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: const Color(0xffF3F8FE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xffFFCC00),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          // Handle search
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCategoryButton('Business'),
              buildCategoryButton('Investment'),
              buildCategoryButton('Franchise'),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: _buildFaqList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqList() {
    switch (selectedCategory) {
      case 'Business':
        return const Column(
          children: [
            ExpansionTile(
              title: Text('What is Business?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Business Definition: Business is an economic activity that involves the exchange, purchase, sale or production of goods and services with a motive to earn profits and satisfy the needs of customers.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How to Add Business Profile?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To add a business profile:\n1. Go to Profile section\n2. Click on "Add Business"\n3. Fill in your business details\n4. Upload necessary documents\n5. Submit for verification',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How to Add New Business?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To add a new business:\n1. Navigate to Dashboard\n2. Select "Create New Business"\n3. Choose business category\n4. Enter business information\n5. Add business location\n6. Submit for review',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How to Delete Business Post'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To delete a business post:\n1. Go to your business profile\n2. Find the post you want to delete\n3. Click the three dots menu\n4. Select "Delete Post"\n5. Confirm deletion',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How to Accept Business Proposals'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To accept business proposals:\n1. Check your notifications\n2. Open the proposal\n3. Review details carefully\n4. Click "Accept" or "Reject"\n5. Confirm your decision',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How to Change my Business Profile'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To change your business profile:\n1. Go to Business Settings\n2. Select "Edit Profile"\n3. Update necessary information\n4. Save changes',
                  ),
                ),
              ],
            ),
          ],
        );
      case 'Investment':
        return const Column(
          children: [
            ExpansionTile(
              title: Text('What is Investment on Investryx?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Investment on Investryx allows users to invest in verified businesses and startups through our platform. It provides opportunities for both investors and businesses to grow together.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How to Start Investing?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To start investing:\n1. Complete your investor profile\n2. Add investment funds\n3. Browse investment opportunities\n4. Analyze business profiles\n5. Choose your investment amount\n6. Confirm investment',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('What are the Minimum Investment Requirements?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Minimum investment requirements vary by opportunity. Generally:\n- Standard investments: \$1,000\n- Premium opportunities: \$5,000\n- Angel investments: \$10,000+',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How to Track Investments?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Track your investments through:\n1. Investment Dashboard\n2. Monthly reports\n3. Real-time notifications\n4. Performance metrics\n5. Return calculations',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Investment Withdrawal Process'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To withdraw investments:\n1. Go to Investment Portal\n2. Select "Withdraw Funds"\n3. Choose amount and timing\n4. Review terms\n5. Confirm withdrawal',
                  ),
                ),
              ],
            ),
          ],
        );
      case 'Franchise':
        return const Column(
          children: [
            ExpansionTile(
              title: Text('What is Franchising on Investryx?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Franchising on Investryx connects franchise owners with potential franchisees. It provides a platform to explore, evaluate, and acquire franchise opportunities.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('How to List a Franchise?'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To list your franchise:\n1. Create franchise profile\n2. Add franchise details\n3. Set investment requirements\n4. Upload documentation\n5. Submit for verification',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Franchise Application Process'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'The application process includes:\n1. Initial inquiry\n2. Background check\n3. Financial verification\n4. Training schedule\n5. Agreement signing',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Franchise Support Services'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Available support services:\n1. Training programs\n2. Marketing assistance\n3. Operations guidance\n4. Supply chain management\n5. Technical support',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Franchise Renewal Process'),
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To renew your franchise:\n1. Review performance metrics\n2. Update documentation\n3. Negotiate terms\n4. Complete renewal form\n5. Process renewal fee',
                  ),
                ),
              ],
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildCategoryButton(String category) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = category;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedCategory == category ? Colors.amber : Colors.white,
        foregroundColor: selectedCategory == category ? Colors.white : Colors.black,
      ),
      child: Text(category),
    );
  }
}
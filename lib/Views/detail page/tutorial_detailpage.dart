// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class TutorialPage extends StatelessWidget {
//   final String videoUrlBusinessForSale = 'https://youtu.be/R9ReEI1vn-8';
//   final String videoUrlBuyBusiness = 'https://youtu.be/pvXMhgdovtE';
//
//   const TutorialPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Tutorial',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Divider(),
//               ExpansionTile(
//                 title: Text('Business For Sale'),
//                 children: [
//                   Text(
//                     "Business for Sale | Sell Your Business",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'We understand that selling your business is a tedious and time-consuming process , but is also one of the most important events of your career. Whether you plan to retire from your company, relocate to a new location, move on to new opportunities, or you feel that the company needs a larger backing, selling your business to an interested entrepreneur is the best option.Confidentiality of your business and the quality of buyers you speak with are of prime importance to us. On our platform, you can expand your reach by connecting with a large number of registered buyers for private placements on a confidential basisSMERGERS helps you to connect with targeted buyers who can take your business to the next level',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   SizedBox(height: 16),
//                   GestureDetector(
//                     onTap: () {
//                       launch(videoUrlBusinessForSale);
//                     },
//                     child: AspectRatio(
//                       aspectRatio: 16 / 9,
//                       child: Container(
//                           color: Colors.black,
//                           child: Stack(
//                             children: [
//                               Image.asset('assets/smerger.png'),
//                               Center(
//                                   child: Icon(
//                                 Icons.play_circle_fill,
//                                 size: 45,
//                                 color: Colors.red,
//                               ))
//                             ],
//                           )),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'TodayREGISTRATION ON SMERGERSExplain your business and reason for exit in a clear and compelling manner. Choose the service level you want from SMERGERS.TomorrowPROFILE ACTIVATION & RECOMMENDATIONSMERGERS reviews your business details and activates your profile. SMERGERS also sends you a list of recommended buyers for your businessBy Last Week of JulyBUYER INTRODUCTIONSInterested acquirers start connecting with you. You can send proposals to acquirers to accelerate the process. To protect confidentiality, you can ask them to sign a NDABy Second Week of AugustSHARING DOCUMENTSIt is important to share a professionally-written Information Memorandum and Financial Projection with the investor. This helps the buyer evaluate the opportunity quickly and arrive at a decision.By OctoberDUE DILIGENCE & CLOSUREPost agreement, the buyer will conduct a due diligence to cross-check all information shared earlier. If no discrepancies are found, the deal is complete and you receive the required amount',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   SizedBox(height: 16),
//                 ],
//               ),
//               Divider(),
//               ExpansionTile(
//                 title: Text('Find Investor'),
//                 children: [
//                   Text(
//                     "Find Investors for your Business",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'More than 60% of SMEs are unserved or underserved by the current financial ecosystem. Businesses can access finance through "equity financing" or "debt financing“ . Equity financing means you give a share of your company for money. Debt financing means that you will pay back the money with a predefined interest amountApart from bank loans, one can raise funds from various other viable sources such as friends, family, private lenders, individual investors, angel investors, financial instuitions, PE firms and other companies seeking to make strategic investments.SMERGERS helps you to connect with the right investors who can fuel business growth.',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   Text(
//                     'Today REGISTRATION ON SMERGERS Explain your business and finance requirements in a clear and compelling manner. Choose the service level you want from SMERGERS.TomorrowPROFILE ACTIVATION & RECOMMENDATIONSMERGERS reviews your business details and activates your profile. SMERGERS also sends you a list of recommended investors for your businessBy First Week of OctoberINVESTOR INTRODUCTIONSInterested Investors start connecting with you. You can send proposals to investors to accelerate the process. To protect confidentiality, you can ask them to sign a NDABy Third Week of OctoberSHARING DOCUMENTSIt is important to share a professionally-written Information Memorandum and Financial Projection with the investor. This helps the investor evaluate the opportunity quickly and arrive at a decision.By DecemberDUE DILIGENCE & CLOSUREPost agreement, the investor will conduct a due diligence to cross-check all information shared earlier. If no discrepancies are found, the deal is complete and you receive the required amount',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                 ],
//               ),
//               Divider(),
//               ExpansionTile(
//                 title: Text('Franchise Options'),
//                 children: [
//                   Text(
//                     "How To Franchise Your Business",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Finding good and reliable franchise partners to grow your business can be a painful, yet important task for your business. SMERGERS makes this easy by bringing business enthusiasts and investors from different parts of the world under one roof.Lead GenerationSend announcements to thousands of qualified investors/buyers in a matter of secondsTrusted MembersWe care about quality as much as you do. We are filtering out the not so serious crowd.Grow your customer baseConnect with entrepreneurs who can take your brand to the next levelGlobal NetworkWe bring investors and entrepreneurs across the globe to a single platform - SMERGERS',
//                     style: TextStyle(fontSize: 14),
//                   ),
//
//                 ],
//               ),
//               Divider(),
//               ExpansionTile(
//                 title: Text('Buy a business'),
//                 children: [
//                   Text(
//                     "Buying A Business",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Whether you are buying a business to run it yourself or acquiring one for a strategic advantage , the process and due diligence conducted is similar. There are many reasons why buying an existing business is better than starting one: reduced risk, immediate cash flows, established vendor and customer relationships, avoiding time consuming and tedious startup work, and so on.We understand that Buyers need a lot of information before they decide to make the purchase. It is important for the buyer to know if the business is legitimate, valuation is reasonable, industry is attractive and if there are any other better opportunities. The best way to answer these questions is by talking to as many businesses as possible as you will be in a better position to evaluate them.SMERGERS provides a platform to compare and evaluate various pre-qualified businesses across industries and geographies',
//                     style: TextStyle(fontSize: 14),
//                   ),
//                   SizedBox(height: 16),
//                   GestureDetector(
//                     onTap: () {
//                       launch(videoUrlBuyBusiness);
//                     },
//                     child: AspectRatio(
//                       aspectRatio: 16 / 9,
//                       child: Container(
//                           color: Colors.black,
//                           child: Stack(
//                             children: [
//                               Image.asset('assets/smerger.png'),
//                               Center(
//                                   child: Icon(
//                                     Icons.play_circle_fill,
//                                     size: 45,
//                                     color: Colors.red,
//                                   ))
//                             ],
//                           )),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'TodayREGISTER AND CONNECT WITH BUSINESSESExplain your requirements and background in a clear manner. Shortlist businesses which match your requirements and express your interest to connect with them.TomorrowPROFILE ACTIVATION & INTRODUCTIONSSMERGERS reviews your profile and activates it. You will be introduced to the businesses you have connected with and can connect with further businesses based on our recommendations.By First Week of OctoberINITIAL DISCUSSIONSYou can contact businesses directly to have initial discussions. Use our proprietary rating system to evaluate these businesses and their valuations.By Third Week of OctoberRECEIVE DOCUMENTSYou may have to sign a NDA to receive further information such as Information Memorandum, Financials and Valuation from the BusinessBy DecemberDUE DILIGENCE & CLOSUREIf the business is suitable to your requirements, issue a Letter of Intent. Appoint due diligence advisors for cross-checking information. After due diligence is completed, make the purchase to own the business.',
//                     style: TextStyle(fontSize: 14),
//                   ),
//
//
//                 ],
//               ),
//               Divider(),
//               ExpansionTile(
//                 title: Text('Register as an advisor'),
//                 children: [
//                   Text(
//                     "Advisors and Business Brokers",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Premier Platform for Dealmakers - Financial advisors, Investment bankers, M&A consultants, Accountants and Business Brokers. Engage directly with business owners, investors, buyers and strategic acquirers matching your requirements.Deal OriginationDeal OriginationWin mandates from Business owners ready to work with advisors. SMERGERS supports you in closing the transaction by generating matching leadsLead GenerationLead GenerationConfidentially send deal teasers to thousands of qualified investors/buyers in a matter of seconds and generate interest to close your deals in a fast and cost effective manner.Pre-qualified NetworkPre-qualified NetworkWe care about quality as much as you do. By creating a trusted network of members, providing relevant data, and easy-to-use Non-Disclosure Agreements, we are cutting down the tire kickers.Client ConfidentialityClient ConfidentialityProfiles and teasers are created and shared on a no-name basis and introductions are mutually opt in. We use SSL technology to encrypt confidential information.Profile Tracking and AnalyticsProfile Tracking and AnalyticsOptimize your deal distribution strategy via our Insights report with full stats and analytics on number of views, connects, and inquiries generated for each of your deal.Business Valuation ToolBusiness Valuation ToolAccess comparable data of public listed companies, current businesses for sale and recently sold businesses to generate a valuation estimate for your clients.',
//                     style: TextStyle(fontSize: 14),
//                   ),
//
//                 ],
//               ),
//               Divider(),
//               ExpansionTile(
//                 title: Text('Value a Business'),
//                 children: [
//                   Text(
//                     "How to value a Business",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "What is Business Valuation?",
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "At SMERGERS, we define Business Valuation as a technique used to capture the true value of the business. Common approaches to business valuation include Discounted Cash Flow (DCF), Trading Comparables, and Transaction Comparables method described below.",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "When do you need a Business Valuation?",
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "The following are some of the common reasons which necessitate valuing your business Selling the business Fund raising from VC or IPO Issuing stock to employees Tax purposesLiquidation of the companyFinancial reporting relatedLitigation related",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "What is a Business’ value?",
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "A company is held by two categories of owners, shareholders and debt holders. The value of a pure business which accrues to both categories of owners is called the Enterprise Value, whereas the value which accrues just to shareholders is the Equity Value (also called market cap for listed companies). Companies are compared using the enterprise value instead of equity value as debt and cash levels may vary significantly even between companies in the same industry. During an acquisition, depending on whether it is an asset purchase or a stock purchase, valuation of appropriate elements of the business needs to be carried out.",
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                   ),
//
//                 ],
//               ),
//               Divider(),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';


class TutorialsDetailScreen extends StatefulWidget {
  const TutorialsDetailScreen({super.key});

  @override
  State<TutorialsDetailScreen> createState() => _TutorialsDetailScreenState();
}

class _TutorialsDetailScreenState extends State<TutorialsDetailScreen> {
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
          actions: const [
            Icon(Icons.notifications, color: Colors.black),
          ],
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
                              onPressed: () {
                                // Handle play button action
                              },
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

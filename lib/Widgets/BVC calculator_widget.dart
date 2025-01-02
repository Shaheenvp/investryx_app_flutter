// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class BusinessValuationPopup extends StatefulWidget {
//   @override
//   _BusinessValuationPopupState createState() => _BusinessValuationPopupState();
// }
//
// class _BusinessValuationPopupState extends State<BusinessValuationPopup> {
//   String selectedCountry = 'India';
//   String selectedIndustry = 'Information Technology';
//   String selectedCurrency = 'USD';
//   final TextEditingController revenueController = TextEditingController();
//   final TextEditingController ebitdaMarginController = TextEditingController();
//   double businessValue = 0.0;
//
//   void calculateValuation() {
//     // Parse user input
//     double annualRevenue = double.tryParse(revenueController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
//     double ebitdaMargin = double.tryParse(ebitdaMarginController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
//
//     // Calculate EBITDA
//     double ebitda = annualRevenue * (ebitdaMargin / 100);
//
//     // Apply a multiple to EBITDA to calculate business value
//     const double multiple = 5.0; // Adjust based on industry
//     businessValue = ebitda * multiple;
//
//     // Convert to selected currency
//     if (selectedCurrency == 'INR') {
//       businessValue = convertToINR(businessValue); // Convert to INR if needed
//     }
//
//     setState(() {});
//   }
//
//   // Convert USD to INR (Assume conversion rate; update dynamically if needed)
//   double convertToINR(double valueInUSD) {
//     const double conversionRate = 83.0; // Example conversion rate, update as needed
//     return valueInUSD * conversionRate;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//
//     return AlertDialog(
//       title: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//           'Business Valuation Calculator',
//           style: TextStyle(fontWeight: FontWeight.w600, fontSize: h * 0.021),
//         ),
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Select Country'),
//             DropdownButton<String>(
//               value: selectedCountry,
//               isExpanded: true,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedCountry = newValue!;
//                 });
//               },
//               items: <String>[
//                 'India',
//                 'Canada',
//                 'Pakistan',
//                 'United States',
//                 'Australia',
//                 'United Kingdom',
//                 'Germany',
//                 'France',
//                 'China',
//                 'Japan'
//               ].map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 16),
//             Text('Select Industry'),
//             DropdownButton<String>(
//               value: selectedIndustry,
//               isExpanded: true,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedIndustry = newValue!;
//                 });
//               },
//               items: <String>[
//                 'Information Technology',
//                 'Health Care',
//                 'Food and Beverage',
//                 'Manufacturing',
//                 'Retail',
//                 'Finance',
//                 'Real Estate',
//                 'Education',
//                 'Automotive',
//                 'Tourism'
//               ].map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 16),
//             Text('Select Currency'),
//             DropdownButton<String>(
//               value: selectedCurrency,
//               isExpanded: true,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedCurrency = newValue!;
//                 });
//               },
//               items: <String>['USD', 'INR'].map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 16),
//             Text('Annual Revenue'),
//             TextField(
//               controller: revenueController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'e.g., 2000000',
//               ),
//             ),
//             SizedBox(height: 16),
//             Text('EBITDA Margin'),
//             TextField(
//               controller: ebitdaMarginController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'e.g., 20',
//               ),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Estimated Business Value: ${NumberFormat.currency(symbol: selectedCurrency == 'INR' ? '₹' : '\$').format(businessValue)}',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         Center(
//           child: SizedBox(
//             height: h * 0.055,
//             width: w * 0.3,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5)),
//                   backgroundColor: Color(0xff003C82)),
//               onPressed: () {
//                 calculateValuation();
//               },
//               child: Text(
//                 'Calculate',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }



import 'package:flutter/material.dart';

class BusinessValuationScreen extends StatefulWidget {
  const BusinessValuationScreen({super.key});

  @override
  State<BusinessValuationScreen> createState() =>
      _BusinessValuationScreenState();
}

class _BusinessValuationScreenState extends State<BusinessValuationScreen> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What Is Business Valuation",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/business_valuation.png', // Replace with your image path
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            const Text(
              "At Investryx, We Define Business Valuation As A Technique Used To Capture The True Value Of The Business. Common Approaches To Business Valuation Include Discounted Cash Flow (DCF), Trading Comparables, And Transaction Comparables Method Described Below.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              "How Much Is Your Business Worth",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField("Select Country"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField("Select Industry"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField("Annual Revenue"),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField("EBITDA Margin"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: w * 0.4,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Get Report action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFFCC00),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Get Report',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextField(
        decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            ),
        );
    }
}

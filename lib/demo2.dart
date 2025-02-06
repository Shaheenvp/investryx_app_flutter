import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BusinessValuationScreen extends StatefulWidget {
  @override
  _BusinessValuationScreenState createState() => _BusinessValuationScreenState();
}

class _BusinessValuationScreenState extends State<BusinessValuationScreen> {
  final _formKey = GlobalKey<FormState>();
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  // Controllers for inputs
  final _revenueController = TextEditingController();
  final _profitController = TextEditingController();
  final _assetsController = TextEditingController();
  final _industryController = TextEditingController(text: 'Service'); // Service/Manufacturing/Retail
  final _ageController = TextEditingController();
  final _growthRateController = TextEditingController();

  double _businessValue = 0;
  String _valuationBreakdown = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indian Business Valuation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Business Details', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _revenueController,
                label: 'Annual Revenue (in Lakhs)',
                hint: 'e.g., 500',
              ),
              _buildInputField(
                controller: _profitController,
                label: 'Annual Net Profit (in Lakhs)',
                hint: 'e.g., 100',
              ),
              _buildInputField(
                controller: _assetsController,
                label: 'Total Assets Value (in Lakhs)',
                hint: 'e.g., 300',
              ),
              _buildInputField(
                controller: _industryController,
                label: 'Industry Type',
                hint: 'Service/Manufacturing/Retail',
              ),
              _buildInputField(
                controller: _ageController,
                label: 'Business Age (in years)',
                hint: 'e.g., 5',
              ),
              _buildInputField(
                controller: _growthRateController,
                label: 'Annual Growth Rate (%)',
                hint: 'e.g., 15',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateValuation,
                child: const Text('Calculate Valuation'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 20),
              if (_businessValue > 0) ...[
                Text(
                  'Estimated Business Value:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  _currencyFormat.format(_businessValue * 100000), // Converting lakhs to rupees
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Valuation Breakdown:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(_valuationBreakdown),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value?.isEmpty == true ? 'Required' : null,
      ),
    );
  }

  void _calculateValuation() {
    if (_formKey.currentState?.validate() != true) return;

    final revenue = double.parse(_revenueController.text);
    final profit = double.parse(_profitController.text);
    final assets = double.parse(_assetsController.text);
    final industry = _industryController.text.toLowerCase();
    final age = double.parse(_ageController.text);
    final growthRate = double.parse(_growthRateController.text) / 100;

    // Industry multipliers based on Indian market standards
    double profitMultiplier;
    double revenueMultiplier;

    switch (industry) {
      case 'service':
        profitMultiplier = 3.5;
        revenueMultiplier = 1.2;
        break;
      case 'manufacturing':
        profitMultiplier = 4.0;
        revenueMultiplier = 0.8;
        break;
      case 'retail':
        profitMultiplier = 3.0;
        revenueMultiplier = 0.6;
        break;
      default:
        profitMultiplier = 3.5;
        revenueMultiplier = 1.0;
    }

    // Age factor (maturity premium)
    double ageFactor = age < 3 ? 0.8 : age < 5 ? 0.9 : age < 10 ? 1.0 : 1.1;

    // Growth premium
    double growthPremium = growthRate > 0.25 ? 1.3 :
    growthRate > 0.15 ? 1.2 :
    growthRate > 0.10 ? 1.1 : 1.0;

    // Calculate different valuation components
    double profitBasedValue = profit * profitMultiplier;
    double revenueBasedValue = revenue * revenueMultiplier;
    double assetBasedValue = assets * 0.8; // Considering liquidation discount

    // Final weighted valuation
    _businessValue = (
        (profitBasedValue * 0.5) +    // 50% weightage to profit-based value
            (revenueBasedValue * 0.3) +   // 30% weightage to revenue-based value
            (assetBasedValue * 0.2)       // 20% weightage to asset-based value
    ) * ageFactor * growthPremium;

    // Prepare breakdown
    _valuationBreakdown = '''
• Profit-Based Value (50%): ${_currencyFormat.format(profitBasedValue * 100000)}
• Revenue-Based Value (30%): ${_currencyFormat.format(revenueBasedValue * 100000)}
• Asset-Based Value (20%): ${_currencyFormat.format(assetBasedValue * 100000)}
• Age Factor: ${ageFactor.toStringAsFixed(2)}x
• Growth Premium: ${growthPremium.toStringAsFixed(2)}x
''';

    setState(() {});
  }
}
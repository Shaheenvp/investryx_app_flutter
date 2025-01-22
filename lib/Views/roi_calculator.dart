import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../models/currency.dart';

class TimePeriod {
  final String label;
  final double years;
  final bool showAnnualized;

  TimePeriod({
    required this.label,
    required this.years,
    this.showAnnualized = true,
  });
}

class ModernROICalculator extends StatefulWidget {
  const ModernROICalculator({Key? key}) : super(key: key);

  @override
  _ModernROICalculatorState createState() => _ModernROICalculatorState();
}

class _ModernROICalculatorState extends State<ModernROICalculator>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late AnimationController _expandController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _expandAnimation;

  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _revenueController = TextEditingController();
  final TextEditingController _operatingCostsController = TextEditingController();

  // Base ROI values
  double _roi = 0.0;
  double _netProfit = 0.0;
  Map<String, double> _periodROIs = {};
  Map<String, double> _annualizedROIs = {};

  bool _hasCalculated = false;
  bool _isExpanded = true;
  bool _showInvestmentInfo = false;
  bool _showRevenueInfo = false;
  bool _showCostsInfo = false;

  final List<Currency> _currencies = [
    Currency(code: 'USD', symbol: '\$', name: 'US Dollar', conversionRate: 1.0),
    Currency(code: 'EUR', symbol: '€', name: 'Euro', conversionRate: 0.91),
    Currency(code: 'GBP', symbol: '£', name: 'British Pound', conversionRate: 0.79),
    Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee', conversionRate: 83.12),
    Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar', conversionRate: 1.52),
  ];

  final List<TimePeriod> _timePeriods = [
    TimePeriod(label: '3 Months', years: 0.25),
    TimePeriod(label: '6 Months', years: 0.5),
    TimePeriod(label: '1 Year', years: 1.0, showAnnualized: false),
    TimePeriod(label: '2 Years', years: 2.0),
    TimePeriod(label: '3 Years', years: 3.0),
    TimePeriod(label: '5 Years', years: 5.0),
  ];

  final Map<String, String> _detailedInfo = {
    'investment': 'Total capital needed (equipment, property, inventory)',
    'revenue': 'Expected annual income from all business activities',
    'costs': 'Annual running expenses (materials, labor, rent, etc.)',
  };

  late Currency _selectedCurrency;
  late TimePeriod _selectedPeriod;
  late NumberFormat _currencyFormat;

  static const Color primaryYellow = Color(0xFFFFB800);
  static const Color accentYellow = Color(0xFFFFC947);
  static const Color lightYellow = Color(0xFFFFFBF2);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color cardBg = Colors.white;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = _currencies.firstWhere((currency) => currency.code == 'INR');
    _selectedPeriod = _timePeriods.firstWhere((period) => period.years == 1.0);
    _updateCurrencyFormat();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _investmentController.dispose();
    _revenueController.dispose();
    _operatingCostsController.dispose();
    _animationController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  void _updateCurrencyFormat() {
    _currencyFormat = NumberFormat.currency(
      symbol: _selectedCurrency.symbol,
      decimalDigits: 2,
    );
  }

  double? _parseAmount(String value) {
    if (value.isEmpty) return null;
    String numericValue = value.replaceAll(RegExp(r'[^0-9.-]'), '');
    return double.tryParse(numericValue);
  }

  String _formatAmount(double amount) {
    return _currencyFormat
        .format(amount)
        .replaceAll(_currencyFormat.currencySymbol, '')
        .trim();
  }

  double _convertCurrency(double amount, Currency from, Currency to) {
    double inUSD = amount / from.conversionRate;
    return inUSD * to.conversionRate;
  }

  void _handleCurrencyChange(Currency? newCurrency) {
    if (newCurrency != null && newCurrency != _selectedCurrency) {
      setState(() {
        Currency oldCurrency = _selectedCurrency;
        _selectedCurrency = newCurrency;
        _updateCurrencyFormat();

        void convertAndUpdate(TextEditingController controller) {
          final double? value = _parseAmount(controller.text);
          if (value != null) {
            double converted = _convertCurrency(value, oldCurrency, newCurrency);
            controller.text = _formatAmount(converted);
          }
        }

        convertAndUpdate(_investmentController);
        convertAndUpdate(_revenueController);
        convertAndUpdate(_operatingCostsController);

        if (_hasCalculated) {
          _calculateROI();
        }
      });
    }
  }

  void _calculateROI() {
    if (_formKey.currentState!.validate()) {
      double investment = _parseAmount(_investmentController.text) ?? 0;
      double yearlyRevenue = _parseAmount(_revenueController.text) ?? 0;
      double yearlyOperatingCosts = _parseAmount(_operatingCostsController.text) ?? 0;

      setState(() {
        // Calculate ROIs for all time periods
        _periodROIs.clear();
        _annualizedROIs.clear();

        for (var period in _timePeriods) {
          double periodROI = _calculateTimeBasedROI(
            investment,
            yearlyRevenue,
            yearlyOperatingCosts,
            period.years,
          );
          _periodROIs[period.label] = periodROI;

          if (period.showAnnualized) {
            _annualizedROIs[period.label] = _calculateAnnualizedROI(
              periodROI,
              period.years,
            );
          }
        }

        // Calculate base ROI for selected period
        double timeAdjustedRevenue = yearlyRevenue * _selectedPeriod.years;
        double timeAdjustedCosts = yearlyOperatingCosts * _selectedPeriod.years;
        _netProfit = timeAdjustedRevenue - (investment + timeAdjustedCosts);
        _roi = _periodROIs[_selectedPeriod.label] ?? 0.0;

        _hasCalculated = true;
        _isExpanded = false;
        _expandController.forward();
        _animationController.reset();
        _animationController.forward();
      });
    }
  }

  double _calculateTimeBasedROI(double investment, double yearlyRevenue,
      double yearlyOperatingCosts, double years) {
    double timeAdjustedRevenue = yearlyRevenue * years;
    double timeAdjustedCosts = yearlyOperatingCosts * years;
    double timeAdjustedProfit = timeAdjustedRevenue - (investment + timeAdjustedCosts);
    return investment != 0 ? (timeAdjustedProfit / investment) * 100 : 0;
  }

  double _calculateAnnualizedROI(double roi, double years) {
    return (pow((1 + roi / 100), 1 / years) - 1) * 100;
  }

  String _getAnalysis() {
    if (_roi >= 25) {
      return 'Outstanding return potential! This investment shows strong promise.';
    } else if (_roi >= 15) {
      return 'Strong performance with balanced risk-reward ratio.';
    } else if (_roi >= 5) {
      return 'Decent returns. Consider ways to boost revenue or reduce costs.';
    } else if (_roi >= 0) {
      return 'Minimal returns. Review your business strategy.';
    } else {
      return 'Investment not profitable. Consider revising your approach.';
    }
  }

  Widget _buildCurrencySelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.currency_exchange, color: primaryYellow, size: 20),
              const SizedBox(width: 8),
              Text(
                'Select Currency',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<Currency>(
            value: _selectedCurrency,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: _currencies.map((Currency currency) {
              return DropdownMenuItem<Currency>(
                value: currency,
                child: Text(
                  '${currency.symbol} - ${currency.name}',
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: _handleCurrencyChange,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer, color: primaryYellow, size: 20),
              const SizedBox(width: 8),
              Text(
                'Select Time Period',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<TimePeriod>(
            value: _selectedPeriod,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: _timePeriods.map((TimePeriod period) {
              return DropdownMenuItem<TimePeriod>(
                value: period,
                child: Text(
                  period.label,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (TimePeriod? newPeriod) {
              if (newPeriod != null) {
                setState(() {
                  _selectedPeriod = newPeriod;
                  if (_hasCalculated) {
                    _calculateROI();
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String detailType,
  }) {
    bool showInfo = detailType == 'investment'
        ? _showInvestmentInfo
        : detailType == 'revenue'
        ? _showRevenueInfo
        : _showCostsInfo;

    void toggleInfo() {
      setState(() {
        if (detailType == 'investment') {
          _showInvestmentInfo = !_showInvestmentInfo;
          _showRevenueInfo = false;
          _showCostsInfo = false;
        } else if (detailType == 'revenue') {
          _showRevenueInfo = !_showRevenueInfo;
          _showInvestmentInfo = false;
          _showCostsInfo = false;
        } else {
          _showCostsInfo = !_showCostsInfo;
          _showInvestmentInfo = false;
          _showRevenueInfo = false;
        }
      });
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: toggleInfo,
                child: Icon(
                  showInfo ? Icons.info : Icons.info_outline,
                  color: showInfo ? primaryYellow : Colors.grey[400],
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 16, color: textDark),
            decoration: InputDecoration(
              prefixText: '${_selectedCurrency.symbol} ',
              prefixStyle: const TextStyle(
                color: textDark,
                fontSize: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: primaryYellow, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.-]')),
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.isEmpty) return newValue;
                if (newValue.text.split('.').length > 2) return oldValue;
                if (newValue.text.contains('-') &&
                    newValue.text.indexOf('-') != 0) {
                  return oldValue;
                }
                if (double.tryParse(newValue.text) != null) {
                  return newValue;
                }
                return oldValue;
              }),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              final double? number = double.tryParse(value);
              if (number == null) {
                return 'Please enter a valid number';
              }
              if (number < 0 &&
                  (label.contains('Revenue') || label.contains('Investment'))) {
                return '$label cannot be negative';
              }
              return null;
            },
            onChanged: (_) => setState(() {}),
          ),
          if (showInfo)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    detailType == 'investment'
                        ? Icons.account_balance_wallet
                        : detailType == 'revenue'
                        ? Icons.trending_up
                        : Icons.price_change,
                    color: primaryYellow,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _detailedInfo[detailType] ?? '',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required Widget child,
    required IconData icon,
  }) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                    if (_isExpanded) {
                      _expandController.reverse();
                    } else {
                      _expandController.forward();
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(icon, color: primaryYellow, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              ClipRect(
                child: AnimatedBuilder(
                  animation: _expandAnimation,
                  builder: (context, child) {
                    return SizeTransition(
                      sizeFactor: Tween<double>(
                        begin: 1.0,
                        end: 0.0,
                      ).animate(_expandAnimation),
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildCustomCard({
    required String title,
    required Widget child,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryYellow, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 40.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    _buildMetricsOverview(),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0,right: 12),
                      child: _buildPeriodSelector(),
                    ),
                    _buildAnalysisSection(),
                    _buildDisclaimer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 16.0 : 24.0;
    final titleSize = screenWidth < 400 ? 20.0 : 24.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryYellow.withOpacity(0.05),
            primaryYellow.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Investment Summary',
                  style: TextStyle(
                    color: textDark,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Updated ${DateFormat('MMM d, y').format(DateTime.now())}',
                  style: TextStyle(
                    color: textDark.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.analytics_outlined,
              color: primaryYellow,
              size: screenWidth < 400 ? 20 : 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsOverview() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 16.0 : 24.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 340;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isNarrow) ...[
                _buildMetricCard(
                  title: 'Annual ROI',
                  value: '${_roi.toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                  isPositive: _roi > 0,
                  gradient: [
                    _roi > 0 ? Colors.green.shade50 : Colors.red.shade50,
                    _roi > 0 ? Colors.green.shade100 : Colors.red.shade100,
                  ],
                ),
                const SizedBox(height: 16),
                _buildMetricCard(
                  title: 'Net Profit',
                  value: _currencyFormat.format(_netProfit),
                  icon: Icons.attach_money,
                  isPositive: _netProfit > 0,
                  gradient: [
                    primaryYellow.withOpacity(0.05),
                    primaryYellow.withOpacity(0.1),
                  ],
                ),
              ] else
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Annual ROI',
                        value: '${_roi.toStringAsFixed(1)}%',
                        icon: Icons.trending_up,
                        isPositive: _roi > 0,
                        gradient: [
                          _roi > 0 ? Colors.green.shade50 : Colors.red.shade50,
                          _roi > 0 ? Colors.green.shade100 : Colors.red.shade100,
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildMetricCard(
                        title: 'Net Profit',
                        value: _currencyFormat.format(_netProfit),
                        icon: Icons.attach_money,
                        isPositive: _netProfit > 0,
                        gradient: [
                          primaryYellow.withOpacity(0.05),
                          primaryYellow.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnalysisSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 16.0 : 24.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Analysis',
            style: TextStyle(
              color: textDark,
              fontSize: screenWidth < 400 ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: primaryYellow.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryYellow.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Text(
              _getAnalysis(),
              style: TextStyle(
                color: textDark.withOpacity(0.8),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isPositive,
    required List<Color> gradient,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final valueFontSize = screenWidth < 400 ? 20.0 : 24.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryYellow.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textDark.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: textDark,
                fontSize: valueFontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth < 400 ? 16.0 : 24.0;

    return Container(
      margin: EdgeInsets.fromLTRB(padding, 0, padding, padding),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This is an approximate calculation. Actual returns may vary based on market conditions.',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ROI Calculator',
          style: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCustomCard(
                title: 'What is ROI?',
                icon: Icons.info_outline,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Return on Investment (ROI) helps you evaluate potential returns from your investment.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Process: We compare your costs with expected revenue to determine the potential return percentage on your investment.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              _buildExpandableCard(
                title: 'Investment Details',
                icon: Icons.account_balance_wallet,
                child: Column(
                  children: [
                    _buildCurrencySelector(),
                    _buildPeriodSelector(),
                    _buildInputField(
                      label: 'Initial Investment',
                      controller: _investmentController,
                      detailType: 'investment',
                    ),
                    _buildInputField(
                      label: 'Projected Annual Revenue',
                      controller: _revenueController,
                      detailType: 'revenue',
                    ),
                    _buildInputField(
                      label: 'Annual Operating Costs',
                      controller: _operatingCostsController,
                      detailType: 'costs',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculateROI,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryYellow,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.calculate_outlined, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Calculate ROI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (_hasCalculated) _buildResultCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class demobusinessvaluation extends StatefulWidget {
  @override
  _demobusinessvaluationState createState() => _demobusinessvaluationState();
}

class _demobusinessvaluationState extends State<demobusinessvaluation> {
  final TextEditingController revenueController = TextEditingController();
  final TextEditingController ebitdaController = TextEditingController();
  final TextEditingController netIncomeController = TextEditingController();
  final TextEditingController enterpriseValueController = TextEditingController();
  final TextEditingController multipleMetricController = TextEditingController();

  double businessValue = 0.0;
  String selectedCriteria = 'Low Profitability';
  String selectedMetric = 'Revenue';
  String selectedMultipleMetric = 'EBITDA';
  double multiple = 0.0;

  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  void updateMetric() {
    switch (selectedCriteria) {
      case 'Low Profitability':
        selectedMetric = 'Revenue';
        break;
      case 'Profitability Based':
        selectedMetric = 'Net Income';
        break;
      case 'Normal':
        selectedMetric = 'EBITDA';
        break;
    }
    setState(() {});
  }

  void calculateBusinessValue() {
    double metricValue = 0.0;
    double enterpriseValue = double.tryParse(enterpriseValueController.text) ?? 0.0;
    double multipleMetricValue = double.tryParse(multipleMetricController.text) ?? 0.0;

    multiple = enterpriseValue / (multipleMetricValue != 0 ? multipleMetricValue : 1);

    switch (selectedMetric) {
      case 'Revenue':
        metricValue = double.tryParse(revenueController.text) ?? 0.0;
        break;
      case 'EBITDA':
        metricValue = double.tryParse(ebitdaController.text) ?? 0.0;
        break;
      case 'Net Income':
        metricValue = double.tryParse(netIncomeController.text) ?? 0.0;
        break;
    }

    setState(() {
      businessValue = metricValue * multiple;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Business Valuation Calculator')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select the criteria for valuation:'),
              DropdownButton<String>(
                value: selectedCriteria,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCriteria = newValue!;
                    updateMetric();
                  });
                },
                items: ['Low Profitability', 'Profitability Based', 'Normal']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ),
                )
                    .toList(),
              ),
              SizedBox(height: 10),
              Text('Selected Business Metric: $selectedMetric'),
              TextField(
                controller: revenueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Revenue'),
                enabled: selectedMetric == 'Revenue',
              ),
              TextField(
                controller: ebitdaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'EBITDA'),
                enabled: selectedMetric == 'EBITDA',
              ),
              TextField(
                controller: netIncomeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Net Income'),
                enabled: selectedMetric == 'Net Income',
              ),
              TextField(
                controller: enterpriseValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enterprise Value'),
              ),
              SizedBox(height: 10),
              Text('Select the metric for calculating multiple:'),
              DropdownButton<String>(
                value: selectedMultipleMetric,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMultipleMetric = newValue!;
                  });
                },
                items: ['Revenue', 'EBITDA']
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ),
                )
                    .toList(),
              ),
              TextField(
                controller: multipleMetricController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter Revenue or EBITDA Value'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateBusinessValue,
                child: Text('Calculate Business Value'),
              ),
              SizedBox(height: 20),
              Text('Estimated Business Value: ${currencyFormat.format(businessValue)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Calculated Multiple: ${multiple.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    revenueController.dispose();
    ebitdaController.dispose();
    netIncomeController.dispose();
    enterpriseValueController.dispose();
    multipleMetricController.dispose();
    super.dispose();
  }
}

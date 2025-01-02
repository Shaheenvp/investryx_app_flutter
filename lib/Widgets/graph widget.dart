import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../services/graph.dart';

class InvestmentChart extends StatefulWidget {
  @override
  _InvestmentChartState createState() => _InvestmentChartState();
}

class _InvestmentChartState extends State<InvestmentChart> {
  List<ChartData> _chartData = [];
  bool _isLoading = true;
  int _totalValue = 0;
  int _investValue = 0;

  @override
  void initState() {
    super.initState();
    _fetchGraphData();
  }

  Future<void> _fetchGraphData() async {
    var graphData = await GraphService.fetchGraph();
    if (graphData != null) {
      setState(() {
        _chartData = _convertGraphDataToChartData(graphData);
        _totalValue = graphData.totalValue;
        _investValue = graphData.investValue;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String formatLargeNumber(num number) {
    if (number >= 1000000000000) {
      return '${(number / 1000000000000).toStringAsFixed(1)}T';
    } else if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(1)}Cr';
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(1);
    }
  }

  List<ChartData> _convertGraphDataToChartData(GraphData graphData) {
    List<ChartData> chartData = [];

    // Combine all months from business, investor, and franchise data
    Set<int> allMonths = Set<int>();
    allMonths.addAll(graphData.business.map((b) => b.month));
    allMonths.addAll(graphData.investor.map((i) => i.month));
    allMonths.addAll(graphData.franchise.map((f) => f.month));

    // Sort months in ascending order
    List<int> sortedMonths = allMonths.toList()..sort();

    for (int month in sortedMonths) {
      String monthName = _getMonthName(month);

      double businessRate = graphData.business
          .firstWhere((b) => b.month == month, orElse: () => GraphDetails(month: month, totalRate: 0))
          .totalRate
          ?.toDouble() ?? 0.0;

      double investorRate = graphData.investor
          .firstWhere((i) => i.month == month, orElse: () => GraphDetails(month: month, totalRate: 0))
          .totalRate
          ?.toDouble() ?? 0.0;

      double franchiseRate = graphData.franchise
          .firstWhere((f) => f.month == month, orElse: () => GraphDetails(month: month, totalRate: 0))
          .totalRate
          ?.toDouble() ?? 0.0;

      chartData.add(ChartData(monthName, investorRate, businessRate, franchiseRate));
    }

    return chartData;
  }

  String _getMonthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[(month - 1) % 12];
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(375, 812));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Business Analysis', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${formatLargeNumber(_investValue)}',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        'Invested',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${formatLargeNumber(_totalValue)}',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        'Turnover',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: _isLoading
                    ? _buildShimmerLoading()
                    : SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    labelStyle: TextStyle(fontSize: 10.sp),
                  ),
                  primaryYAxis: NumericAxis(
                    labelStyle: TextStyle(fontSize: 10.sp),
                    numberFormat: NumberFormat.compact(),
                    axisBorderType: AxisBorderType.withoutTopAndBottom,
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    textStyle: TextStyle(fontSize: 12.sp),
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    format: 'point.x : ₹point.y',
                  ),
                  series: <CartesianSeries>[
                    SplineSeries<ChartData, String>(
                      name: 'Business',
                      dataSource: _chartData,
                      xValueMapper: (ChartData data, _) => data.month,
                      yValueMapper: (ChartData data, _) => data.turnover,
                      color: Colors.blue,
                    ),
                    SplineSeries<ChartData, String>(
                      name: 'Invested',
                      dataSource: _chartData,
                      xValueMapper: (ChartData data, _) => data.month,
                      yValueMapper: (ChartData data, _) => data.invested,
                      color: Colors.orange,
                    ),
                    SplineSeries<ChartData, String>(
                      name: 'Franchise',
                      dataSource: _chartData,
                      xValueMapper: (ChartData data, _) => data.month,
                      yValueMapper: (ChartData data, _) => data.other,
                      color: Colors.yellow,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200.h,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            height: 20.h,
            color: Colors.grey[300],
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            height: 20.h,
            color: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String month;
  final double invested;
  final double turnover;
  final double other;

  ChartData(this.month, this.invested, this.turnover, this.other);
}
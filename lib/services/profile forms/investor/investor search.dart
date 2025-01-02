import 'investor explore.dart';

class SearchService {
  static Future<List<InvestorExplr>> searchInvestor(String query) async {
    final investments = await InvestorExplore.fetchInvestorData();
    if (investments == null) {
      return [];
    }
    return investments
        .where((investment) =>
            investment.companyName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

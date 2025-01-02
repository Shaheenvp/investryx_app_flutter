import 'package:project_emergio/services/profile%20forms/franchise/franchise%20explore.dart';

class SearchService {
  static Future<List<FranchiseExplr>> searchFranchises(String query) async {
    final franchises = await FranchiseExplore.fetchFranchiseData();
    if (franchises == null) {
      return [];
    }
    return franchises
        .where((franchise) =>
            franchise.brandName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

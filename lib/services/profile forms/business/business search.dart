import 'business explore.dart';

class SearchService {
  static Future<List<BusinessExplr>> searchBusinesses(String query) async {
    final businesses = await BusinessExplore.fetchBusinessExplore();
    if (businesses == null) {
      return [];
    }
    return businesses
        .where((business) =>
            business.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

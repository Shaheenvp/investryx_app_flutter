import 'package:get/get.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/services/featured.dart';
import 'package:project_emergio/services/latest%20transactions%20and%20activites.dart';
import 'package:project_emergio/services/recommended%20ads.dart';
import 'package:project_emergio/services/search.dart';

class ExploreFilterController extends GetxController {


  RxList<BusinessInvestorExplr> recentBusinessInvestorLists =
      <BusinessInvestorExplr>[].obs;
  RxList<BusinessInvestorExplr> featuredBusinessInvestorLists =
      <BusinessInvestorExplr>[].obs;
  RxList<BusinessInvestorExplr> recommednedBusinessInvestorLists =
      <BusinessInvestorExplr>[].obs;

  // franchise
  RxList<FranchiseExplr> recentFranchiseLists =
      <FranchiseExplr>[].obs;
  RxList<FranchiseExplr> featuredFranchiseLists =
      <FranchiseExplr>[].obs;
  RxList<FranchiseExplr> recommednedFranchiseLists =
      <FranchiseExplr>[].obs;

  RxBool isLoading = false.obs;
  RxBool isFilter = false.obs;
  RxList filterLists = <String>[].obs;

  RxList<BusinessInvestorExplr> businessLists = <BusinessInvestorExplr>[].obs;
  RxBool loading = true.obs;
  RxBool isError = false.obs;

  void clearSearchFilter() {
    recentBusinessInvestorLists.value = [];
    featuredBusinessInvestorLists.value = [];
    recommednedBusinessInvestorLists.value = [];
  }

  void filterExploreScreens(
      {String city = '',
        String state = '',
        String industry = '',
        String establishYearFrom = '',
        String establishYearTo = '',
        String rangeStarting = '',
        String rangeEnding = '',
        String preference = '',
        String entity = '',
        required String type,
        String explore = '',
        String ebitda = ''}) async {
    try {
      isLoading.value = true;

      final response = await SearchServices().searchFilter(
        city: city,
        ebitda: ebitda,
        entityType: type,
        entity: entity,
        establishFrom: establishYearFrom,
        establishTo: establishYearTo,
        industry: industry,
        preference: preference,
        rangeEnding: rangeEnding,
        rangeStarting: rangeStarting,
      );
      print("Search filter result in controller  $response");

      final recentdata = await LatestTransactions.fetchRecentPosts(type);
      final featureddata =
      await Featured.fetchFeaturedLists(profile: type);
      final recommendeddata = await RecommendedAds.fetchRecommended();

      List<SearchResult> resulsts = response["results"];
      final ids = resulsts.map((e) {
        return e.id;
      }).toSet();

      if (type == "business" || type == "investor") {
        if (recentdata != null) {
          List<BusinessInvestorExplr> data = type == "business" ? recentdata["business_data"] : recentdata["investor_data"];

          recentBusinessInvestorLists.value =
              data.where((item) => ids.contains(item.id)).toList();
        }


        if (featureddata != null) {
          List<BusinessInvestorExplr> data = type == "business" ? featureddata["business_data"] : featureddata["investor_data"];

          featuredBusinessInvestorLists.value =
              data.where((item) => ids.contains(item.id)).toList();
        }

        if (recommendeddata != null) {
          List<BusinessInvestorExplr> data = type == "business" ? recommendeddata["business_data"] : recommendeddata["investor_data"];

          recommednedBusinessInvestorLists.value =
              data.where((item) => ids.contains(item.id)).toList();
        }
        isLoading.value = false;
      } else {
        // franchise

        if (recentdata != null) {
          List<FranchiseExplr> data = recentdata["franchise_data"];

          recentFranchiseLists.value =
              data.where((item) => ids.contains(item.id)).toList();
        }



        if (featureddata != null) {
          List<FranchiseExplr> data = featureddata["franchise_data"];

          featuredFranchiseLists.value =
              data.where((item) => ids.contains(item.id)).toList();
        }

        if (recommendeddata != null) {
          List<FranchiseExplr> data = recommendeddata["franchise_data"];

          recommednedFranchiseLists.value =
              data.where((item) => ids.contains(item.id)).toList();
        }
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      isError.value = true;
      print("Search filter result in controller catch  $e");
    }
    }

}

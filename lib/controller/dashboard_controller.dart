// import 'package:get/get.dart';
// import '../models/all profile model.dart';
// import '../services/profile forms/advisor/advisor get.dart';
// import '../services/profile forms/business/business get.dart';
// import '../services/profile forms/franchise/franchise get.dart';
// import '../services/profile forms/investor/investor get.dart';
// import '../services/recent_enquries.dart';
//
// class DashboardController extends GetxController {
//   final RxList<BusinessInvestorExplr> businessInvestorList = <BusinessInvestorExplr>[].obs;
//   final RxList<FranchiseExplr> franchiseLists = <FranchiseExplr>[].obs;
//   final RxList<AdvisorExplr> advisorList = <AdvisorExplr>[].obs;
//   final RxBool isLoading = false.obs;
//   final Rx<String?> currentProfileId = Rx<String?>(null);
//   final RxString errorMessage = ''.obs;
//   final RxString currentType = ''.obs;
//
//   // Cache variables
//   String? _lastFetchedType;
//   String? _lastFetchedId;
//
//   // Cache for enquiry data
//   final Rx<EnquiryCounts?> enquiryCounts = Rx<EnquiryCounts?>(null);
//   final RxList<enquiry> recentEnquiries = <enquiry>[].obs;
//
//
//   Future<void> initializeWithProfile(String type, String? profileId) async {
//     if (profileId == null || type.isEmpty) return;
//
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       currentProfileId.value = profileId;
//       currentType.value = type.toLowerCase();
//
//       await Future.wait([
//         fetchListings(type, profileId: profileId, forceRefresh: true),
//         _fetchEnquiryData(profileId),
//       ]);
//
//       _lastFetchedType = type;
//       _lastFetchedId = profileId;
//     } catch (e) {
//       print('Error initializing dashboard: $e');
//       errorMessage.value = 'Failed to initialize dashboard: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Update current profile (for business/investor)
//   Future<void> updateCurrentProfile(BusinessInvestorExplr newProfile) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       // Update current profile ID
//       currentProfileId.value = newProfile.id;
//
//       // Update the list with the new profile
//       if (businessInvestorList.isNotEmpty) {
//         final index = businessInvestorList.indexWhere((profile) => profile.id == newProfile.id);
//         if (index != -1) {
//           businessInvestorList[index] = newProfile;
//         } else {
//           businessInvestorList.value = [newProfile];
//         }
//       } else {
//         businessInvestorList.value = [newProfile];
//       }
//
//       // Refresh all data for the new profile
//       await Future.wait([
//         fetchListings(_lastFetchedType ?? "business",
//             profileId: newProfile.id,
//             forceRefresh: true
//         ),
//         _fetchEnquiryData(newProfile.id),
//       ]);
//
//       _lastFetchedId = newProfile.id;
//
//     } catch (e) {
//       print('Error updating profile: $e');
//       errorMessage.value = 'Failed to update profile: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Update current franchise profile
//   Future<void> updateCurrentFranchiseProfile(FranchiseExplr newProfile) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       currentProfileId.value = newProfile.id;
//
//       if (franchiseLists.isNotEmpty) {
//         final index = franchiseLists.indexWhere((profile) => profile.id == newProfile.id);
//         if (index != -1) {
//           franchiseLists[index] = newProfile;
//         } else {
//           franchiseLists.value = [newProfile];
//         }
//       } else {
//         franchiseLists.value = [newProfile];
//       }
//
//       await Future.wait([
//         fetchListings('franchise', profileId: newProfile.id, forceRefresh: true),
//         _fetchEnquiryData(newProfile.id),
//       ]);
//
//       _lastFetchedId = newProfile.id;
//     } catch (e) {
//       print('Error updating franchise profile: $e');
//       errorMessage.value = 'Failed to update profile: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Fetch listings with error handling
//   Future<void> fetchListings(String type, {String? profileId, bool forceRefresh = false}) async {
//     if (isLoading.value && !forceRefresh) return;
//     if (!forceRefresh && type == _lastFetchedType && profileId == _lastFetchedId) return;
//
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       if (profileId != null) {
//         currentProfileId.value = profileId;
//       }
//
//       final result = await _fetchDataByType(type);
//
//       if (result != null && result.isNotEmpty) {
//         if (profileId != null) {
//           _updateListsWithFilter(type, result, profileId);
//         } else {
//           _updateLists(type, result);
//         }
//       } else {
//         _clearLists();
//       }
//
//       _lastFetchedType = type;
//       if (profileId != null) {
//         _lastFetchedId = profileId;
//       }
//
//     } catch (e) {
//       print('Error fetching listings: $e');
//       errorMessage.value = 'Failed to fetch listings: ${e.toString()}';
//       _clearLists();
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Fetch enquiry related data
//   Future<void> _fetchEnquiryData(String profileId) async {
//     try {
//       final counts = await RecentEnquiries.fetchEnquiriesCounts(id: profileId);
//       enquiryCounts.value = counts;
//
//       final enquiries = await RecentEnquiries.fetchEnquiries(id: profileId);
//       if (enquiries != null) {
//         recentEnquiries.value = enquiries;
//       } else {
//         recentEnquiries.clear();
//       }
//     } catch (e) {
//       print('Error fetching enquiry data: $e');
//       enquiryCounts.value = null;
//       recentEnquiries.clear();
//     }
//   }
//
//   // Fetch data based on type
//   Future<List<dynamic>?> _fetchDataByType(String type) async {
//     switch (type.toLowerCase()) {
//       case "business":
//         return await BusinessGet.fetchBusinessListings();
//       case "investor":
//         return await InvestorFetchPage.fetchInvestorData();
//       case "franchise":
//         return await FranchiseFetchPage.fetchFranchiseData();
//       case "advisor":
//         final advisors = await AdvisorFetchPage.fetchAdvisorData();
//         return advisors;
//       default:
//         throw ArgumentError('Invalid type: $type');
//     }
//   }
//
//   // Update lists with filter
//   void _updateListsWithFilter(String type, List<dynamic> data, String profileId) {
//     switch (type.toLowerCase()) {
//       case "advisor":
//         final typedData = data.cast<AdvisorExplr>();
//         final filteredList = typedData.where((profile) => profile.id == profileId).toList();
//         advisorList.value = filteredList.isNotEmpty ? filteredList : [typedData.first];
//         break;
//       case "franchise":
//         final typedData = data as List<FranchiseExplr>;
//         final filteredList = typedData.where((profile) => profile.id == profileId).toList();
//         franchiseLists.value = filteredList.isNotEmpty ? filteredList : [typedData.first];
//         break;
//       default:
//         final typedData = data as List<BusinessInvestorExplr>;
//         final filteredList = typedData.where((profile) => profile.id == profileId).toList();
//         businessInvestorList.value = filteredList.isNotEmpty ? filteredList : [typedData.first];
//     }
//   }
//
//   // Update lists without filter
//   void _updateLists(String type, List<dynamic>? data) {
//     switch (type.toLowerCase()) {
//       case "advisor":
//         advisorList.value = (data?.cast<AdvisorExplr>()) ?? [];
//         break;
//       case "franchise":
//         franchiseLists.value = (data as List<FranchiseExplr>?) ?? [];
//         break;
//       default:
//         businessInvestorList.value = (data as List<BusinessInvestorExplr>?) ?? [];
//     }
//   }
//
//   // Update current advisor profile
//   Future<void> updateCurrentAdvisorProfile(AdvisorExplr newProfile) async { // Changed from Advisor to AdvisorExplr
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//       currentProfileId.value = newProfile.id;
//
//       if (advisorList.isNotEmpty) {
//         final index = advisorList.indexWhere((profile) => profile.id == newProfile.id);
//         if (index != -1) {
//           advisorList[index] = newProfile;
//         } else {
//           advisorList.value = [newProfile];
//         }
//       } else {
//         advisorList.value = [newProfile];
//       }
//
//       await Future.wait([
//         fetchListings('advisor', profileId: newProfile.id, forceRefresh: true),
//         _fetchEnquiryData(newProfile.id),
//       ]);
//
//       _lastFetchedId = newProfile.id;
//     } catch (e) {
//       print('Error updating advisor profile: $e');
//       errorMessage.value = 'Failed to update profile: ${e.toString()}';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Clear lists
//   void _clearLists() {
//     businessInvestorList.clear();
//     franchiseLists.clear();
//     advisorList.clear();
//     recentEnquiries.clear();
//     enquiryCounts.value = null;
//   }
//
//
//   // Refresh all data
//   Future<void> refreshAllData() async {
//     if (_lastFetchedType != null && currentProfileId.value != null) {
//       await initializeWithProfile(_lastFetchedType!, currentProfileId.value);
//     }
//   }
//
//   // Reset controller
//   void reset() {
//     _lastFetchedType = null;
//     _lastFetchedId = null;
//     currentProfileId.value = null;
//     currentType.value = '';
//     _clearLists();
//     errorMessage.value = '';
//   }
//
//   @override
//   void onClose() {
//     reset();
//     super.onClose();
//   }
// }



import 'package:get/get.dart';
import '../models/all profile model.dart';
import '../services/profile forms/advisor/advisor get.dart';
import '../services/profile forms/business/business get.dart';
import '../services/profile forms/franchise/franchise get.dart';
import '../services/profile forms/investor/investor get.dart';
import '../services/recent_enquries.dart';

class DashboardController extends GetxController {
  final RxList<BusinessInvestorExplr> businessInvestorList = <BusinessInvestorExplr>[].obs;
  final RxList<FranchiseExplr> franchiseLists = <FranchiseExplr>[].obs;
  final RxList<AdvisorExplr> advisorList = <AdvisorExplr>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<String?> currentProfileId = Rx<String?>(null);
  final RxString errorMessage = ''.obs;
  final RxString currentType = ''.obs;

  // Cache variables
  String? _lastFetchedType;
  String? _lastFetchedId;

  // Cache for enquiry data
  final Rx<EnquiryCounts?> enquiryCounts = Rx<EnquiryCounts?>(null);
  final RxList<enquiry> recentEnquiries = <enquiry>[].obs;


  Future<void> initializeWithProfile(String type, String? profileId) async {
    if (profileId == null || type.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentProfileId.value = profileId;
      currentType.value = type.toLowerCase();

      await Future.wait([
        fetchListings(type, profileId: profileId, forceRefresh: true),
        _fetchEnquiryData(profileId),
      ]);

      _lastFetchedType = type;
      _lastFetchedId = profileId;
    } catch (e) {
      print('Error initializing dashboard: $e');
      errorMessage.value = 'Failed to initialize dashboard: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Update current profile (for business/investor)
  Future<void> updateCurrentProfile(BusinessInvestorExplr newProfile) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Update current profile ID
      currentProfileId.value = newProfile.id;

      // Update the list with the new profile
      if (businessInvestorList.isNotEmpty) {
        final index = businessInvestorList.indexWhere((profile) => profile.id == newProfile.id);
        if (index != -1) {
          businessInvestorList[index] = newProfile;
        } else {
          businessInvestorList.value = [newProfile];
        }
      } else {
        businessInvestorList.value = [newProfile];
      }

      // Refresh all data for the new profile
      await Future.wait([
        fetchListings(_lastFetchedType ?? "business",
            profileId: newProfile.id,
            forceRefresh: true
        ),
        _fetchEnquiryData(newProfile.id),
      ]);

      _lastFetchedId = newProfile.id;

    } catch (e) {
      print('Error updating profile: $e');
      errorMessage.value = 'Failed to update profile: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Update current franchise profile
  Future<void> updateCurrentFranchiseProfile(FranchiseExplr newProfile) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentProfileId.value = newProfile.id;

      if (franchiseLists.isNotEmpty) {
        final index = franchiseLists.indexWhere((profile) => profile.id == newProfile.id);
        if (index != -1) {
          franchiseLists[index] = newProfile;
        } else {
          franchiseLists.value = [newProfile];
        }
      } else {
        franchiseLists.value = [newProfile];
      }

      await Future.wait([
        fetchListings('franchise', profileId: newProfile.id, forceRefresh: true),
        _fetchEnquiryData(newProfile.id),
      ]);

      _lastFetchedId = newProfile.id;
    } catch (e) {
      print('Error updating franchise profile: $e');
      errorMessage.value = 'Failed to update profile: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch listings with error handling
  Future<void> fetchListings(String type, {String? profileId, bool forceRefresh = false}) async {
    if (isLoading.value && !forceRefresh) return;
    if (!forceRefresh && type == _lastFetchedType && profileId == _lastFetchedId) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (profileId != null) {
        currentProfileId.value = profileId;
      }

      final result = await _fetchDataByType(type);

      if (result != null && result.isNotEmpty) {
        if (profileId != null) {
          _updateListsWithFilter(type, result, profileId);
        } else {
          _updateLists(type, result);
        }
      } else {
        _clearLists();
      }

      _lastFetchedType = type;
      if (profileId != null) {
        _lastFetchedId = profileId;
      }

    } catch (e) {
      print('Error fetching listings: $e');
      errorMessage.value = 'Failed to fetch listings: ${e.toString()}';
      _clearLists();
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch enquiry related data
  Future<void> _fetchEnquiryData(String profileId) async {
    try {
      final counts = await RecentEnquiries.fetchEnquiriesCounts(id: profileId);
      enquiryCounts.value = counts;

      final enquiries = await RecentEnquiries.fetchEnquiries(id: profileId);
      if (enquiries != null) {
        recentEnquiries.value = enquiries;
      } else {
        recentEnquiries.clear();
      }
    } catch (e) {
      print('Error fetching enquiry data: $e');
      enquiryCounts.value = null;
      recentEnquiries.clear();
    }
  }

  // Fetch data based on type
  Future<List<dynamic>?> _fetchDataByType(String type) async {
    switch (type.toLowerCase()) {
      case "business":
        return await BusinessGet.fetchBusinessListings();
      case "investor":
        return await InvestorFetchPage.fetchInvestorData();
      case "franchise":
        return await FranchiseFetchPage.fetchFranchiseData();
      case "advisor":
        final advisors = await AdvisorFetchPage.fetchAdvisorData();
        return advisors;
      default:
        throw ArgumentError('Invalid type: $type');
    }
  }

  // Update lists with filter
  void _updateListsWithFilter(String type, List<dynamic> data, String profileId) {
    switch (type.toLowerCase()) {
      case "advisor":
        final typedData = data.cast<AdvisorExplr>();
        final filteredList = typedData.where((profile) => profile.id == profileId).toList();
        advisorList.value = filteredList.isNotEmpty ? filteredList : [typedData.first];
        break;
      case "franchise":
        final typedData = data as List<FranchiseExplr>;
        final filteredList = typedData.where((profile) => profile.id == profileId).toList();
        franchiseLists.value = filteredList.isNotEmpty ? filteredList : [typedData.first];
        break;
      default:
        final typedData = data as List<BusinessInvestorExplr>;
        final filteredList = typedData.where((profile) => profile.id == profileId).toList();
        businessInvestorList.value = filteredList.isNotEmpty ? filteredList : [typedData.first];
    }
  }

  // Update lists without filter
  void _updateLists(String type, List<dynamic>? data) {
    switch (type.toLowerCase()) {
      case "advisor":
        advisorList.value = (data?.cast<AdvisorExplr>()) ?? [];
        break;
      case "franchise":
        franchiseLists.value = (data as List<FranchiseExplr>?) ?? [];
        break;
      default:
        businessInvestorList.value = (data as List<BusinessInvestorExplr>?) ?? [];
    }
  }

  // Update current advisor profile
  Future<void> updateCurrentAdvisorProfile(AdvisorExplr newProfile) async { // Changed from Advisor to AdvisorExplr
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentProfileId.value = newProfile.id;

      if (advisorList.isNotEmpty) {
        final index = advisorList.indexWhere((profile) => profile.id == newProfile.id);
        if (index != -1) {
          advisorList[index] = newProfile;
        } else {
          advisorList.value = [newProfile];
        }
      } else {
        advisorList.value = [newProfile];
      }

      await Future.wait([
        fetchListings('advisor', profileId: newProfile.id, forceRefresh: true),
        _fetchEnquiryData(newProfile.id),
      ]);

      _lastFetchedId = newProfile.id;
    } catch (e) {
      print('Error updating advisor profile: $e');
      errorMessage.value = 'Failed to update profile: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Clear lists
  void _clearLists() {
    businessInvestorList.clear();
    franchiseLists.clear();
    advisorList.clear();
    recentEnquiries.clear();
    enquiryCounts.value = null;
  }


  // Refresh all data
  Future<void> refreshAllData() async {
    if (_lastFetchedType != null && currentProfileId.value != null) {
      await initializeWithProfile(_lastFetchedType!, currentProfileId.value);
    }
  }

  // Reset controller
  void reset() {
    _lastFetchedType = null;
    _lastFetchedId = null;
    currentProfileId.value = null;
    currentType.value = '';
    _clearLists();
    errorMessage.value = '';
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }
}
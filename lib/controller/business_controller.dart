import 'package:get/get.dart';
import 'dart:developer';
import '../services/sales_profile.dart';

class BusinessProfileController extends GetxController {
  // Observable variables
  final Rx<salesProfileandImage?> profileData = Rx<salesProfileandImage?>(null);
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Cache management
  DateTime? _lastFetchTime;
  static const cacheDuration = Duration(minutes: 5);

  @override
  void onInit() {
    super.onInit();
    // Initial fetch when controller is initialized
    fetchProfile();
  }

  // Check if cache is valid
  bool get _isCacheValid {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < cacheDuration;
  }

  // Main fetch method
  Future<salesProfileandImage?> fetchProfile() async {
    // Return cached data if valid
    if (_isCacheValid && profileData.value != null) {
      log('Returning cached profile data');
      return profileData.value;
    }

    // Prevent multiple simultaneous fetches
    if (isLoading.value) {
      log('Fetch already in progress, returning current data');
      return profileData.value;
    }

    try {
      log('Fetching fresh profile data');
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final result = await SalesProfile.fetchSalesProfileData(type: "business");

      if (result != null) {
        profileData.value = result;
        _lastFetchTime = DateTime.now();
        log('Profile data updated successfully');
      } else {
        hasError.value = true;
        errorMessage.value = 'No profile data found';
        log('No profile data returned from API');
      }

      return result;
    } catch (e, stackTrace) {
      log('Error fetching profile data: $e');
      log('Stack trace: $stackTrace');
      hasError.value = true;
      errorMessage.value = 'Failed to load profile data';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Force refresh method
  Future<void> refreshProfile() async {
    log('Forcing profile refresh');
    _lastFetchTime = null; // Invalidate cache
    await fetchProfile();
  }

  // Clear profile data (useful for logout)
  void clearProfile() {
    log('Clearing profile data');
    profileData.value = null;
    _lastFetchTime = null;
    isLoading.value = false;
    hasError.value = false;
    errorMessage.value = '';
  }

  // Check if profile exists
  bool get hasProfile => profileData.value != null;

  // Get profile data safely
  saleProfile? get profile => profileData.value?.profile;

  // Get profile image safely
  GetImage? get profileImage => profileData.value?.image;

  @override
  void onClose() {
    // Clean up if needed
    clearProfile();
    super.onClose();
  }
}
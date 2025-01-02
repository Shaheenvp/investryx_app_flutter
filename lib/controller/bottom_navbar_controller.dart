import 'package:get/get.dart';

import '../Widgets/bottom navbar_widget.dart';

class NavigationController extends GetxController {
  final _currentIndex = 0.obs;
  final _userType = 'normal'.obs;
  final _showBusinessIcon = false.obs;

  int get currentIndex => _currentIndex.value;
  String get userType => _userType.value;
  bool get showBusinessIcon => _showBusinessIcon.value;

  void changeIndex(int index) {
    _currentIndex.value = index;
  }

  void showTypeSpecificIcon(String type) {
    _userType.value = type;
    _showBusinessIcon.value = true;
    _currentIndex.value = 2;
  }

  void hideTypeSpecificIcon() {
    Get.offAll(() => const CustomBottomNavBar());
    Future.microtask(() {
      _userType.value = 'normal';
      _showBusinessIcon.value = false;
      _currentIndex.value = 0;
    });
  }
}
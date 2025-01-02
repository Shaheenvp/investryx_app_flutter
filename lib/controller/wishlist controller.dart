// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../models/all profile model.dart';
// import '../services/wishlist.dart';
//
//
// class WishlistController extends GetxController {
//   var isAddedToWishlist = false.obs;
//   var isLoading = true.obs;
//   var wishlistItems = <ProductDetails>[].obs;
//   var wishlistAllItems = <BusinessInvestorExplr>[].obs;
//   var wishlistFranchiseItems = <FranchiseExplr>[].obs;
//
//   Future<void> fetchWishlistItems() async {
//     isLoading(true);
//     try {
//       var data = await WishList.fetchWishlistData();
//       if (data != null) {
//         wishlistItems.assignAll(data['wishlist'] ?? []);
//         wishlistAllItems.assignAll(data['wishlistAll'] ?? []);
//         wishlistFranchiseItems.assignAll(data['wishlistFranchiseItems'] ?? []);
//       }
//     } catch (e) {
//       print('Error fetching wishlist items: $e');
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   Future<void> checkIfItemInWishlist(String userId, String productId) async {
//     var data = await WishList.fetchWishlistData();
//     if (data != null) {
//       isAddedToWishlist.value = data['wishlist'].any((item) => item.id == productId);
//     }
//   }
//
//   void toggleWishlist(String userId, String productId) async {
//     try {
//       if (isAddedToWishlist.value) {
//         final success = await WishList.removeFromWishlist(productId: productId);
//         if (success != null && success) {
//           isAddedToWishlist.value = false;
//           Get.snackbar(
//             'Success',
//             'Item removed from wishlist successfully!',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.black54,
//             colorText: Colors.white,
//             borderRadius: 8,
//             margin: EdgeInsets.all(10),
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           );
//         } else {
//           Get.snackbar(
//             'Failed',
//             'Failed to remove item from wishlist.',
//             backgroundColor: Colors.black54,
//             colorText: Colors.white,
//             snackPosition: SnackPosition.BOTTOM,
//             borderRadius: 8,
//             margin: EdgeInsets.all(10),
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           );
//         }
//       } else {
//         final success = await WishList.wishList(productId: productId);
//         if (success != null && success) {
//           isAddedToWishlist.value = true;
//           Get.snackbar(
//             'Success',
//             'Item added to wishlist successfully!',
//             backgroundColor: Colors.black54,
//             colorText: Colors.white,
//             snackPosition: SnackPosition.BOTTOM,
//             borderRadius: 8,
//             margin: EdgeInsets.all(10),
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           );
//         } else {
//           Get.snackbar(
//             'Failed',
//             'Failed to add item to wishlist.',
//             backgroundColor: Colors.black54,
//             colorText: Colors.white,
//             snackPosition: SnackPosition.BOTTOM,
//             borderRadius: 8,
//             margin: EdgeInsets.all(10),
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//           );
//         }
//       }
//       // Refresh the wishlist after toggling
//       await fetchWishlistItems();
//     } catch (e) {
//       isAddedToWishlist.value = false;
//       Get.snackbar(
//         'Error',
//         'An unexpected error occurred. Please try again.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/all profile model.dart';
import '../services/wishlist.dart';

class WishlistController extends GetxController {
  // Existing variables
  var isAddedToWishlist = false.obs;
  var isLoading = true.obs;
  var wishlistItems = <ProductDetails>[].obs;
  var wishlistAllItems = <BusinessInvestorExplr>[].obs;
  var wishlistFranchiseItems = <FranchiseExplr>[].obs;

  // Categorized items
  var businessItems = <ProductDetails>[].obs;
  var franchiseItems = <ProductDetails>[].obs;
  var investorItems = <ProductDetails>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlistItems();
  }

  Future<void> fetchWishlistItems() async {
    isLoading(true);
    try {
      var data = await WishList.fetchWishlistData();
      if (data != null) {
        wishlistItems.assignAll(data['wishlist'] ?? []);
        wishlistAllItems.assignAll(data['wishlistAll'] ?? []);
        wishlistFranchiseItems.assignAll(data['wishlistFranchiseItems'] ?? []);
        updateCategorizedLists();
      }
    } catch (e) {
      print('Error fetching wishlist items: $e');
    } finally {
      isLoading(false);
    }
  }

  void updateCategorizedLists() {
    businessItems.assignAll(
        wishlistItems.where((item) => item.type.toLowerCase() == 'business').toList()
    );
    franchiseItems.assignAll(
        wishlistItems.where((item) => item.type.toLowerCase() == 'franchise').toList()
    );
    investorItems.assignAll(
        wishlistItems.where((item) => item.type.toLowerCase() == 'investor').toList()
    );
  }

  Future<void> checkIfItemInWishlist(String userId, String productId) async {
    var data = await WishList.fetchWishlistData();
    if (data != null) {
      isAddedToWishlist.value = data['wishlist'].any((item) => item.id == productId);
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      final success = await WishList.removeFromWishlist(productId: productId);
      if (success != null && success) {
        Get.snackbar(
          'Success',
          'Item removed from wishlist successfully!',
          backgroundColor: Colors.black54,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 8,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        );
        await fetchWishlistItems();
      } else {
        Get.snackbar(
          'Failed',
          'Failed to remove item from wishlist.',
          backgroundColor: Colors.black54,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 8,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        );
      }
    } catch (e) {
      print('Error removing from wishlist: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void toggleWishlist(String userId, String productId) async {
    try {
      if (isAddedToWishlist.value) {
        await removeFromWishlist(productId);
      } else {
        final success = await WishList.wishList(productId: productId);
        if (success != null && success) {
          isAddedToWishlist.value = true;
          Get.snackbar(
            'Success',
            'Item added to wishlist successfully!',
            backgroundColor: Colors.black54,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 8,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          );
          await fetchWishlistItems();
        } else {
          Get.snackbar(
            'Failed',
            'Failed to add item to wishlist.',
            backgroundColor: Colors.black54,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 8,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          );
        }
      }
    } catch (e) {
      isAddedToWishlist.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
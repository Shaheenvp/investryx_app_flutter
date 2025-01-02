// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:lottie/lottie.dart';
// import '../services/profile forms/advisor/advisor get.dart';
// import '../services/profile forms/business/business get.dart';
// import '../services/profile forms/franchise/franchise get.dart';
// import '../services/profile forms/investor/investor get.dart';
// import '../services/user profile and personal info.dart';
// import 'Auth Screens/login.dart';
//
// class ManageProfileScreen extends StatefulWidget {
//   const ManageProfileScreen({super.key});
//
//   @override
//   State<ManageProfileScreen> createState() => _ManageProfileScreenState();
// }
//
// class _ManageProfileScreenState extends State<ManageProfileScreen> {
//   static final storage = FlutterSecureStorage();
//
//   final Map<String, Map<String, dynamic>> profiles = {
//     'Business Profile': {
//       'color': const Color(0xff4A90E2),
//       'icon': Icons.business_rounded,
//       'deleteFunction': BusinessGet.deleteBusinessProfile,
//     },
//     'Investor Profile': {
//       'color': const Color(0xff9B51E0),
//       'icon': Icons.account_balance_wallet_rounded,
//       'deleteFunction': InvestorFetchPage.deleteInvestorProfile,
//     },
//     'Franchise Profile': {
//       'color': const Color(0xffF2994A),
//       'icon': Icons.store_rounded,
//       'deleteFunction': FranchiseFetchPage.deleteFranchiseProfile,
//     },
//     'Advisor Profile': {
//       'color': const Color(0xff219653),
//       'icon': Icons.person_rounded,
//       'deleteFunction': AdvisorFetchPage.deleteAdvisorProfile,
//     },
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         title: const Text(
//           'Manage Profile',
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//         ),
//         centerTitle: true,
//
//       ),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 8.h),
//               ListView.separated(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: profiles.length,
//                 separatorBuilder: (context, index) => SizedBox(height: 12.h),
//                 itemBuilder: (context, index) {
//                   String title = profiles.keys.elementAt(index);
//                   return _buildProfileCard(title, profiles[title]!);
//                 },
//               ),
//               SizedBox(height: 24.h),
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 4.w),
//                 child: Text(
//                   'Account Settings',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 12.h),
//               _buildTemporaryDeleteButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileCard(String title, Map<String, dynamic> profile) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey[200]!,
//             offset: const Offset(0, 2),
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: ListTile(
//           contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//           leading: Container(
//             padding: EdgeInsets.all(8.w),
//             decoration: BoxDecoration(
//               color: profile['color'].withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               profile['icon'] as IconData,
//               color: profile['color'],
//               size: 24,
//             ),
//           ),
//           title: Text(
//             title,
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 15.sp,
//             ),
//           ),
//           trailing: IconButton(
//             onPressed: () => _showDeleteConfirmationDialog(context, title),
//             icon: Icon(
//               Icons.delete_outline,
//               color: Colors.red[400],
//               size: 22,
//             ),
//             style: IconButton.styleFrom(
//               backgroundColor: Colors.red[50],
//               padding: const EdgeInsets.all(8),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTemporaryDeleteButton() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey[200]!,
//             offset: const Offset(0, 2),
//             blurRadius: 6,
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: ListTile(
//           onTap: () => _showDeleteConfirmationDialog(context, 'your account'),
//           contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//           leading: Container(
//             padding: EdgeInsets.all(8.w),
//             decoration: BoxDecoration(
//               color: Colors.orange[50],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               Icons.timer_outlined,
//               color: Colors.orange[700],
//               size: 24,
//             ),
//           ),
//           title: Text(
//             'Temporarily Delete Account',
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 15.sp,
//             ),
//           ),
//           subtitle: Text(
//             'Your account will be deactivated for 30 days',
//             style: TextStyle(
//               fontSize: 12.sp,
//               color: Colors.grey[600],
//             ),
//           ),
//           trailing: Icon(
//             Icons.chevron_right_rounded,
//             color: Colors.grey[400],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showDeleteConfirmationDialog(BuildContext context, String itemName) async {
//     final token = await storage.read(key: 'token');
//
//     if (token == null) {
//       Get.snackbar('Error', 'Failed to get token');
//       return;
//     }
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         bool isAccountDeletion = itemName == 'your account';
//
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(12.w),
//                 decoration: BoxDecoration(
//                   color: isAccountDeletion
//                       ? Colors.orange[50]
//                       : Colors.red[50],
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   isAccountDeletion
//                       ? Icons.timer_outlined
//                       : Icons.delete_outline_rounded,
//                   color: isAccountDeletion
//                       ? Colors.orange[700]
//                       : Colors.red[400],
//                   size: 32,
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               Text(
//                 isAccountDeletion
//                     ? 'Temporarily Delete Account?'
//                     : 'Delete $itemName?',
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 isAccountDeletion
//                     ? 'Your account will be deactivated for 30 days. After that, it will be permanently deleted.'
//                     : 'This action cannot be undone',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.grey[600],
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 try {
//                   if (isAccountDeletion) {
//                     await UserProfile.deleteUserProfile();
//                     await storage.deleteAll();
//                     Get.snackbar(
//                       'Success',
//                       'Account temporarily deactivated',
//                       backgroundColor: Colors.black54,
//                       colorText: Colors.white,
//                       snackPosition: SnackPosition.BOTTOM,
//                       borderRadius: 8,
//                       margin: EdgeInsets.all(10),
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     );
//                     Get.offAll(() => SignInPage());
//                   } else {
//                     if (itemName == 'Business Profile' ||
//                         itemName == 'Advisor Profile') {
//                       await profiles[itemName]!['deleteFunction'](token);
//                     } else {
//                       await profiles[itemName]!['deleteFunction']();
//                     }
//
//                     Get.snackbar(
//                       'Success',
//                       '$itemName deleted successfully',
//                       backgroundColor: Colors.black54,
//                       colorText: Colors.white,
//                       snackPosition: SnackPosition.BOTTOM,
//                       borderRadius: 8,
//                       margin: EdgeInsets.all(10),
//                       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     );
//                     Navigator.pop(context);
//                   }
//                 } catch (e) {
//                   Get.snackbar(
//                     'Error',
//                     'Failed to delete profile: $e',
//                     backgroundColor: Colors.black54,
//                     colorText: Colors.white,
//                     snackPosition: SnackPosition.BOTTOM,
//                     borderRadius: 8,
//                     margin: EdgeInsets.all(10),
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   );
//                 }
//               },
//               child: Text(
//                 isAccountDeletion ? 'Deactivate' : 'Delete',
//                 style: TextStyle(
//                   color: isAccountDeletion
//                       ? Colors.orange[700]
//                       : Colors.red[400],
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';

import '../models/all profile model.dart';
import '../services/profile forms/advisor/advisor get.dart';
import '../services/profile forms/business/business get.dart';
import '../services/profile forms/franchise/franchise get.dart';
import '../services/profile forms/investor/investor get.dart';
import '../services/user profile and personal info.dart';
import 'Auth Screens/login.dart';

class ProfileType {
  final Color color;
  final IconData icon;
  final String description;
  final Function deleteFunction;
  final Function? fetchFunction;
  final Function? deleteItemFunction;

  const ProfileType({
    required this.color,
    required this.icon,
    required this.description,
    required this.deleteFunction,
    this.fetchFunction,
    this.deleteItemFunction,
  });
}

class ManageProfileScreen extends StatefulWidget {
  const ManageProfileScreen({super.key});

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  static final storage = FlutterSecureStorage();
  List<BusinessInvestorExplr>? businessListings;
  List<BusinessInvestorExplr>? investorListings;
  List<FranchiseExplr>? franchiseListings;
  bool isLoading = true;

  final Map<String, ProfileType> profiles = {
    'Business Profile': ProfileType(
      color: const Color(0xff4A90E2),
      icon: Icons.business_rounded,
      description: 'Manage your business listings and profile',
      deleteFunction: BusinessGet.deleteBusinessProfile,
      fetchFunction: BusinessGet.fetchBusinessListings,
      deleteItemFunction: BusinessGet.deleteBusiness,
    ),
    'Investor Profile': ProfileType(
      color: const Color(0xff9B51E0),
      icon: Icons.account_balance_wallet_rounded,
      description: 'Manage your investment portfolio',
      deleteFunction: InvestorFetchPage.deleteInvestorProfile,
      fetchFunction: InvestorFetchPage.fetchInvestorData,
      deleteItemFunction: InvestorFetchPage.deleteInvestor,
    ),
    'Franchise Profile': ProfileType(
      color: const Color(0xffF2994A),
      icon: Icons.store_rounded,
      description: 'Manage your franchise operations',
      deleteFunction: FranchiseFetchPage.deleteFranchiseProfile,
      fetchFunction: FranchiseFetchPage.fetchFranchiseData,
      deleteItemFunction: FranchiseFetchPage.deleteFranchise,
    ),
    'Advisor Profile': ProfileType(
      color: const Color(0xff219653),
      icon: Icons.person_rounded,
      description: 'Manage your advisor services',
      deleteFunction: AdvisorFetchPage.deleteAdvisorProfile,
    ),
  };

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    setState(() => isLoading = true);
    try {
      await _fetchAllListings();
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchAllListings() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('Authentication token not found');

      final futures = await Future.wait([
        BusinessGet.fetchBusinessListings(),
        InvestorFetchPage.fetchInvestorData(),
        FranchiseFetchPage.fetchFranchiseData(),
      ]);

      setState(() {
        businessListings = futures[0] as List<BusinessInvestorExplr>?;
        investorListings = futures[1] as List<BusinessInvestorExplr>?;
        franchiseListings = futures[2] as List<FranchiseExplr>?;
      });
    } catch (e) {
      _showErrorSnackbar('Failed to fetch profiles', e.toString());
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red[900],
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16.w),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green[900],
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16.w),
    );
  }

  Future<void> _handleDelete(
      String itemName,
      bool isCompleteProfile,
      String? listingId,
      ) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) throw Exception('Authentication token not found');

      if (itemName == 'your account') {
        await UserProfile.deleteUserProfile();
        await storage.deleteAll();
        Get.offAll(() => SignInPage());
        return;
      }

      if (isCompleteProfile) {
        final profile = profiles[itemName]!;
        if (itemName == 'Business Profile' || itemName == 'Advisor Profile') {
          await profile.deleteFunction(token);
        } else {
          await profile.deleteFunction();
        }
      } else {
        await profiles[itemName]!.deleteItemFunction!(listingId!);
      }

      Get.back();
      _showSuccessSnackbar(
        isCompleteProfile
            ? '$itemName deleted successfully'
            : 'Listing deleted successfully',
      );
      await _loadProfiles();
    } catch (e) {
      Get.back();
      _showErrorSnackbar('Delete Failed', e.toString());
    }
  }

  void _showDeleteConfirmationDialog(
      BuildContext context,
      String itemName, {
        bool isCompleteProfile = false,
        String? listingId,
        String? listingName,
      }) {
    showDialog(
      context: context,
      builder: (context) => DeleteDialog(
        itemName: itemName,
        isCompleteProfile: isCompleteProfile,
        listingName: listingName,
        onConfirm: () => _handleDelete(
          itemName,
          isCompleteProfile,
          listingId,
        ),
      ),
    );
  }

  List<dynamic>? _getListingsForProfile(String profileName) {
    switch (profileName) {
      case 'Business Profile':
        return businessListings;
      case 'Investor Profile':
        return investorListings;
      case 'Franchise Profile':
        return franchiseListings;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(
        title: 'Manage Profile',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: isLoading
          ? const LoadingIndicator()
          : RefreshIndicator(
        onRefresh: _loadProfiles,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 24.h,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      title: 'Your Profiles',
                      subtitle: 'Manage your professional presence',
                    ),
                    SizedBox(height: 20.h),
                    _buildProfileGrid(),
                    SizedBox(height: 32.h),
                    const SectionTitle(
                      title: 'Account Settings',
                      subtitle: 'Manage your account preferences',
                    ),
                    SizedBox(height: 20.h),
                    AccountCard(
                      onDeleteAccount: () => _showDeleteConfirmationDialog(
                        context,
                        'your account',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final entry = profiles.entries.elementAt(index);
        return ProfileCard(
          title: entry.key,
          profileType: entry.value,
          listings: _getListingsForProfile(entry.key),
          onDeleteProfile: () => _showDeleteConfirmationDialog(
            context,
            entry.key,
            isCompleteProfile: true,
          ),
          onDeleteListing: (listingId, listingName) {
            _showDeleteConfirmationDialog(
              context,
              entry.key,
              isCompleteProfile: false,
              listingId: listingId,
              listingName: listingName,
            );
          },
        );
      },
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: onBackPressed,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/loading.json',
            width: 120.w,
            height: 120.w,
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading profiles...',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.sp,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String title;
  final ProfileType profileType;
  final List<dynamic>? listings;
  final VoidCallback onDeleteProfile;
  final Function(String, String) onDeleteListing;

  const ProfileCard({
    super.key,
    required this.title,
    required this.profileType,
    this.listings,
    required this.onDeleteProfile,
    required this.onDeleteListing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            if (listings?.isNotEmpty ?? false) {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  minHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                builder: (context) => SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ListingsSheet(
                      title: title,
                      color: profileType.color,
                      listings: listings!,
                      onDeleteListing: onDeleteListing,
                    ),
                  ),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: profileType.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        profileType.icon,
                        color: profileType.color,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: onDeleteProfile,
                      icon: Icon(
                        Icons.delete_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.errorContainer,
                        minimumSize: Size.zero,
                        padding: EdgeInsets.all(8.w),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  profileType.description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (listings != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: profileType.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${listings!.length} Listings',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: profileType.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListingsSheet extends StatelessWidget {
  final String title;
  final Color color;
  final List<dynamic> listings;
  final Function(String, String) onDeleteListing;

  const ListingsSheet({
    super.key,
    required this.title,
    required this.color,
    required this.listings,
    required this.onDeleteListing,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: listings.isEmpty
                    ? _buildEmptyState(context)
                    : _buildListings(scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.h, left: 20.w, right: 20.w, bottom: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForTitle(title),
                  color: color,
                  size: 20,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title Listings',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${listings.length} active ${listings.length == 1 ? 'listing' : 'listings'}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Listings Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create your first listing to get started',
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.add, size: 20),
            label: Text('Create Listing'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListings(ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
      itemCount: listings.length,
      itemBuilder: (context, index) {
        final listing = listings[index];
        final title = listing is BusinessInvestorExplr
            ? listing.name
            : listing is FranchiseExplr
            ? listing.brandName
            : 'Unknown';
        final subtitle = listing is BusinessInvestorExplr || listing is FranchiseExplr
            ? listing.city
            : '';

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () => onDeleteListing(listing.id, title),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    minimumSize: Size.zero,
                    padding: EdgeInsets.all(8.w),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Business Profile':
        return Icons.business_rounded;
      case 'Investor Profile':
        return Icons.account_balance_wallet_rounded;
      case 'Franchise Profile':
        return Icons.store_rounded;
      case 'Advisor Profile':
        return Icons.person_rounded;
      default:
        return Icons.list_rounded;
    }
  }
}


class AccountCard extends StatelessWidget {
  final VoidCallback onDeleteAccount;

  const AccountCard({
    super.key,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onDeleteAccount,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.timer_outlined,
                    color: Theme.of(context).colorScheme.error,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Temporarily Delete Account',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Your account will be deactivated for 30 days',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  final String itemName;
  final bool isCompleteProfile;
  final String? listingName;
  final VoidCallback onConfirm;

  const DeleteDialog({
    super.key,
    required this.itemName,
    required this.isCompleteProfile,
    this.listingName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAccountDeletion = itemName == 'your account';
    final String title = isAccountDeletion
        ? 'Temporarily Delete Account?'
        : isCompleteProfile
        ? 'Delete Complete $itemName?'
        : 'Delete $listingName?';

    final String message = isAccountDeletion
        ? 'Your account will be deactivated for 30 days. After that, it will be permanently deleted.'
        : isCompleteProfile
        ? 'This will delete all your listings under this profile'
        : 'This action cannot be undone';

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isAccountDeletion
                    ? Theme.of(context).colorScheme.errorContainer
                    : Theme.of(context).colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isAccountDeletion ? Icons.timer_outlined : Icons.delete_outline_rounded,
                color: Theme.of(context).colorScheme.error,
                size: 32,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAccountDeletion
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.error,
                    foregroundColor: isAccountDeletion
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.onError,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isAccountDeletion ? 'Deactivate' : 'Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
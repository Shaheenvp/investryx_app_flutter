// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:ui';
// import 'package:project_emergio/Widgets/custom_funtions.dart';
// import 'package:project_emergio/generated/constants.dart';
// import 'package:project_emergio/models/all%20profile%20model.dart';
// import 'package:project_emergio/Widgets/custom%20connect%20button.dart';
// import 'package:project_emergio/services/chatUserCheck.dart';
// import 'package:project_emergio/services/check%20subscribe.dart';
// import 'package:project_emergio/services/inbox%20service.dart';
// import 'package:project_emergio/services/testimonial/testimonial%20get.dart';
// import 'package:project_emergio/Views/chat_screens/chat%20screen.dart';
// import 'package:project_emergio/Views/pricing%20screen.dart';
//
// import '../../Widgets/report_widget.dart';
// import '../../services/recommended ads.dart';
// import '../../services/report_post_service.dart';
//
// class AdvisorDetailPage extends StatefulWidget {
//   final AdvisorExplr? advisor;
//   final ProductDetails? recommendedAdvisor;
//   final bool isFromRecommended;
//
//   const AdvisorDetailPage({
//     Key? key,
//     this.advisor,
//     this.recommendedAdvisor,
//     this.isFromRecommended = false,
//   }) : assert(advisor != null || recommendedAdvisor != null),
//         super(key: key);
//
//   @override
//   State<AdvisorDetailPage> createState() => _AdvisorDetailPageState();
// }
//
// class _AdvisorDetailPageState extends State<AdvisorDetailPage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final ScrollController _scrollController = ScrollController();
//   bool _isLoadingTestimonials = false;
//   List<Map<String, dynamic>> _testimonials = [];
//   dynamic subscription;
//   bool subscribed = false;
//   double _scrollOffset = 0.0;
//
//   // Helper getters for data access
//   String get name => widget.isFromRecommended
//       ? widget.recommendedAdvisor?.title ?? ''
//       : widget.advisor?.name ?? '';
//
//   String get imageUrl => widget.isFromRecommended
//       ? widget.recommendedAdvisor?.imageUrl ?? ''
//       : widget.advisor?.imageUrl ?? '';
//
//   String get description => widget.isFromRecommended
//       ? widget.recommendedAdvisor?.description ?? ''
//       : widget.advisor?.description ?? 'Not available';
//
//   String get designation => widget.isFromRecommended
//       ? widget.recommendedAdvisor?.singleLineDescription ?? ''
//       : widget.advisor?.designation ?? '';
//
//   String get location => widget.isFromRecommended
//       ? "${widget.recommendedAdvisor?.city ?? ''}, ${widget.recommendedAdvisor?.state ?? ''}"
//       : "${widget.advisor?.location ?? ''}, ${widget.advisor?.state ?? ''}";
//
//   String get contactNumber => widget.isFromRecommended
//       ? 'Contact information available after connection'
//       : widget.advisor?.contactNumber ?? '';
//
//   String get websiteUrl => widget.isFromRecommended
//       ? widget.recommendedAdvisor?.url ?? ''
//       : widget.advisor?.url ?? '';
//
//   String get interest => widget.isFromRecommended
//       ? 'Areas of expertise information available after connection'
//       : widget.advisor?.interest ?? '';
//
//   String get id => widget.isFromRecommended
//       ? widget.recommendedAdvisor?.id.toString() ?? ''
//       : widget.advisor?.id.toString() ?? '';
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _scrollController.addListener(_onScroll);
//     _initializeData();
//
//
//     print('Is from recommended: ${widget.isFromRecommended}');
//     print('Advisor data: ${widget.advisor}');
//     print('Recommended advisor data: ${widget.recommendedAdvisor}');
//     print('Name: $name');
//     print('Website: $websiteUrl');
//     print('Contact: $contactNumber');
//     print('Interest: $interest');
//     print('Description: $description');
//   }
//
//   void _onScroll() {
//     setState(() {
//       _scrollOffset = _scrollController.offset;
//     });
//   }
//
//   Future<void> _initializeData() async {
//     await Future.wait([
//       _checkSubscription(),
//       _fetchTestimonials(),
//     ]);
//   }
//
//   Future<void> _checkSubscription() async {
//     try {
//       subscription = await CheckSubscription.fetchSubscription();
//       if (mounted) {
//         setState(() {
//           subscribed = subscription['status'];
//         });
//       }
//     } catch (e) {
//       debugPrint("Error checking subscription: $e");
//     }
//   }
//
//   Future<void> _fetchTestimonials() async {
//     if (!mounted) return;
//
//     setState(() {
//       _isLoadingTestimonials = true;
//     });
//
//     try {
//       final testimonials = await TestimonialGet.fetchTestimonials(
//         userId: id,
//       );
//       if (mounted) {
//         setState(() {
//           _testimonials = testimonials ?? [];
//           _isLoadingTestimonials = false;
//         });
//       }
//     } catch (e) {
//       debugPrint("Error fetching testimonials: $e");
//       if (mounted) {
//         setState(() {
//           _isLoadingTestimonials = false;
//         });
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             NestedScrollView(
//               controller: _scrollController,
//               headerSliverBuilder: (context, innerBoxIsScrolled) => [
//                 _buildSliverAppBar(),
//                 SliverToBoxAdapter(
//                   child: Column(
//                     children: [
//                       _buildProfileInfo(),
//                       _buildTabBar(),
//                     ],
//                   ),
//                 ),
//               ],
//               body: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildPersonalInfoTab(),
//                   _buildTestimonialsTab(),
//                 ],
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: _buildBottomButton(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSliverAppBar() {
//     return SliverAppBar(
//       expandedHeight: 250.h,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       flexibleSpace: FlexibleSpaceBar(
//         background: Stack(
//           fit: StackFit.expand,
//           children: [
//             CachedNetworkImage(
//               imageUrl: imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150',
//               fit: BoxFit.cover,
//               placeholder: (context, url) => const Center(
//                 child: CircularProgressIndicator(),
//               ),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(0.7),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       leading: Container(
//         margin: EdgeInsets.all(8.r),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(40.r),
//           border: Border.all(
//             color: Colors.white.withOpacity(0.3),
//             width: 1,
//           ),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(40.r),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         ReportButton(
//           onSubmit: (String reason, String reasonType, String id) async {
//             try {
//               if (id.isEmpty) {
//                 throw Exception('Post ID cannot be empty');
//               }
//
//               await ReportPost.reportPost(
//                 reason: reason,
//                 reasonType: reasonType,
//                 postId: widget.advisor!.id.toString(),
//               );
//               return true;
//             } catch (e) {
//               throw e;
//             }
//           }, postId: widget.advisor!.id.toString(),
//         ),
//
//       ],
//     );
//   }
//
//   Widget _buildProfileInfo() {
//     return Container(
//       padding: EdgeInsets.all(20.r),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30.r),
//           topRight: Radius.circular(30.r),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             CustomFunctions.toSentenceCase(name),
//             style: TextStyle(
//               fontSize: 24.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 designation,
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   color: Colors.grey[600],
//                 ),
//               ),
//               _buildRatingBadge(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRatingBadge() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         color: Colors.amber.shade100,
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.star, color: Colors.amber, size: 18.sp),
//           SizedBox(width: 4.w),
//           Text(
//             '4.8',
//             style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.bold,
//               color: Colors.amber[800],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabBar() {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.symmetric(horizontal: 16.w),
//       child: TabBar(
//         controller: _tabController,
//         labelColor: buttonColor,
//         unselectedLabelColor: Colors.grey,
//         indicatorColor: buttonColor,
//         indicatorWeight: 3,
//         labelStyle: TextStyle(
//           fontSize: 16.sp,
//           fontWeight: FontWeight.w600,
//         ),
//         tabs: const [
//           Tab(text: 'About'),
//           Tab(text: 'Reviews'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPersonalInfoTab() {
//     if (!subscribed && widget.isFromRecommended) {
//       return _buildSubscriptionPrompt();
//     }
//
//     return ListView(
//       padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 80.r),
//       physics: const BouncingScrollPhysics(),
//       children: [
//         _buildContactSection(),
//         SizedBox(height: 10.h),
//         _buildAboutSection(),
//
//       ],
//     );
//   }
//
//   Widget _buildContactSection() {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xffFEF9E4),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       padding: EdgeInsets.all(20.r),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Contact Info',
//             style: TextStyle(
//               fontSize: 20.sp,
//               color: Colors.black.withOpacity(0.4),
//             ),
//           ),
//           SizedBox(height: 10.h),
//           _buildContactDetail('Email', websiteUrl),
//           _buildContactDetail('Phone', contactNumber),
//           _buildContactDetail('Location', location),
//           _buildContactDetail('Area of interest', interest),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAboutSection() {
//     return Container(
//       padding: EdgeInsets.all(20.r),
//       decoration: BoxDecoration(
//         color: const Color(0xffFEF9E4),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "About Me",
//             style: TextStyle(
//               color: Colors.black.withOpacity(0.3),
//               fontSize: 20.sp,
//             ),
//           ),
//           SizedBox(height: 10.h),
//           Text(
//             CustomFunctions.toSentenceCase(description),
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildContactDetail(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.only(top: 5.h),
//       child: Text(
//         '$label: ${value.isNotEmpty ? value : 'Not available'}',
//         style: TextStyle(
//           fontSize: 14.sp,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTestimonialsTab() {
//     if (_isLoadingTestimonials) {
//       return Center(
//         child: Lottie.asset(
//           'assets/loading.json',
//           height: 100.h,
//           width: 100.w,
//         ),
//       );
//     }
//
//     if (_testimonials.isEmpty) {
//       return Center(
//         child: Text(
//           'No reviews yet',
//           style: TextStyle(
//             fontSize: 16.sp,
//             color: Colors.grey[600],
//           ),
//         ),
//       );
//     }
//
//     return ListView.builder(
//       padding: EdgeInsets.all(20.r),
//       itemCount: _testimonials.length,
//       itemBuilder: (context, index) => _buildTestimonialCard(_testimonials[index]),
//     );
//   }
//
//   Widget _buildTestimonialCard(Map<String, dynamic> testimonial) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 15.h),
//       padding: EdgeInsets.all(20.r),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: buttonColor.withOpacity(0.1),
//                 child: Text(
//                   (testimonial['company'] ?? 'A')[0].toUpperCase(),
//                   style: TextStyle(
//                     color: buttonColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       testimonial['company'] ?? 'Anonymous',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     Text(
//                       'Verified Client',
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           Text(
//             testimonial['testimonial'] ?? 'No testimonial available.',
//             style: TextStyle(
//               fontSize: 15.sp,
//               color: Colors.grey[800],
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSubscriptionPrompt() {
//     return Center(
//       child: Container(
//         width: 300.w,
//         padding: EdgeInsets.all(30.r),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 20,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.lock_outline,
//               size: 50.sp,
//               color: buttonColor,
//             ),
//             SizedBox(height: 20.h),
//             Text(
//               "Premium Content",
//               style: TextStyle(
//                 fontSize: 20.sp,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 10.h),
//             Text(
//               "Upgrade to premium to access detailed information about our advisors",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: Colors.grey[600],
//                 height: 1.5,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBottomButton() {
//     return Container(
//       padding: EdgeInsets.all(16.r),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: CustomConnectButton(
//           buttonHeight: 50.h,
//           buttonWidth: double.infinity,
//           textColor: Colors.white,
//           buttonColor: buttonColor,
//           text: subscribed ? 'Connect Now' : 'Upgrade to Premium',
//           onPressed: subscribed ? _handleConnect : _handleSubscribe,
//         ),
//       ),
//     );
//   }
//
//   Future<void> _handleConnect() async {
//     try {
//       final userId = await ChatUserCheck.fetchChatUserData();
//       final receiverUserId = id;
//
//       final room = await Inbox.roomCreation(receiverUserId: receiverUserId);
//
//       if (room['status'] && mounted) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ChatScreen(
//               roomId: room['id'].toString(),
//               name: room['name'],
//               chatUserId: userId,
//               imageUrl: room['image'],
//               number: '',
//               lastActive: '',
//               isActive: true,
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Failed to connect: ${e.toString()}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
//
//   void _handleSubscribe() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         child: Container(
//           padding: EdgeInsets.all(20.r),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.workspace_premium,
//                 size: 50.sp,
//                 color: buttonColor,
//               ),
//               SizedBox(height: 20.h),
//               Text(
//                 'Upgrade Required',
//                 style: TextStyle(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Text(
//                 'You need to purchase a plan to connect with our advisors.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.grey[600],
//                   height: 1.5,
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text(
//                       'Later',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 16.sp,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PricingScreenNew(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: buttonColor,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 30.w,
//                         vertical: 12.h,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(25.r),
//                       ),
//                     ),
//                     child: Text(
//                       'View Plans',
//                       style: TextStyle(
//                         fontSize: 16.sp,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'package:project_emergio/Widgets/custom_funtions.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/Widgets/custom%20connect%20button.dart';
import 'package:project_emergio/services/chatUserCheck.dart';
import 'package:project_emergio/services/check%20subscribe.dart';
import 'package:project_emergio/services/inbox%20service.dart';
import 'package:project_emergio/services/testimonial/testimonial%20get.dart';
import 'package:project_emergio/Views/chat_screens/chat%20screen.dart';
import 'package:project_emergio/Views/pricing%20screen.dart';

import '../../Widgets/report_widget.dart';
import '../../services/recommended ads.dart';
import '../../services/report_post_service.dart';

class AdvisorDetailPage extends StatefulWidget {
  final AdvisorExplr? advisor;
  final ProductDetails? recommendedAdvisor;
  final bool isFromRecommended;

  const AdvisorDetailPage({
    Key? key,
    this.advisor,
    this.recommendedAdvisor,
    this.isFromRecommended = false,
  })  : assert(advisor != null || recommendedAdvisor != null),
        super(key: key);

  @override
  State<AdvisorDetailPage> createState() => _AdvisorDetailPageState();
}

class _AdvisorDetailPageState extends State<AdvisorDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingTestimonials = false;
  List<Map<String, dynamic>> _testimonials = [];
  dynamic subscription;
  bool subscribed = false;
  double _scrollOffset = 0.0;

  // Helper getters for data access
  String get name => widget.isFromRecommended
      ? widget.recommendedAdvisor?.title ?? ''
      : widget.advisor?.name ?? '';

  String get imageUrl => widget.isFromRecommended
      ? widget.recommendedAdvisor?.imageUrl ?? ''
      : widget.advisor?.imageUrl ?? '';

  String get description => widget.isFromRecommended
      ? widget.recommendedAdvisor?.description ?? ''
      : widget.advisor?.description ?? 'Not available';

  String get designation => widget.isFromRecommended
      ? widget.recommendedAdvisor?.singleLineDescription ?? ''
      : widget.advisor?.designation ?? '';

  String get location => widget.isFromRecommended
      ? "${widget.recommendedAdvisor?.city ?? ''}, ${widget.recommendedAdvisor?.state ?? ''}"
      : "${widget.advisor?.location ?? ''}, ${widget.advisor?.state ?? ''}";

  String get contactNumber => widget.isFromRecommended
      ? 'Contact information available after connection'
      : widget.advisor?.contactNumber ?? '';

  String get websiteUrl => widget.isFromRecommended
      ? widget.recommendedAdvisor?.url ?? ''
      : widget.advisor?.url ?? '';

  String get interest => widget.isFromRecommended
      ? 'Areas of expertise information available after connection'
      : widget.advisor?.interest ?? '';

  String get id => widget.isFromRecommended
      ? widget.recommendedAdvisor?.id.toString() ?? ''
      : widget.advisor?.id.toString() ?? '';

  String get expertise => widget.isFromRecommended
      ? 'Expertise information available after connection'
      : widget.advisor?.expertise ?? '';

  String get experience => widget.isFromRecommended
      ? 'Experience information available after connection'
      : widget.advisor?.experience ?? '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
    _initializeData();

  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  Future<void> _initializeData() async {
    await Future.wait([
      _checkSubscription(),
      _fetchTestimonials(),
    ]);
  }

  Future<void> _checkSubscription() async {
    try {
      subscription = await CheckSubscription.fetchSubscription();
      if (mounted) {
        setState(() {
          subscribed = subscription['status'];
        });
      }
    } catch (e) {
      debugPrint("Error checking subscription: $e");
    }
  }

  Future<void> _fetchTestimonials() async {
    if (!mounted) return;

    setState(() {
      _isLoadingTestimonials = true;
    });

    try {
      final testimonials = await TestimonialGet.fetchTestimonials(
        userId: id,
      );
      if (mounted) {
        setState(() {
          _testimonials = testimonials ?? [];
          _isLoadingTestimonials = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching testimonials: $e");
      if (mounted) {
        setState(() {
          _isLoadingTestimonials = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildProfileInfo(),
                      _buildTabBar(),
                    ],
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildPersonalInfoTab(),
                  _buildTestimonialsTab(),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl.isNotEmpty
                  ? imageUrl
                  : 'https://via.placeholder.com/150',
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: Container(
        margin: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      actions: [
        ReportButton(
          onSubmit: (String reason, String reasonType, String id) async {
            try {
              if (id.isEmpty) {
                throw Exception('Post ID cannot be empty');
              }

              await ReportPost.reportPost(
                reason: reason,
                reasonType: reasonType,
                postId: widget.advisor!.id.toString(),
              );
              return true;
            } catch (e) {
              throw e;
            }
          },
          postId: widget.advisor!.id.toString(),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           widget.advisor!.title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          // SizedBox(height: 4.h),
          // Text(
          //   CustomFunctions.toSentenceCase(widget.advisor!.singleLineDescription),
          //   style: TextStyle(
          //     fontSize: 18.sp,
          //     fontWeight: FontWeight.w500,
          //     color: Colors.black87,
          //   ),
          // ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                designation,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
              _buildRatingBadge(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.amber, size: 18.sp),
          SizedBox(width: 4.w),
          Text(
            '4.8',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.amber[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TabBar(
        controller: _tabController,
        labelColor: buttonColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: buttonColor,
        indicatorWeight: 3,
        labelStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'About'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 80.r),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildContactSection(),
        SizedBox(height: 10.h),
        _buildProfessionalSection(),
        SizedBox(height: 10.h),
        _buildAboutSection(),
      ],
    );
  }

  Widget _buildProfessionalSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFEF9E4),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional Details',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          SizedBox(height: 10.h),
          _buildDetailRow('Location', location),
          _buildDetailRow('Area of interest', interest),
          _buildDetailRow('Expertise', expertise),
          _buildDetailRow('Experience', experience),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    if (!subscribed) {
      return _buildLockedContactSection();
    }
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFEF9E4),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Info',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
          SizedBox(height: 10.h),
          _buildDetailRow('Email', websiteUrl),
          _buildDetailRow('Phone', contactNumber),
        ],
      ),
    );
  }

  Widget _buildLockedContactSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFEF9E4),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock_outline,
                color: buttonColor,
                size: 24.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Text(
            'Upgrade to premium to view contact details and connect with our advisors',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Text(
        '$label: ${value.isNotEmpty ? value : 'Not available'}',
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black,
        ),
      ),
    );
  }

  // Widget _buildContactSection() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: const Color(0xffFEF9E4),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     padding: EdgeInsets.all(20.r),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Contact Info',
  //           style: TextStyle(
  //             fontSize: 20.sp,
  //             color: Colors.black.withOpacity(0.4),
  //           ),
  //         ),
  //         SizedBox(height: 10.h),
  //         _buildContactDetail('Email', websiteUrl),
  //         _buildContactDetail('Phone', contactNumber),
  //         _buildContactDetail('Location', location),
  //         _buildContactDetail('Area of interest', interest),
  //         _buildContactDetail('Expertise', expertise),
  //         _buildContactDetail('Experience', experience),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSubscriptionPromptCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFEF9E4),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lock_outline,
                color: buttonColor,
                size: 24.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Text(
            'Upgrade to premium to view contact details, expertise, experience and connect with our advisors',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xffFEF9E4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About Me",
            style: TextStyle(
              color: Colors.black.withOpacity(0.3),
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            CustomFunctions.toSentenceCase(description),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Text(
        '$label: ${value.isNotEmpty ? value : 'Not available'}',
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTestimonialsTab() {
    if (_isLoadingTestimonials) {
      return Center(
        child: Lottie.asset(
          'assets/loading.json',
          height: 100.h,
          width: 100.w,
        ),
      );
    }

    if (_testimonials.isEmpty) {
      return Center(
        child: Text(
          'No reviews yet',
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20.r),
      itemCount: _testimonials.length,
      itemBuilder: (context, index) =>
          _buildTestimonialCard(_testimonials[index]),
    );
  }

  Widget _buildTestimonialCard(Map<String, dynamic> testimonial) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: buttonColor.withOpacity(0.1),
                child: Text(
                  (testimonial['company'] ?? 'A')[0].toUpperCase(),
                  style: TextStyle(
                    color: buttonColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial['company'] ?? 'Anonymous',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Verified Client',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            testimonial['testimonial'] ?? 'No testimonial available.',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: CustomConnectButton(
          buttonHeight: 50.h,
          buttonWidth: double.infinity,
          textColor: Colors.white,
          buttonColor: buttonColor,
          text: subscribed ? 'Connect Now' : 'Upgrade to Premium',
          onPressed: subscribed ? _handleConnect : _handleSubscribe,
        ),
      ),
    );
  }

  Future<void> _handleConnect() async {
    try {
      final userId = await ChatUserCheck.fetchChatUserData();
      final receiverUserId = id;

      final room = await Inbox.roomCreation(receiverUserId: receiverUserId);

      if (room['status'] && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              roomId: room['id'].toString(),
              name: room['name'],
              chatUserId: userId,
              imageUrl: room['image'],
              number: '',
              lastActive: '',
              isActive: true,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleSubscribe() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium,
                size: 50.sp,
                color: buttonColor,
              ),
              SizedBox(height: 20.h),
              Text(
                'Upgrade Required',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'You need to purchase a plan to connect with our advisors.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Later',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PricingScreenNew(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                    ),
                    child: Text(
                      'View Plans',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

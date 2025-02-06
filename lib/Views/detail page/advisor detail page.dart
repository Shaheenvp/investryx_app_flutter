// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:like_button/like_button.dart';
// import 'package:lottie/lottie.dart';
// import 'package:project_emergio/Widgets/custom_funtions.dart';
// import 'package:project_emergio/controller/wishlist%20controller.dart';
// import 'package:project_emergio/generated/constants.dart';
// import 'package:project_emergio/models/all%20profile%20model.dart';
// import '../../Widgets/custom connect button.dart';
// import '../../services/chatUserCheck.dart';
// import '../../services/check subscribe.dart';
// import '../../services/inbox service.dart';
// import '../../services/testimonial/testimonial get.dart';
// import '../chat_screens/chat screen.dart';
// import '../pricing screen.dart';
//
// class AdvisorDetailPage extends StatefulWidget {
//   final AdvisorExplr? advisor;
//
//   const AdvisorDetailPage({
//     Key? key,
//     this.advisor,
//   }) : super(key: key);
//
//   @override
//   State<AdvisorDetailPage> createState() => _AdvisorDetailPageState();
// }
//
// class _AdvisorDetailPageState extends State<AdvisorDetailPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool _isLoadingTestimonials = false;
//   List<Map<String, dynamic>> _testimonials = [];
//   var subscription;
//   bool subscribed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _fetchTestimonials();
//     _checkSubscription();
//   }
//
//   void _checkSubscription() async {
//     try {
//       subscription = await CheckSubscription.fetchSubscription();
//       setState(() {
//         subscribed = subscription['status'];
//       });
//       print(subscribed);
//     } catch (e) {
//       print("Error fetching subscription: $e");
//     }
//   }
//
//   Future<void> _fetchTestimonials() async {
//     setState(() {
//       _isLoadingTestimonials = true;
//     });
//     print(widget.advisor!.id);
//     final testimonials =
//         await TestimonialGet.fetchTestimonials(userId: widget.advisor!.id);
//     _testimonials = testimonials!;
//
//     setState(() {
//       _isLoadingTestimonials = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // SizedBox(height: h * 0.03),
//             Stack(
//               children: [
//                 Container(
//                   height: 250,
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(20),
//                         bottomRight: Radius.circular(20)),
//                     image: DecorationImage(
//                       image: NetworkImage(widget.advisor!.imageUrl.isNotEmpty
//                               ? widget.advisor!.imageUrl
//                               : 'https://via.placeholder.com/150'
//                           // widget.imageUrl,
//                           ),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   // child:
//                 ),
//                 // Back button and favorite icon
//                 Positioned(
//                   top: 16,
//                   left: 16,
//                   child: CircleAvatar(
//                     radius: 20,
//                     backgroundColor: Colors.white.withOpacity(0.2),
//                     child: IconButton(
//                       icon: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.white,
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(CustomFunctions.toSentenceCase(widget.advisor!.name),
//                       style: AppTheme.titleText(lightTextColor)
//                           .copyWith(fontSize: 18.sp)),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(widget.advisor!.designation.toString(),
//                           style: AppTheme.mediumTitleText(greyTextColor!)),
//
//                       // Rating
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.star, color: Colors.amber, size: 20),
//                           const SizedBox(width: 4),
//                           Text('4.8',
//                               style:
//                                   AppTheme.bodyMediumTitleText(greyTextColor!)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(height: h * 0.015),
//             TabBar(
//               controller: _tabController,
//               indicatorWeight: 7,
//               unselectedLabelStyle: AppTheme.bodyMediumTitleText(greyTextColor!)
//                   .copyWith(fontWeight: FontWeight.w500),
//               labelStyle: AppTheme.bodyMediumTitleText(lightTextColor)
//                   .copyWith(fontWeight: FontWeight.w500),
//               tabs: const [
//                 Tab(
//                   text: 'Personal Info',
//                 ),
//                 Tab(text: 'Testimonials'),
//               ],
//               indicatorColor: buttonColor,
//               indicatorSize: TabBarIndicatorSize.label,
//             ),
//             SizedBox(height: h * 0.02),
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   Padding(
//                       padding: EdgeInsets.symmetric(horizontal: w * 0.05),
//                       child: subscribed == true
//                           ? SingleChildScrollView(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.only(bottom: 10),
//                                     decoration: BoxDecoration(
//                                         color: const Color(0xffFEF9E4),
//                                         borderRadius:
//                                             BorderRadius.circular(15)),
//                                     // height: 300.h,
//                                     width: double.infinity,
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                         left: 20,
//                                         top: 15,
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "About Me",
//                                             style: TextStyle(
//                                                 color: Colors.black
//                                                     .withOpacity(0.3),
//                                                 fontSize: 20),
//                                           ),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           Text(
//                                             CustomFunctions.toSentenceCase(
//                                                 widget.advisor!.description
//                                                     .toString()),
//                                             style: TextStyle(
//                                                 fontSize: 14,
//                                                 color: Colors.black
//                                                     .withOpacity(1)),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 10.h,
//                                   ),
//                                   Container(
//                                     decoration: BoxDecoration(
//                                         color: const Color(0xffFEF9E4),
//                                         borderRadius:
//                                             BorderRadius.circular(15)),
//                                     height: 250.h,
//                                     width: double.infinity,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 20.0, top: 5),
//                                           child: Text(
//                                             'Contact Info',
//                                             style: TextStyle(
//                                               fontSize: 20,
//                                               color:
//                                                   Colors.black.withOpacity(0.4),
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 20.0, top: 5),
//                                           child: Text(
//                                             'Website: ${widget.advisor!.url ?? 'No URL available.'}',
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 20.0, top: 5),
//                                           child: Text(
//                                             'Phone: ${widget.advisor!.contactNumber ?? 'No contact number available.'}',
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 20.0, top: 5),
//                                           child: Text(
//                                             'State: ${widget.advisor!.state ?? 'No state available.'}',
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 20.0, top: 5),
//                                           child: Text(
//                                             'City: ${widget.advisor!.location}',
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 20.0, top: 5),
//                                           child: Text(
//                                             'Area of interest: ${widget.advisor!.interest ?? 'No interest available.'}',
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: h * 10),
//                                   Container(
//                                     height: h * 0.25,
//                                     width: double.infinity,
//                                     decoration: BoxDecoration(
//                                       color: Colors.black,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 16.0, top: 10),
//                                       child: Text(
//                                         'Description: ${widget.advisor!.description ?? 'No description available.'}',
//                                         style: TextStyle(
//                                           fontSize: h * 0.015,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: h * 10),
//                                 ],
//                               ),
//                             )
//                           : Center(
//                               child: Container(
//                                   width: 350,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     color: Colors.black.withOpacity(0.3),
//                                   ),
//                                   child: const Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       // SvgPicture.asset(
//                                       //     "assets/Component 3.svg"),
//                                       // // flutter_svg: ^2.0.5
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                         "Upgrade to premium to see details",
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   )),
//                             )),
//                   _isLoadingTestimonials
//                       ? Center(
//                           child: Lottie.asset(
//                             'assets/loading.json',
//                             height: 70.h,
//                             width: 150.w,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                       : _testimonials.isEmpty
//                           ? Center(
//                               child: Text(
//                               'No testimonials available.',
//                               style:
//                                   TextStyle(color: Colors.black, fontSize: 14),
//                             ))
//                           : ListView.builder(
//                               itemCount: _testimonials.length,
//                               itemBuilder: (context, index) {
//                                 var testimonial = _testimonials[index];
//                                 return Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 4.0, right: 4, bottom: 4),
//                                   child: ListTile(
//                                     contentPadding: EdgeInsets.all(12.0),
//                                     leading: Container(
//                                       width: 50,
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white.withOpacity(0.2),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Icon(
//                                         Icons.person,
//                                         size: 30,
//                                         color: Colors.white.withOpacity(0.2),
//                                       ),
//                                     ),
//                                     title: Text(
//                                       testimonial['company'] ??
//                                           'Company name not available',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 14.0,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                     subtitle: Padding(
//                                       padding: const EdgeInsets.only(top: 4.0),
//                                       child: Text(
//                                         testimonial['testimonial'] ??
//                                             'No testimonial available.',
//                                         style: TextStyle(
//                                           fontSize: 14.0,
//                                           color: Colors.black54,
//                                         ),
//                                       ),
//                                     ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                       side: BorderSide(
//                                           color: Colors.grey[300]!, width: 1),
//                                     ),
//                                     tileColor: Colors.white,
//                                     trailing: Container(
//                                       padding: EdgeInsets.all(8.0),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white.withOpacity(0.2),
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Icon(
//                                         Icons.format_quote,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                 ],
//               ),
//             ),
//             subscribed
//                 ? CustomConnectButton(
//                     buttonHeight: 45,
//                     buttonWidth: 200,
//                     textColor: Colors.white,
//                     buttonColor: Colors.yellow[600],
//                     text: 'Connect',
//                     onPressed: () async {
//                       String receiverUserId = widget.advisor!.id.toString();
//                       print('receiver userID : ${receiverUserId}');
//                       // Call the roomCreation function
//                       final userId = await ChatUserCheck.fetchChatUserData();
//                       // if (userId != receiverUserId) {
//                       var room = await Inbox.roomCreation(
//                           receiverUserId: receiverUserId);
//                       print("room id is ${room}");
//                       if (room['status']) {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ChatScreen(
//                                       roomId: room['id'].toString(),
//                                       name: room['name'],
//                                       chatUserId: userId,
//                                       imageUrl: room['image'],
//                                       number: '',
//                                   lastActive: '', isActive: true,
//                                     )));
//                         print('Room created successfully.');
//                       } else {
//                         // Handle error case
//                         print('Room creation failed.');
//                       }
//                       // }
//                       // else {
//                       //   print('hiy7uhiokpo0');
//                       // }
//                     },
//                   )
//                 : Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: CustomConnectButton(
//                           buttonHeight: 45,
//                           buttonWidth: 150,
//                           textColor: Colors.white,
//                           buttonColor: Colors.yellow[600],
//                           text: 'Subscribe',
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: Text('Subscription Status'),
//                                   content: Text(
//                                       'You have not purchased any plans. Please visit the pricing page to choose a plan.'),
//                                   actions: [
//                                     TextButton(
//                                       child: Text('Cancel'),
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       },
//                                     ),
//                                     TextButton(
//                                       child: Text('View plans'),
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   PricingScreenNew()),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           }),
//                     ),
//                   ),
//             SizedBox(
//               height: 20,
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _contactAdvisor(String? contactNumber) {
//     if (contactNumber != null && contactNumber.isNotEmpty) {
//       // Logic to contact the advisor via phone, SMS, or any other method
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No contact number available.')),
//       );
//     }
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
  }) : assert(advisor != null || recommendedAdvisor != null),
        super(key: key);

  @override
  State<AdvisorDetailPage> createState() => _AdvisorDetailPageState();
}

class _AdvisorDetailPageState extends State<AdvisorDetailPage> with SingleTickerProviderStateMixin {
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
      : widget.advisor?.description ?? '';

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
              imageUrl: imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150',
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
          }, postId: widget.advisor!.id.toString(),
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
            CustomFunctions.toSentenceCase(name),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
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
    if (!subscribed && widget.isFromRecommended) {
      return _buildSubscriptionPrompt();
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 80.r),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildAboutSection(),
        SizedBox(height: 10.h),
        _buildContactSection(),
      ],
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

  Widget _buildContactSection() {
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
          _buildContactDetail('Website', websiteUrl),
          _buildContactDetail('Phone', contactNumber),
          _buildContactDetail('Location', location),
          _buildContactDetail('Area of interest', interest),
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
      itemBuilder: (context, index) => _buildTestimonialCard(_testimonials[index]),
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

  Widget _buildSubscriptionPrompt() {
    return Center(
      child: Container(
        width: 300.w,
        padding: EdgeInsets.all(30.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 50.sp,
              color: buttonColor,
            ),
            SizedBox(height: 20.h),
            Text(
              "Premium Content",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Upgrade to premium to access detailed information about our advisors",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PricingScreenNew(),
                      //   ),
                      // );
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
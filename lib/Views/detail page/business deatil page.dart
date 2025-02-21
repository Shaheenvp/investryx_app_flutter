// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import 'package:like_button/like_button.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import 'package:project_emergio/Views/chat_screens/chat%20screen.dart';
// import 'package:project_emergio/Views/pricing%20screen.dart';
// import 'package:project_emergio/Widgets/custom%20connect%20button.dart';
// import 'package:project_emergio/Widgets/custom_funtions.dart';
// import 'package:project_emergio/controller/wishlist%20controller.dart';
// import 'package:project_emergio/generated/constants.dart';
// import 'package:project_emergio/models/all%20profile%20model.dart';
// import 'package:project_emergio/services/chatUserCheck.dart';
// import 'package:project_emergio/services/check%20subscribe.dart';
// import 'package:project_emergio/services/inbox%20service.dart';
//
// class BusinessDetailPage extends StatefulWidget {
//   @override
//   State<BusinessDetailPage> createState() => _BusinessDetailPageState();
//   final BusinessInvestorExplr? buisines;
//   final String? id;
//   final String? imageUrl;
//   final String? image2;
//   final String? image3;
//   final String? image4;
//   final String? name;
//   final String? industry;
//   final String? establish_yr;
//   final String? description;
//   final String? address_1;
//   final String? address_2;
//   final String? pin;
//   final String? city;
//   final String? state;
//   final String? employees;
//   final String? entity;
//   final String? avg_monthly;
//   final String? latest_yearly;
//   final String? ebitda;
//   final String? rate;
//   final String? type_sale;
//   final String? url;
//   final String? features;
//   final String? facility;
//   final String? income_source;
//   final String? reason;
//   final String? postedTime;
//   final String? topSelling;
//   final String? userId;
//   final bool showEditOption;
//
//   BusinessDetailPage({
//     this.buisines,
//     this.imageUrl,
//     this.image2,
//     this.image3,
//     this.image4,
//     this.name,
//     this.industry,
//     this.establish_yr,
//     this.description,
//     this.address_1,
//     this.address_2,
//     this.pin,
//     this.city,
//     this.state,
//     this.employees,
//     this.entity,
//     this.avg_monthly,
//     this.latest_yearly,
//     this.ebitda,
//     this.rate,
//     this.type_sale,
//     this.url,
//     this.features,
//     this.facility,
//     this.income_source,
//     this.reason,
//     this.userId,
//     this.postedTime,
//     this.topSelling,
//     this.id,
//     required this.showEditOption,
//   });
// }
//
// class _BusinessDetailPageState extends State<BusinessDetailPage> {
//   var subscription;
//   bool subscribed = false;
//   void initState() {
//     super.initState();
//
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
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // _buildHeader(),
//                 ImageSliderHeader(
//                   buisiness: widget.buisines!,
//                   image1: widget.buisines!.imageUrl,
//                   image2: widget.buisines!.image2,
//                   image3: widget.buisines!.image3.toString(),
//                 ),
//                 _buildCompanyTitle(),
//                 _buildDescriptionSection(),
//                 _buildOverviewSection(),
//
//                 _buildFinancialSection(),
//                 _buildAdditionalInfoSection(),
//                 SizedBox(height: 15),
//                 DocumentButton(text: 'Business Documents'),
//                 SizedBox(height: 15),
//                 DocumentButton(text: 'Business Proof'),
//                 SizedBox(height: 40),
//                 // SubscribeButton(),
//                 subscribed
//                     ? Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CustomConnectButton(
//                       buttonHeight: 45,
//                       buttonWidth: 200,
//                       buttonColor: Colors.yellow[600],
//                       text: 'Connect',
//                       onPressed: () async {
//                         String receiverUserId =
//                         widget.buisines!.id.toString();
//                         final userId =
//                         await ChatUserCheck.fetchChatUserData();
//                         var room = await Inbox.roomCreation(
//                             receiverUserId: receiverUserId);
//                         if (room['status']) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                 roomId: room['id'].toString(),
//                                 name: room['name'],
//                                 chatUserId: userId,
//                                 imageUrl: room['image'],
//                                 number: '',
//                                 lastActive: '', isActive: true,
//                               ),
//                             ),
//                           );
//                         } else {
//                           print('Room creation failed.');
//                         }
//                       },
//                     ),
//                   ],
//                 )
//                     : Align(
//                   alignment: Alignment.center,
//                   child: CustomConnectButton(
//                       buttonHeight: 45,
//                       buttonWidth: 200,
//                       buttonColor: Colors.yellow[600],
//                       text: "Subscribe",
//                       onPressed: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: Text('Subscription Status'),
//                               content: Text(
//                                   'You have not purchased any plans. Please visit the pricing page to choose a plan.'),
//                               actions: [
//                                 TextButton(
//                                   child: Text('Cancel'),
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                                 TextButton(
//                                   child: Text('View plans'),
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               PricingScreenNew()),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       }),
//                 ),
//
//                 SizedBox(height: 10),
//                 //  _buildBuisinessDocuments(),
//                 // _buildBuisinessProof(),
//                 // _buildSubscribeButton()
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Stack(
//       children: [
//         Container(
//           height: 250,
//           width: double.infinity,
//           child: ClipRRect(
//             borderRadius: const BorderRadius.vertical(
//               bottom: Radius.circular(16),
//             ),
//             child: Image.asset(
//               '',
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 16,
//           left: 16,
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 16,
//           right: 16,
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.favorite, color: Colors.white),
//           ),
//         ),
//         Positioned(
//           bottom: 16,
//           left: 0,
//           right: 0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 8,
//                 height: 8,
//                 decoration: const BoxDecoration(
//                   color: Colors.amber,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 width: 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: Colors.amber.withOpacity(0.5),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 width: 8,
//                 height: 8,
//                 decoration: BoxDecoration(
//                   color: Colors.amber.withOpacity(0.5),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCompanyTitle() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title and Profile Image Row
//               Text(
//                 CustomFunctions.toSentenceCase(
//                     widget.buisines!.name.toString()),
//                 style: AppTheme.mediumHeadingText(lightTextColor),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.location_on, color: greyTextColor, size: 20),
//                   const SizedBox(width: 4),
//                   Text(
//                     '${CustomFunctions.toSentenceCase(widget.buisines!.state.toString())}, ${CustomFunctions.toSentenceCase(widget.buisines!.city)}',
//                     style: AppTheme.bodyMediumTitleText(greyTextColor!),
//                   ),
//                 ],
//               ),
//               // Location and Rating Row
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDescriptionSection() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle('Description'),
//           const SizedBox(height: 8),
//           Text(
//             CustomFunctions.toSentenceCase(
//                 widget.buisines!.description.toString()),
//             style: AppTheme.bodyMediumTitleText(lightTextColor),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOverviewSection() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle('Overview'),
//           const SizedBox(height: 16),
//           _buildInfoRow('Industry', '${widget.buisines!.industry}'),
//           _buildInfoRow('Established Year', '${widget.buisines!.establish_yr}'),
//           _buildInfoRow('Address -1', '${widget.buisines!.address_1}'),
//           _buildInfoRow('Address -2', '${widget.buisines!.address_2}'),
//           _buildInfoRow('City', '${widget.buisines!.city}'),
//           _buildInfoRow('State', '${widget.buisines!.state}'),
//           _buildInfoRow('Pin Code', '${widget.buisines!.pin}'),
//           _buildInfoRow('No. of employees', '${widget.buisines!.employees}'),
//           _buildInfoRow('Legal Entity', '${widget.buisines!.entity ?? "N/A"}'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFinancialSection() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle('Financials'),
//           const SizedBox(height: 16),
//           _buildInfoRow(
//               'Average Monthly Revenue', '${widget.buisines!.avg_monthly}'),
//           _buildInfoRow(
//               'Latest Yearly Revenue', '${widget.buisines!.latest_yearly}'),
//           _buildInfoRow('EBITDA', '${widget.buisines!.ebitda}'),
//           _buildInfoRow('Type of Scale', '${widget.buisines!.type_sale}'),
//           _buildInfoRow(
//               'Asking Price', '${widget.buisines!.askingPrice ?? "N/A"}'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAdditionalInfoSection() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle('Additional Info'),
//           const SizedBox(height: 16),
//           _buildInfoRow('Website', '${widget.buisines!.url}'),
//           _buildInfoRow('Features', '${widget.buisines!.features}'),
//           _buildInfoRow('Facilities', '${widget.buisines!.facility}'),
//           _buildInfoRow('Income Sources', '${widget.buisines!.income_source}'),
//           _buildInfoRow('Reason for Sale', '${widget.buisines!.reason}'),
//           _buildInfoRow('Posted Time', '${widget.buisines!.postedTime}'),
//           _buildInfoRow('Top Selling', '${widget.buisines!.topSelling}'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: AppTheme.mediumHeadingText(lightTextColor),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 140,
//             child: Text(
//               label,
//               style: AppTheme.bodyMediumTitleText(lightTextColor),
//             ),
//           ),
//           Text(
//             ': ',
//             style: AppTheme.bodyMediumTitleText(lightTextColor),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: AppTheme.bodyMediumTitleText(lightTextColor),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Top container for displaying images
// class ImageSliderHeader extends StatefulWidget {
//   const ImageSliderHeader(
//       {Key? key,
//         required this.image1,
//         required this.image2,
//         required this.image3,
//         required this.buisiness})
//       : super(key: key);
//
//   final String image1;
//   final String image2;
//   final String image3;
//   final BusinessInvestorExplr buisiness;
//
//   @override
//   State<ImageSliderHeader> createState() => _ImageSliderHeaderState();
// }
//
// class _ImageSliderHeaderState extends State<ImageSliderHeader> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   late List<String> _images = [
//     widget.image1 ??
//         'https://images.pexels.com/photos/29094491/pexels-photo-29094491/free-photo-of-modern-glass-skyscraper-against-blue-sky.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
//     widget.image2 ??
//         'https://images.pexels.com/photos/29104613/pexels-photo-29104613/free-photo-of-cityscape-with-train-and-skyscrapers-in-melbourne.jpeg?auto=compress&cs=tinysrgb&w=600',
//     widget.image2 ??
//         'https://images.pexels.com/photos/29049243/pexels-photo-29049243/free-photo-of-modern-curved-skyscraper-in-urban-setting.jpeg?auto=compress&cs=tinysrgb&w=600',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _isWishlistCheck();
//   }
//
//   Future<void> _isWishlistCheck() async {
//     final _storage = await FlutterSecureStorage();
//     final WishlistController wishlistController = Get.put(WishlistController());
//     wishlistController.checkIfItemInWishlist("", widget.buisiness.id);
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final WishlistController wishlistController = Get.put(WishlistController());
//
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => ZoomImagePage(
//                       image1: widget.image1,
//                       image2: widget.image2,
//                       image3: widget.image3,
//                     )));
//           },
//           child: SizedBox(
//             height: 320,
//             child: Column(
//               children: [
//                 Container(
//                   height: 270,
//                   width: double.infinity,
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                       bottom: Radius.circular(16),
//                       top: Radius.circular(16),
//                     ),
//                     child: PageView.builder(
//                       controller: _pageController,
//                       onPageChanged: (index) {
//                         setState(() {
//                           _currentPage = index;
//                         });
//                       },
//                       itemCount: _images.length,
//                       itemBuilder: (context, index) {
//                         return Image.network(
//                           _images[index],
//                           fit: BoxFit.cover,
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           top: 16,
//           left: 16,
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.arrow_back, color: Colors.white),
//           ),
//         ),
//         Positioned(
//             top: 16,
//             right: 16,
//             child: Obx(() {
//               return CircleAvatar(
//                 backgroundColor: Colors.white.withOpacity(0.2),
//                 child: Center(
//                   child: LikeButton(
//                     isLiked: wishlistController.isAddedToWishlist.value,
//                     onTap: (bool isLiked) async {
//                       final storage = FlutterSecureStorage();
//                       final token = await storage.read(key: 'token');
//
//                       if (token != null) {
//                         wishlistController.toggleWishlist(
//                             token, widget.buisiness!.id);
//                         return !isLiked;
//                       } else {
//                         Get.snackbar(
//                           'Error',
//                           'Token not found. Please log in again.',
//                           backgroundColor: Colors.red,
//                           colorText: Colors.white,
//                           snackPosition: SnackPosition.BOTTOM,
//                         );
//                         return isLiked;
//                       }
//                     },
//                     likeBuilder: (bool isLiked) {
//                       return Icon(
//                         isLiked ? Icons.favorite : Icons.favorite_border,
//                         color: isLiked ? Colors.red : Colors.white,
//                         size: 24.0,
//                       );
//                     },
//                     animationDuration: Duration(milliseconds: 900),
//                     bubblesColor: BubblesColor(
//                       dotPrimaryColor: Colors.white,
//                       dotSecondaryColor: Colors.red,
//                     ),
//                   ),
//                 ),
//               );
//             })),
//         Positioned(
//           bottom: 16,
//           left: 0,
//           right: 0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               _images.length,
//                   (index) => Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 width: 15,
//                 height: 15,
//                 decoration: BoxDecoration(
//                   color: _currentPage == index
//                       ? Colors.amber
//                       : Colors.amber.withOpacity(0.5),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // page for zoomIn property
// class ZoomImagePage extends StatefulWidget {
//   const ZoomImagePage(
//       {Key? key,
//         required this.image1,
//         required this.image2,
//         required this.image3})
//       : super(key: key);
//
//   static const String routeName = '/zoom-image';
//
//   final String image1;
//   final String image2;
//   final String image3;
//
//   @override
//   State<ZoomImagePage> createState() => _ZoomImagePageState();
// }
//
// class _ZoomImagePageState extends State<ZoomImagePage> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//   bool _isZoomed = false;
//
//   late List<String> _images = [
//     widget.image1 ??
//         'https://images.pexels.com/photos/29094491/pexels-photo-29094491/free-photo-of-modern-glass-skyscraper-against-blue-sky.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
//     widget.image2 ??
//         'https://images.pexels.com/photos/29104613/pexels-photo-29104613/free-photo-of-cityscape-with-train-and-skyscrapers-in-melbourne.jpeg?auto=compress&cs=tinysrgb&w=600',
//     widget.image3 ??
//         'https://images.pexels.com/photos/29049243/pexels-photo-29049243/free-photo-of-modern-curved-skyscraper-in-urban-setting.jpeg?auto=compress&cs=tinysrgb&w=600',
//   ];
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _handleImageTap() {
//     setState(() {
//       _isZoomed = !_isZoomed;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 if (_isZoomed)
//                   Expanded(
//                     child: Container(
//                       color: Colors.black,
//                       child: PhotoViewGallery.builder(
//                         pageController: _pageController,
//                         itemCount: _images.length,
//                         builder: (context, index) {
//                           return PhotoViewGalleryPageOptions(
//                             imageProvider: NetworkImage(_images[index]),
//                             minScale: PhotoViewComputedScale.contained,
//                             maxScale: PhotoViewComputedScale.covered * 2,
//                           );
//                         },
//                         onPageChanged: (index) {
//                           setState(() {
//                             _currentPage = index;
//                           });
//                         },
//                         backgroundDecoration:
//                         const BoxDecoration(color: Colors.black),
//                       ),
//                     ),
//                   )
//                 else
//                   Column(
//                     children: [
//                       Container(
//                         height: MediaQuery.of(context).size.height * 0.75,
//                         width: double.infinity,
//                         child: ClipRRect(
//                           borderRadius: const BorderRadius.vertical(
//                             bottom: Radius.circular(20),
//                           ),
//                           child: GestureDetector(
//                             onTap: _handleImageTap,
//                             child: PageView.builder(
//                               controller: _pageController,
//                               onPageChanged: (index) {
//                                 setState(() {
//                                   _currentPage = index;
//                                 });
//                               },
//                               itemCount: _images.length,
//                               itemBuilder: (context, index) {
//                                 return Image.network(
//                                   _images[index],
//                                   fit: BoxFit.fill,
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       // Image indicators
//                       if (!_isZoomed)
//                         Container(
//                           height: 120,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 5,
//                           ),
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: List.generate(
//                                 _images.length,
//                                     (index) => GestureDetector(
//                                   onTap: () {
//                                     _pageController.animateToPage(
//                                       index,
//                                       duration:
//                                       const Duration(milliseconds: 300),
//                                       curve: Curves.easeInOut,
//                                     );
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5),
//                                     child: Container(
//                                       height: 120,
//                                       margin: const EdgeInsets.symmetric(
//                                           horizontal: 8),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(20),
//                                         border: Border.all(
//                                           color: _currentPage == index
//                                               ? Colors.white
//                                               : Colors.transparent,
//                                           width: 2,
//                                         ),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color:
//                                             Colors.black.withOpacity(0.2),
//                                             blurRadius: 4,
//                                             offset: const Offset(0, 2),
//                                           ),
//                                         ],
//                                       ),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(20),
//                                         child: Image.network(
//                                           _images[index],
//                                           fit: BoxFit.cover,
//                                           width: 100,
//                                           height: 100,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//               ],
//             ),
//             // Back button
//             Positioned(
//               top: 16,
//               left: 16,
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.3),
//                   shape: BoxShape.circle,
//                 ),
//                 child: GestureDetector(
//                   onTap: () {
//                     if (_isZoomed) {
//                       setState(() {
//                         _isZoomed = false;
//                       });
//                     } else {
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: const Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class DocumentButton extends StatelessWidget {
//   final String text;
//
//   const DocumentButton({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.center,
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.80,
//         height: 55,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         decoration: BoxDecoration(
//           color: Color(0xffF3D55E),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.insert_drive_file, color: Colors.white),
//                 SizedBox(width: 8),
//                 Text(
//                   text,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//             Icon(Icons.download, color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class SubscribeButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//         alignment: Alignment.center,
//         child: Container(
//             height: 50,
//             width: MediaQuery.of(context).size.width * 0.45,
//             padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//             decoration: BoxDecoration(
//               color: Colors.yellow[600],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Center(
//               child: Text(
//                 'Subscribe',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//             ),
//             ),
//         );
//     }
// }




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:project_emergio/Views/chat_screens/chat%20screen.dart';
import 'package:project_emergio/Views/pricing%20screen.dart';
import 'package:project_emergio/Widgets/custom%20connect%20button.dart';
import 'package:project_emergio/Widgets/custom_funtions.dart';
import 'package:project_emergio/controller/wishlist%20controller.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/models/all%20profile%20model.dart';
import 'package:project_emergio/services/chatUserCheck.dart';
import 'package:project_emergio/services/check%20subscribe.dart';
import 'package:project_emergio/services/inbox%20service.dart';

import '../../Widgets/report_widget.dart';
import '../../services/report_post_service.dart';

class BusinessDetailPage extends StatefulWidget {
  @override
  State<BusinessDetailPage> createState() => _BusinessDetailPageState();
  final BusinessInvestorExplr? buisines;
  final String? id;
  final String? imageUrl;
  final String? image2;
  final String? image3;
  final String? image4;
  final String? name;
  final String? industry;
  final String? establish_yr;
  final String? description;
  final String? address_1;
  final String? address_2;
  final String? pin;
  final String? city;
  final String? state;
  final String? employees;
  final String? entity;
  final String? avg_monthly;
  final String? latest_yearly;
  final String? ebitda;
  final String? rate;
  final String? type_sale;
  final String? url;
  final String? features;
  final String? facility;
  final String? income_source;
  final String? reason;
  final String? postedTime;
  final String? topSelling;
  final String? userId;
  final bool showEditOption;

    BusinessDetailPage({
    this.buisines,
    this.imageUrl,
    this.image2,
    this.image3,
    this.image4,
    this.name,
    this.industry,
    this.establish_yr,
    this.description,
    this.address_1,
    this.address_2,
    this.pin,
    this.city,
    this.state,
    this.employees,
    this.entity,
    this.avg_monthly,
    this.latest_yearly,
    this.ebitda,
    this.rate,
    this.type_sale,
    this.url,
    this.features,
    this.facility,
    this.income_source,
    this.reason,
    this.userId,
    this.postedTime,
    this.topSelling,
    this.id,
    required this.showEditOption,
  });
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  var subscription;
  bool subscribed = false;

  @override
  void initState() {
    super.initState();
    _checkSubscription();
  }

  void _checkSubscription() async {
    try {
      subscription = await CheckSubscription.fetchSubscription();
      setState(() {
        subscribed = subscription['status'];
      });
    } catch (e) {
      print("Error fetching subscription: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageSliderHeader(
                  buisiness: widget.buisines!,
                  image1: widget.buisines!.imageUrl,
                  image2: widget.buisines!.image2,
                  image3: widget.buisines!.image3.toString(),
                ),
                _buildCompanyTitle(),
                _buildDescriptionSection(),
                _buildOverviewSection(),
                _buildFinancialSection(),
                _buildAdditionalInfoSection(),
                SizedBox(height: 15.h),
                SizedBox(height: 25.h),
                subscribed
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomConnectButton(
                      buttonHeight: 45.h,
                      buttonWidth: 200.w,
                      buttonColor: Colors.yellow[600],
                      text: 'Connect',
                      onPressed: () async {
                        String receiverUserId = widget.buisines!.id.toString();
                        final userId = await ChatUserCheck.fetchChatUserData();
                        var room = await Inbox.roomCreation(receiverUserId: receiverUserId);
                        if (room['status']) {
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
                      },
                    ),
                  ],
                )
                    : Align(
                  alignment: Alignment.center,
                  child: CustomConnectButton(
                    buttonHeight: 45.h,
                    buttonWidth: 200.w,
                    buttonColor: Colors.yellow[600],
                    text: "Subscribe",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Subscription Status'),
                            content: Text('You have not purchased any plans. Please visit the pricing page to choose a plan.'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: Text('View plans'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PricingScreenNew()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: ReportButton(
                    onSubmit: (String reason, String reasonType, String id) async {
                      try {
                        if (id.isEmpty) {
                          throw Exception('Post ID cannot be empty');
                        }

                        await ReportPost.reportPost(
                          reason: reason,
                          reasonType: reasonType,
                          postId: widget.buisines!.id.toString(),
                        );
                        return true;
                      } catch (e) {
                        throw e;
                      }
                    }, postId: widget.id.toString(),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyTitle() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CustomFunctions.toSentenceCase(widget.buisines!.title.toString()),
                style: AppTheme.mediumHeadingText(lightTextColor),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(Icons.location_on, color: greyTextColor, size: 20.sp),
                  SizedBox(width: 4.w),
                  Text(
                    '${CustomFunctions.toSentenceCase(widget.buisines!.state.toString())}, ${CustomFunctions.toSentenceCase(widget.buisines!.city)}',
                    style: AppTheme.bodyMediumTitleText(greyTextColor!),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Description'),
          SizedBox(height: 8.h),
          Text(
            CustomFunctions.toSentenceCase(widget.buisines!.description.toString()),
            style: AppTheme.bodyMediumTitleText(lightTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Overview'),
          SizedBox(height: 16.h),
          _buildInfoRow('Industry', '${widget.buisines!.industry}'),
          _buildInfoRow('Established Year', '${widget.buisines!.establish_yr}'),
          _buildInfoRow('Address -1', '${widget.buisines!.address_1}'),
          _buildInfoRow('Address -2', '${widget.buisines!.address_2}'),
          _buildInfoRow('City', '${widget.buisines!.city}'),
          _buildInfoRow('State', '${widget.buisines!.state}'),
          _buildInfoRow('Pin Code', '${widget.buisines!.pin}'),
          _buildInfoRow('No. of employees', '${widget.buisines!.employees}'),
          _buildInfoRow('Legal Entity', '${widget.buisines!.entity ?? "N/A"}'),
        ],
      ),
    );
  }

  Widget _buildFinancialSection() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Financials'),
          SizedBox(height: 16.h),
          _buildInfoRow('Average Monthly Revenue', '${widget.buisines!.avg_monthly}'),
          _buildInfoRow('Latest Yearly Revenue', '${widget.buisines!.latest_yearly}'),
          _buildInfoRow('EBITDA', '${widget.buisines!.ebitda}'),
          _buildInfoRow('Type of Scale', '${widget.buisines!.type_sale}'),
          _buildInfoRow('Asking Price', '${widget.buisines!.askingPrice ?? "N/A"}'),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    DateTime parsedDateTime = DateTime.parse(widget.buisines!.postedTime);
    String formattedDateTime = '${DateFormat("dd-MM-yyyy").format(parsedDateTime)}';


    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Additional Info'),
          SizedBox(height: 16.h),
          _buildInfoRow('Website', '${widget.buisines!.url}'),
          _buildInfoRow('Features', '${widget.buisines!.features}'),
          _buildInfoRow('Facilities', '${widget.buisines!.facility}'),
          _buildInfoRow('Income Sources', '${widget.buisines!.income_source}'),
          _buildInfoRow('Reason for Sale', '${widget.buisines!.reason}'),
          _buildInfoRow('Posted Time', formattedDateTime),
          _buildInfoRow('Top Selling', '${widget.buisines!.topSelling}'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.mediumHeadingText(lightTextColor),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140.w,
            child: Text(
              label,
              style: AppTheme.bodyMediumTitleText(lightTextColor),
            ),
          ),
          Text(
            ': ',
            style: AppTheme.bodyMediumTitleText(lightTextColor),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMediumTitleText(lightTextColor),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageSliderHeader extends StatefulWidget {
  const ImageSliderHeader({
    Key? key,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.buisiness
  }) : super(key: key);

  final String image1;
  final String image2;
  final String image3;
  final BusinessInvestorExplr buisiness;

  @override
  State<ImageSliderHeader> createState() => _ImageSliderHeaderState();
}

class _ImageSliderHeaderState extends State<ImageSliderHeader> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late List<String> _images = [
    widget.image1 ?? 'https://images.pexels.com/photos/29094491/pexels-photo-29094491/free-photo-of-modern-glass-skyscraper-against-blue-sky.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    widget.image2 ?? 'https://images.pexels.com/photos/29104613/pexels-photo-29104613/free-photo-of-cityscape-with-train-and-skyscrapers-in-melbourne.jpeg?auto=compress&cs=tinysrgb&w=600',
    widget.image3 ?? 'https://images.pexels.com/photos/29049243/pexels-photo-29049243/free-photo-of-modern-curved-skyscraper-in-urban-setting.jpeg?auto=compress&cs=tinysrgb&w=600',
  ];

  @override
  void initState() {
    super.initState();
    _isWishlistCheck();
  }

  Future<void> _isWishlistCheck() async {
    final _storage = await FlutterSecureStorage();
    final WishlistController wishlistController = Get.put(WishlistController());
    wishlistController.checkIfItemInWishlist("", widget.buisiness.id);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController = Get.put(WishlistController());

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ZoomImagePage(
                  image1: widget.image1,
                  image2: widget.image2,
                  image3: widget.image3,
                ),
              ),
            );
          },
          child: SizedBox(
            height: 320.h,
            child: Column(
              children: [
                Container(
                  height: 270.h,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16.r),
                      top: Radius.circular(16.r),
                    ),
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          _images[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16.h,
          left: 16.w,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
            ),
          ),
        ),
        Positioned(
          top: 16.h,
          right: 16.w,
          child: Obx(() {
            return CircleAvatar(
              // backgroundColor: Colors.white.withOpacity(0.2),
              backgroundColor: Colors.black12,
              child: Center(
                child: LikeButton(
                  isLiked: wishlistController.isAddedToWishlist.value,
                  onTap: (bool isLiked) async {
                    final storage = FlutterSecureStorage();
                    final token = await storage.read(key: 'token');

                    if (token != null) {
                      wishlistController.toggleWishlist(token, widget.buisiness.id);
                      return !isLiked;
                    } else {
                      Get.snackbar(
                        'Error',
                        'Token not found. Please log in again.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return isLiked;
                    }
                  },
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white,
                      size: 24.sp,
                    );
                  },
                  animationDuration: Duration(milliseconds: 900),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Colors.white,
                    dotSecondaryColor: Colors.red,
                  ),
                ),
              ),
            );
          }),
        ),
        Positioned(
          bottom: 16.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _images.length,
                  (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: 15.w,
                height: 15.h,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.amber
                      : Colors.amber.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ZoomImagePage extends StatefulWidget {
  const ZoomImagePage({
    Key? key,
    required this.image1,
    required this.image2,
    required this.image3,
  }) : super(key: key);

  static const String routeName = '/zoom-image';

  final String image1;
  final String image2;
  final String image3;

  @override
  State<ZoomImagePage> createState() => _ZoomImagePageState();
}

class _ZoomImagePageState extends State<ZoomImagePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isZoomed = false;

  late List<String> _images = [
    widget.image1 ?? 'https://images.pexels.com/photos/29094491/pexels-photo-29094491/free-photo-of-modern-glass-skyscraper-against-blue-sky.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    widget.image2 ?? 'https://images.pexels.com/photos/29104613/pexels-photo-29104613/free-photo-of-cityscape-with-train-and-skyscrapers-in-melbourne.jpeg?auto=compress&cs=tinysrgb&w=600',
    widget.image3 ?? 'https://images.pexels.com/photos/29049243/pexels-photo-29049243/free-photo-of-modern-curved-skyscraper-in-urban-setting.jpeg?auto=compress&cs=tinysrgb&w=600',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleImageTap() {
    setState(() {
      _isZoomed = !_isZoomed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                if (_isZoomed)
                  Expanded(
                    child: Container(
                      color: Colors.black,
                      child: PhotoViewGallery.builder(
                        pageController: _pageController,
                        itemCount: _images.length,
                        builder: (context, index) {
                          return PhotoViewGalleryPageOptions(
                            imageProvider: NetworkImage(_images[index]),
                            minScale: PhotoViewComputedScale.contained,
                            maxScale: PhotoViewComputedScale.covered * 2,
                          );
                        },
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        backgroundDecoration: const BoxDecoration(color: Colors.black),
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20.r),
                          ),
                          child: GestureDetector(
                            onTap: _handleImageTap,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemCount: _images.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  _images[index],
                                  fit: BoxFit.fill,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      if (!_isZoomed)
                        Container(
                          height: 120.h,
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _images.length,
                                    (index) => GestureDetector(
                                  onTap: () {
                                    _pageController.animateToPage(
                                      index,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                                    child: Container(
                                      height: 120.h,
                                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.r),
                                        border: Border.all(
                                          color: _currentPage == index
                                              ? Colors.white
                                              : Colors.transparent,
                                          width: 2.w,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20.r),
                                        child: Image.network(
                                          _images[index],
                                          fit: BoxFit.cover,
                                          width: 100.w,
                                          height: 100.h,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            Positioned(
              top: 16.h,
              left: 16.w,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (_isZoomed) {
                      setState(() {
                        _isZoomed = false;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_emergio/Views/advisor%20explore%20page.dart';
// import 'package:project_emergio/Views/detail%20page/advisor%20detail%20page.dart';
// import 'package:project_emergio/Widgets/custom_funtions.dart';
// import 'package:project_emergio/generated/constants.dart';
// import '../models/all profile model.dart';
// import '../services/featured.dart';
//
// class FeatureExpertList extends StatefulWidget {
//   final bool? isType;
//   final bool? isAdvisor;
//   final String? profile;
//   const FeatureExpertList({Key? key, this.isType, this.isAdvisor, this.profile})
//       : super(key: key);
//
//   @override
//   _FeatureExpertListState createState() => _FeatureExpertListState();
// }
//
// class _FeatureExpertListState extends State<FeatureExpertList> {
//   List<AdvisorExplr>? _experts;
//   bool _isLoading = true;
//   String? _error;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchExperts();
//   }
//
//   Future<void> _fetchExperts() async {
//     try {
//       if (widget.isType == true) {
//         final experts = await Featured.fetchFeaturedAdvisorData();
//         setState(() {
//           _experts = experts;
//           _isLoading = false;
//         });
//       } else {
//         final experts = await Featured.fetchAllAdvisorData();
//         setState(() {
//           _experts = experts;
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = 'Failed to load experts';
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16.0.w),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                   widget.isType == true
//                       ? "Featured List"
//                       : widget.isAdvisor == true
//                       ? 'Advisor Lists'
//                       : "Featured Expert",
//                   style: AppTheme.titleText(lightTextColor)
//               ),
//               InkWell(
//                 onTap: () {
//                   widget.isType == true
//                       ? Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const AdvisorExploreScreen(
//                             currentIndex: 1,
//                           )))
//                       : Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const AdvisorExploreScreen(
//                             currentIndex: 0,
//                           )));
//                 },
//                 child: SizedBox(
//                   child: Text(
//                       widget.profile != null ?
//                       widget.profile == "home" ? '' : "See all" : "See all",
//                       style: AppTheme.bodyMediumTitleText(buttonColor).copyWith(
//                           fontWeight: FontWeight.bold
//                       )
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 215.h,
//           child: _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : _error != null
//               ? Center(child: Text(_error!))
//               : _experts == null || _experts!.isEmpty
//               ? const Center(child: Text('No experts available'))
//               : ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: _experts!.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: EdgeInsets.only(
//                     left: index == 0 ? 13.w : 4.w, right: 6.w),
//                 child: ExpertCard(expert: _experts![index]),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class ExpertCard extends StatelessWidget {
//   final AdvisorExplr expert;
//
//   const ExpertCard({Key? key, required this.expert}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => AdvisorDetailPage(
//                   advisor: expert,
//                 )));
//       },
//       child: Container(
//         width: 171.w,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12.r), //
//           border: Border.all(color: buttonColor, width: 2.w), //
//         ),
//         child: Stack(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.vertical(
//                   top: Radius.circular(10.r),
//                   bottom: Radius.circular(10.r)),
//               child: Image.network(
//                 expert.imageUrl,
//                 height: double.infinity,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Image.network(
//                     'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
//                     height: double.infinity,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 8.w, top: 130.h, right: 8.w), //
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//
//                     CustomFunctions.toSentenceCase(expert.title),
//                     style: AppTheme.titleText(Colors.white),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     expert.singleLineDescription ?? 'Expert',
//                     style: AppTheme.mediumSmallText(Colors.white),
//                   ),
//                   SizedBox(height: 4.h), //
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: buttonColor, size: 16.sp), //
//                       SizedBox(width: 4.w), //
//                       Text(
//                           '4.5',
//                           style: AppTheme.smallText(Colors.white)
//                       ),
//                       const Spacer(),
//                       Container(
//                         padding: EdgeInsets.all(4.w), //
//                         decoration: const BoxDecoration(
//                           color: buttonColor,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(Icons.chat_bubble,
//                             color: Colors.white, size: 16.sp), //
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Views/advisor%20explore%20page.dart';
import 'package:project_emergio/Views/detail%20page/advisor%20detail%20page.dart';
import 'package:project_emergio/Widgets/custom_funtions.dart';
import 'package:project_emergio/generated/constants.dart';
import '../models/all profile model.dart';
import '../services/featured.dart';

class FeatureExpertList extends StatefulWidget {
  final bool? isType;
  final bool? isAdvisor;
  final String? profile;
  const FeatureExpertList({Key? key, this.isType, this.isAdvisor, this.profile})
      : super(key: key);

  @override
  _FeatureExpertListState createState() => _FeatureExpertListState();
}

class _FeatureExpertListState extends State<FeatureExpertList> {
  List<AdvisorExplr>? _experts;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchExperts();
  }

  Future<void> _fetchExperts() async {
    try {
      if (widget.isType == true) {
        final experts = await Featured.fetchFeaturedAdvisorData();
        setState(() {
          _experts = experts;
          _isLoading = false;
        });
      } else {
        final experts = await Featured.fetchAllAdvisorData();
        setState(() {
          _experts = experts;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load experts';
        _isLoading = false;
      });
    }
  }

  double _getCardHeight(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    return isTablet ? 220.h : 215.h; // Slightly reduced for tablet
  }

  double _getCardWidth(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    return isTablet ? 160.w : 171.w; // Reduced width for tablet
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;
    final cardHeight = _getCardHeight(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(isTablet ? 14.w : 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isType == true
                    ? "Featured List"
                    : widget.isAdvisor == true
                    ? 'Advisor Lists'
                    : "Featured Expert",
                style: AppTheme.titleText(lightTextColor).copyWith(
                  fontSize: isTablet ? 18.sp : null, // Reduced for tablet
                ),
              ),
              InkWell(
                onTap: () {
                  widget.isType == true
                      ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdvisorExploreScreen(
                        currentIndex: 1,
                      ),
                    ),
                  )
                      : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdvisorExploreScreen(
                        currentIndex: 0,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  child: Text(
                    widget.profile != null
                        ? widget.profile == "home"
                        ? ''
                        : "See all"
                        : "See all",
                    style: AppTheme.bodyMediumTitleText(buttonColor).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 14.sp : null, // Reduced for tablet
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: cardHeight,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
            child: Text(
              _error!,
              style: TextStyle(
                fontSize: isTablet ? 14.sp : null,
              ),
            ),
          )
              : _experts == null || _experts!.isEmpty
              ? Center(
            child: Text(
              'No experts available',
              style: TextStyle(
                fontSize: isTablet ? 14.sp : null,
              ),
            ),
          )
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _experts!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 13.w : 4.w,
                  right: 6.w,
                ),
                child: ExpertCard(
                  expert: _experts![index],
                  isTablet: isTablet,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ExpertCard extends StatelessWidget {
  final AdvisorExplr expert;
  final bool isTablet;

  const ExpertCard({
    Key? key,
    required this.expert,
    this.isTablet = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidth = isTablet ? 160.w : 171.w;

    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdvisorDetailPage(
              advisor: expert,

            ),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isTablet ? 10.r : 12.r),
          border: Border.all(
            color: buttonColor,
            width: isTablet ? 1.5.w : 2.w,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(isTablet ? 8.r : 10.r),
                bottom: Radius.circular(isTablet ? 8.r : 10.r),
              ),
              child: Image.network(
                expert.imageUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: isTablet ? 6.w : 8.w,
                top: isTablet ? 120.h : 130.h,
                right: isTablet ? 6.w : 8.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CustomFunctions.toSentenceCase(expert.title),
                    style: AppTheme.titleText(Colors.white).copyWith(
                      fontSize: isTablet ? 14.sp : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    maxLines: 1,
                    expert.singleLineDescription ?? 'Expert',
                    style: AppTheme.mediumSmallText(Colors.white).copyWith(
                      fontSize: isTablet ? 12.sp : null,
                    ),
                  ),
                  SizedBox(height: isTablet ? 3.h : 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: buttonColor,
                        size: isTablet ? 14.sp : 16.sp,
                      ),
                      SizedBox(width: isTablet ? 3.w : 4.w),
                      Text(
                        expert.average_rating != null
                            ? expert.average_rating!.toStringAsFixed(1)
                            : 'N/A',                        style: AppTheme.smallText(Colors.white).copyWith(
                          fontSize: isTablet ? 12.sp : null,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.all(isTablet ? 3.w : 4.w),
                        decoration: const BoxDecoration(
                          color: buttonColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.chat_bubble,
                          color: Colors.white,
                          size: isTablet ? 14.sp : 16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
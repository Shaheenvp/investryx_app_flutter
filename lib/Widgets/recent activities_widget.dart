// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:project_emergio/Widgets/custom_funtions.dart';
// import 'package:project_emergio/generated/constants.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import '../services/latest transactions and activites.dart';
//
// class RecentActivitiesWidget extends StatefulWidget {
//   const RecentActivitiesWidget({Key? key}) : super(key: key);
//
//   @override
//   State<RecentActivitiesWidget> createState() => _RecentActivitiesWidgetState();
// }
//
// class _RecentActivitiesWidgetState extends State<RecentActivitiesWidget> {
//   List<LatestActivites> activities = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchRecentActivities();
//   }
//
//   Future<void> _fetchRecentActivities() async {
//     try {
//       List<LatestActivites>? fetchedActivities =
//       await LatestTransactions.fetchLatestTransactions();
//       if (fetchedActivities != null) {
//         setState(() {
//           activities = fetchedActivities;
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error fetching activities: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   String formatDateTime(String dateTimeStr) {
//     DateTime dateTime = DateTime.parse(dateTimeStr);
//     return timeago.format(dateTime, allowFromNow: true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (activities.isEmpty) {
//       return const Center(child: Text('No activities found.'));
//     }
//
//     return Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: activities.length > 2 ? 2 : activities.length,
//             itemBuilder: (context, index) {
//               final activity = activities[index];
//               return Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
//                 child: Container(
//                   height: 160.h,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(16.w),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: 120.h,
//                           width: 115.w,
//                           child: Stack(children: [
//                             Positioned(
//                               top: 28,
//                               child: Container(
//                                 height: 91.h,
//                                 width: 115.w,
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: const Color(0xffFFCC00),
//                                         width: 1.5),
//                                     borderRadius: const BorderRadius.only(
//                                         bottomRight: Radius.circular(15),
//                                         bottomLeft: Radius.circular(15))),
//                               ),
//                             ),
//                             Positioned(
//                               top: 8,
//                               child: ClipRRect(
//                                 borderRadius: const BorderRadius.only(
//                                     bottomRight: Radius.circular(15),
//                                     bottomLeft: Radius.circular(15),
//                                     topLeft: Radius.circular(15)),
//                                 child: Image.network(
//                                   activity.imageUrl, // Add null check here
//                                   width: 100.w,
//                                   height: 110.w,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Container(
//                                       width: 100.w,
//                                       height: 110.w,
//                                       color: Colors.grey[300],
//                                       child: const Icon(Icons.error),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ]),
//                         ),
//                         SizedBox(width: 16.w),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 CustomFunctions.toSentenceCase(
//                                     activity.username), // Add null check
//                                 style:
//                                 AppTheme.bodyMediumTitleText(lightTextColor)
//                                     .copyWith(fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 4.h),
//                               Text(
//                                 activity.title, // Add null check
//                                 style:
//                                 AppTheme.bodyMediumTitleText(lightTextColor)
//                                     .copyWith(fontWeight: FontWeight.w500),
//                               ),
//                               SizedBox(height: 4.h),
//                               Text(
//                                 activity.description, // Add null check
//                                 style: AppTheme.smallText(lightTextColor),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               SizedBox(height: 8.h),
//                               Text(
//                                 overflow: TextOverflow.ellipsis,
//                                 'INR ${activity.askingPrice ?? 0}',
//                                 // 'INR {activity.minAmount ?? 0} L - INR {activity.maxAmount ?? 0} L',
//                                 style: AppTheme.smallText(lightTextColor).copyWith(fontWeight: FontWeight.w500),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   void addActivity(LatestActivites newActivity) {
//     setState(() {
//       activities.add(newActivity);
//       });
//     }
// }




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/Widgets/custom_funtions.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../services/latest transactions and activites.dart';

class RecentActivitiesWidget extends StatefulWidget {
  const RecentActivitiesWidget({Key? key}) : super(key: key);

  @override
  State<RecentActivitiesWidget> createState() => _RecentActivitiesWidgetState();
}

class _RecentActivitiesWidgetState extends State<RecentActivitiesWidget> {
  List<LatestActivites> activities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentActivities();
  }

  Future<void> _fetchRecentActivities() async {
    try {
      List<LatestActivites>? fetchedActivities =
      await LatestTransactions.fetchLatestTransactions();
      if (fetchedActivities != null) {
        setState(() {
          activities = fetchedActivities;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching activities: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return timeago.format(dateTime, allowFromNow: true);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: isTablet ? 3.0 : 4.0,
        ),
      );
    }

    if (activities.isEmpty) {
      return Center(
        child: Text(
          'No activities found.',
          style: TextStyle(fontSize: isTablet ? 14.sp : null),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length > 2 ? 2 : activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isTablet ? 6.h : 8.h,
                  horizontal: isTablet ? 20.w : 16.w,
                ),
                child: Container(
                  height: isTablet ? 160.h : 160.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(isTablet ? 10.r : 12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isTablet ? 12.w : 16.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: isTablet ? 115.h : 120.h,
                          width: isTablet ? 105.w : 115.w,
                          child: Stack(
                            children: [
                              Positioned(
                                top: isTablet ? 24 : 28,
                                child: Container(
                                  height: isTablet ? 100.h : 91.h,
                                  width: isTablet ? 98.w : 115.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffFFCC00),
                                      width: isTablet ? 1.2 : 1.5,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: isTablet ? 6 : 8,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                  ),
                                  child: Image.network(
                                    activity.imageUrl,
                                    width: isTablet ? 90.w : 100.w,
                                    height: isTablet ? 100.w : 110.w,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: isTablet ? 90.w : 100.w,
                                        height: isTablet ? 100.w : 110.w,
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.error,
                                          size: isTablet ? 20.sp : 24.sp,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: isTablet ? 14.w : 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CustomFunctions.toSentenceCase(activity.username),
                                style: AppTheme.bodyMediumTitleText(lightTextColor)
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isTablet ? 13.sp : null,
                                ),
                              ),
                              SizedBox(height: isTablet ? 3.h : 4.h),
                              Text(
                                activity.title,
                                style: AppTheme.mediumSmallText(lightTextColor)
                                    .copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: isTablet ? 13.sp : null,
                                ),
                              ),
                              SizedBox(height: isTablet ? 3.h : 4.h),
                              Text(
                                activity.description,
                                style: AppTheme.smallText(lightTextColor).copyWith(
                                  fontSize: isTablet ? 10.sp : null,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: isTablet ? 4.h : 8.h),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                'INR ${activity.askingPrice ?? 0}',
                                style: AppTheme.smallText(lightTextColor).copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: isTablet ? 10.sp : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void addActivity(LatestActivites newActivity) {
    setState(() {
      activities.add(newActivity);
    });
  }
}
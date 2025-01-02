// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shimmer/shimmer.dart';
// import '../services/notification.dart';
//
// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});
//
//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }
//
// class _NotificationScreenState extends State<NotificationScreen> {
//   late Future<Map<String, List<ProductDetails>>?> notificationsByDate;
//
//   @override
//   void initState() {
//     super.initState();
//     notificationsByDate = NotificationService.fetchNotification().then((list) {
//       return _groupByDate(list ?? []);
//     });
//   }
//
//   Map<String, List<ProductDetails>> _groupByDate(List<ProductDetails> notifications) {
//     Map<String, List<ProductDetails>> groupedNotifications = {};
//     for (var notification in notifications) {
//       String formattedDate = DateFormat.yMMMMd().format(DateTime.parse(notification.date));
//       String dayName = DateFormat('EEEE').format(DateTime.parse(notification.date));
//       String displayDate = '${DateFormat('dd, MM, yyyy').format(DateTime.parse(notification.date))}\n$dayName';
//
//       if (groupedNotifications.containsKey(displayDate)) {
//         groupedNotifications[displayDate]!.add(notification);
//       } else {
//         groupedNotifications[displayDate] = [notification];
//       }
//     }
//     return groupedNotifications;
//   }
//
//   Future<void> _deleteNotification(int notificationId, int index, String dateKey) async {
//     final shouldDelete = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Notification'),
//         content: const Text('Are you sure you want to delete this notification?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//
//     if (shouldDelete ?? false) {
//       final success = await NotificationService.deleteNotification(notificationId);
//       if (success) {
//         setState(() {
//           notificationsByDate = notificationsByDate.then((groupedNotifications) {
//             groupedNotifications?[dateKey]?.removeAt(index);
//             if (groupedNotifications?[dateKey]?.isEmpty ?? false) {
//               groupedNotifications?.remove(dateKey);
//             }
//             return groupedNotifications;
//           });
//         });
//
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               duration: Duration(milliseconds: 800),
//               content: Text('Notification deleted'),
//             ),
//           );
//         }
//       }
//     }
//   }
//
//   Widget _buildShimmer() {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: 4,
//       separatorBuilder: (context, index) => const SizedBox(height: 16.0),
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             height: 80,
//             decoration: BoxDecoration(
//               color: const Color(0xffF3F8FE),
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDateSection(String date) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Text(
//         date,
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           color: Colors.grey,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNotificationItem(ProductDetails notification, String dateKey, int index) {
//     return Dismissible(
//       key: Key(notification.id.toString()),
//       direction: DismissDirection.endToStart,
//       confirmDismiss: (direction) async {
//         // Add haptic feedback
//         await HapticFeedback.mediumImpact();
//         return await showDialog<bool>(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Delete Notification'),
//             content: const Text('Are you sure you want to delete this notification?'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context, false),
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context, true),
//                 child: const Text(
//                   'Delete',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//         ) ?? false;
//       },
//       onDismissed: (direction) {
//         _deleteNotification(notification.id, index, dateKey);
//       },
//       background: Container(
//         decoration: BoxDecoration(
//           color: Colors.red.shade100,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.delete_outline,
//                   color: Colors.red.shade700,
//                   size: 28,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Delete',
//                   style: TextStyle(
//                     color: Colors.red.shade700,
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         curve: Curves.easeInOut,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 6.0),
//           child: Container(
//             decoration: BoxDecoration(
//               color: const Color(0xffF3F8FE),
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.3),
//                   spreadRadius: 2,
//                   blurRadius: 6,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: ListTile(
//               leading: Hero(
//                 tag: 'notification_image_${notification.id}',
//                 child: Container(
//                   width: 60,
//                   height: 60,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.white60,
//                   ),
//                   child: ClipOval(
//                     child: Image.network(
//                       notification.imageUrl,
//                       width: 55,
//                       height: 55,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           color: Colors.grey[200],
//                           child: Icon(
//                             Icons.image_not_supported,
//                             size: 30,
//                             color: Colors.grey[400],
//                           ),
//                         );
//                       },
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Center(
//                           child: CircularProgressIndicator(
//                             value: loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded /
//                                 loadingProgress.expectedTotalBytes!
//                                 : null,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               title: Text(
//                 notification.title,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               subtitle: Text(
//                 notification.description,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Notification',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FutureBuilder<Map<String, List<ProductDetails>>?>(
//           future: notificationsByDate,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return _buildShimmer();
//             } else if (snapshot.hasError) {
//               return const Center(child: Text('Failed to load notifications'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Lottie.asset(
//                       'assets/nodata.json',
//                       height: 80.h,
//                       width: 90.w,
//                       fit: BoxFit.cover,
//                     ),
//                     const Text('No notifications available')
//                   ],
//                 ),
//               );
//             } else {
//               final groupedNotifications = snapshot.data!;
//               return ListView.builder(
//                 itemCount: groupedNotifications.length,
//                 itemBuilder: (context, dateIndex) {
//                   String dateKey = groupedNotifications.keys.elementAt(dateIndex);
//                   List<ProductDetails> notifications = groupedNotifications[dateKey]!;
//
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildDateSection(dateKey),
//                       ListView.builder(
//                         physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: notifications.length,
//                         itemBuilder: (context, index) {
//                           return _buildNotificationItem(
//                             notifications[index],
//                             dateKey,
//                             index,
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                     ],
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../services/notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with TickerProviderStateMixin {
  late Future<Map<String, List<ProductDetails>>?> notificationsByDate;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  final Map<String, AnimationController> _itemControllers = {};

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    notificationsByDate = NotificationService.fetchNotification().then((list) {
      return _groupByDate(list ?? []);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    for (var controller in _itemControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Create animation controller for each notification item
  AnimationController _getItemController(String key) {
    if (!_itemControllers.containsKey(key)) {
      _itemControllers[key] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
    }
    return _itemControllers[key]!;
  }

  Map<String, List<ProductDetails>> _groupByDate(
      List<ProductDetails> notifications) {
    Map<String, List<ProductDetails>> groupedNotifications = {};
    for (var notification in notifications) {
      String formattedDate =
          DateFormat.yMMMMd().format(DateTime.parse(notification.date));
      String dayName =
          DateFormat('EEEE').format(DateTime.parse(notification.date));
      String displayDate =
          '${DateFormat('dd, MM, yyyy').format(DateTime.parse(notification.date))}\n$dayName';

      if (groupedNotifications.containsKey(displayDate)) {
        groupedNotifications[displayDate]!.add(notification);
      } else {
        groupedNotifications[displayDate] = [notification];
      }
    }
    return groupedNotifications;
  }

  Future<void> _deleteNotification(
      int notificationId, int index, String dateKey) async {
    final itemController = _getItemController('${dateKey}_$index');
    await itemController.reverse();

    final success =
        await NotificationService.deleteNotification(notificationId);
    if (success) {
      setState(() {
        notificationsByDate = notificationsByDate.then((groupedNotifications) {
          groupedNotifications?[dateKey]?.removeAt(index);
          if (groupedNotifications?[dateKey]?.isEmpty ?? false) {
            groupedNotifications?.remove(dateKey);
          }
          return groupedNotifications;
        });
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Notification deleted'),
              ],
            ),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                // Implement undo functionality here
              },
            ),
          ),
        );
      }
    }
  }

  Widget _buildShimmer() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xffF3F8FE),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateSection(String date) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-0.5, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: _fadeController,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            date,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
      ProductDetails notification, String dateKey, int index) {
    final itemController = _getItemController('${dateKey}_$index');
    if (itemController.status == AnimationStatus.dismissed) {
      itemController.forward();
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: itemController,
        curve: Curves.easeOutCubic,
      )),
      child: FadeTransition(
        opacity: itemController,
        child: Dismissible(
          key: Key(notification.id.toString()),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            await HapticFeedback.mediumImpact();
            return await showGeneralDialog<bool>(
                  context: context,
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return ScaleTransition(
                      scale: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ),
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text('Delete Notification'),
                        content: const Text(
                            'Are you sure you want to delete this notification?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  barrierDismissible: true,
                  barrierLabel: 'Dismiss',
                  transitionDuration: const Duration(milliseconds: 200),
                  barrierColor: Colors.black54,
                ) ??
                false;
          },
          onDismissed: (direction) {
            _deleteNotification(notification.id, index, dateKey);
          },
          background: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.3, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: itemController,
              curve: Curves.easeOutCubic,
            )),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.red.shade700,
                              size: 28,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          child: GestureDetector(
            onTapDown: (_) {
              HapticFeedback.lightImpact();
            },
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: 0.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, value * 50),
                  child: Opacity(
                    opacity: 1 - value,
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF3F8FE),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Hero(
                      tag: 'notification_image_${notification.id}',
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white60,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              notification.imageUrl,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 30,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      notification.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Notification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, List<ProductDetails>>?>(
          future: notificationsByDate,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmer();
            } else if (snapshot.hasError) {
              return Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: const Text('Failed to load notifications'),
                      ),
                    );
                  },
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: 0.8 + (0.2 * value),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              'assets/nodata.json',
                              height: 80.h,
                              width: 90.w,
                              fit: BoxFit.cover,
                            ),
                            const Text('No notifications available')
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              final groupedNotifications = snapshot.data!;
              return ListView.builder(
                itemCount: groupedNotifications.length,
                itemBuilder: (context, dateIndex) {
                  String dateKey =
                      groupedNotifications.keys.elementAt(dateIndex);
                  List<ProductDetails> notifications =
                      groupedNotifications[dateKey]!;

                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (dateIndex * 100)),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDateSection(dateKey),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return _buildNotificationItem(
                              notifications[index],
                              dateKey,
                              index,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:project_emergio/Widgets/profile_adding_navbar_popup.dart';
// import 'package:project_emergio/Widgets/tutorial_coach_mark.dart';
//
// import '../Views/Home/home_screen.dart';
// import '../Views/profile page.dart';
// import '../Views/search page.dart';
// import '../Views/wishlist page.dart';
//
// class CustomBottomNavBar extends StatefulWidget {
//   final int initialIndex;
//   final bool isFirstTime;
//
//
//   const CustomBottomNavBar({
//     Key? key,
//     this.initialIndex = 0,
//     this.isFirstTime = false,
//   }) : super(key: key);
//
//   @override
//   State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }
//
// class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
//   late int _currentIndex;
//   late PageController _pageController;
//   final Size designSize = const Size(375, 812);
//   final GlobalKey fabKey = GlobalKey();
//
//
//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//     _pageController = PageController(initialPage: widget.initialIndex);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (widget.isFirstTime) {
//         final fabTutorial = FabTutorialCoachMark(context, fabKey);
//         FabTutorialCoachMark.shouldShowTutorial().then((shouldShow) {
//           if (shouldShow) {
//             fabTutorial.showTutorial();
//           }
//         });
//       }
//     });
//   }
//
//   final List<Widget> _screens = [
//     InveStryxHomePage(),
//     const SearchScreen(),
//     const WishlistScreen(),
//     ProfileScreen(),
//   ];
//
//   Future<void> _provideHapticFeedback({HapticFeedbackType type = HapticFeedbackType.selection}) async {
//     switch (type) {
//       case HapticFeedbackType.selection:
//         await HapticFeedback.selectionClick();
//         break;
//       case HapticFeedbackType.light:
//         await HapticFeedback.lightImpact();
//         break;
//       case HapticFeedbackType.medium:
//         await HapticFeedback.mediumImpact();
//         break;
//       case HapticFeedbackType.heavy:
//         await HapticFeedback.heavyImpact();
//         break;
//     }
//   }
//
//   void _onItemTapped(int index) async {
//     if (_currentIndex != index) {
//       await _provideHapticFeedback(type: HapticFeedbackType.selection);
//       setState(() {
//         _currentIndex = index;
//         _pageController.jumpToPage(index);
//       });
//     }
//   }
//
//   Future<bool> _onWillPop() async {
//     if (_currentIndex != 0) {
//       await _provideHapticFeedback(type: HapticFeedbackType.light);
//       setState(() {
//         _currentIndex = 0;
//         _pageController.jumpToPage(0);
//       });
//       return false;
//     }
//     return true;
//   }
//
//   double getResponsiveValue(BuildContext context, double value) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return (screenWidth / designSize.width) * value;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bottomNavHeight = getResponsiveValue(context, 60);
//     final fabSize = getResponsiveValue(context, 52);
//     final iconSize = getResponsiveValue(context, 22);
//     final fabIconSize = getResponsiveValue(context, 26);
//     final fontSize = getResponsiveValue(context, 11);
//     final centerGap = getResponsiveValue(context, 65);
//
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         extendBody: true,
//         body: PageView(
//           controller: _pageController,
//           physics: const NeverScrollableScrollPhysics(),
//           children: _screens,
//           onPageChanged: (index) async {
//             await _provideHapticFeedback(type: HapticFeedbackType.selection);
//             setState(() => _currentIndex = index);
//           },
//         ),
//         floatingActionButton: SizedBox(
//           key: fabKey,  // Add the key here
//           height: fabSize,
//           width: fabSize,
//           child: FloatingActionButton(
//             heroTag: 'navbar_fab',
//             onPressed: () async {
//               await _provideHapticFeedback(type: HapticFeedbackType.light);
//               showDialog(
//                 context: context,
//                 builder: (context) => const BusinessOptionsDialog(),
//               );
//             },
//             backgroundColor: const Color(0xFFFFCC00),
//             child: Icon(Icons.add, color: Colors.white, size: fabIconSize),
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(fabSize / 2),
//             ),
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//         bottomNavigationBar: Container(
//           height: bottomNavHeight,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: getResponsiveValue(context, 10),
//                 spreadRadius: 0,
//                 offset: const Offset(0, -3),
//               ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(getResponsiveValue(context, 20)),
//                   topRight: Radius.circular(getResponsiveValue(context, 20)),
//                 ),
//                 child: BottomAppBar(
//                   height: bottomNavHeight,
//                   padding: EdgeInsets.zero,
//                   shape: const CircularNotchedRectangle(),
//                   notchMargin: getResponsiveValue(context, 7),
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Expanded(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   _buildNavItem(
//                                     icon: 'home_icon.png',
//                                     label: 'Home',
//                                     index: 0,
//                                     iconSize: iconSize,
//                                     fontSize: fontSize,
//                                   ),
//                                   _buildNavItem(
//                                     icon: 'search_icon.png',
//                                     label: 'Search',
//                                     index: 1,
//                                     iconSize: iconSize,
//                                     fontSize: fontSize,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(width: centerGap),
//                             Expanded(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   _buildNavItem(
//                                     icon: 'fav_icon.png',
//                                     label: 'Favorites',
//                                     index: 2,
//                                     iconSize: iconSize,
//                                     fontSize: fontSize,
//                                   ),
//                                   _buildNavIconItem(
//                                     icon: Icons.person_outline,
//                                     activeIcon: Icons.person,
//                                     label: 'Profile',
//                                     index: 3,
//                                     iconSize: iconSize,
//                                     fontSize: fontSize,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Add the "Sell" text in the center of the bottom nav
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: getResponsiveValue(context, 5),
//                 child: Center(
//                   child: Text(
//                     'Sell',
//                     style: TextStyle(
//                       color: const Color(0xff939393),
//                       fontSize: fontSize,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildNavItem({
//     required String icon,
//     required String label,
//     required int index,
//     required double iconSize,
//     required double fontSize,
//   }) {
//     final isSelected = _currentIndex == index;
//     return GestureDetector(
//       onTapDown: (_) async {
//         if (!isSelected) {
//           await _provideHapticFeedback(type: HapticFeedbackType.light);
//         }
//       },
//       child: InkWell(
//         onTap: () => _onItemTapped(index),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ImageIcon(
//               AssetImage('assets/$icon'),
//               color: isSelected ? const Color(0xFFFFCC00) : const Color(0xff939393),
//               size: iconSize,
//             ),
//             SizedBox(height: getResponsiveValue(context, 1)),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? const Color(0xFFFFCC00) : const Color(0xff939393),
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavIconItem({
//     required IconData icon,
//     required IconData activeIcon,
//     required String label,
//     required int index,
//     required double iconSize,
//     required double fontSize,
//   }) {
//     final isSelected = _currentIndex == index;
//     return GestureDetector(
//       onTapDown: (_) async {
//         if (!isSelected) {
//           await _provideHapticFeedback(type: HapticFeedbackType.light);
//         }
//       },
//       child: InkWell(
//         onTap: () => _onItemTapped(index),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isSelected ? activeIcon : icon,
//               color: isSelected ? const Color(0xFFFFCC00) : const Color(0xff939393),
//               size: iconSize,
//             ),
//             SizedBox(height: getResponsiveValue(context, 1)),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? const Color(0xFFFFCC00) : const Color(0xff939393),
//                 fontSize: fontSize,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
// }
//
// enum HapticFeedbackType {
//   selection,
//   light,
//   medium,
//   heavy,
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_emergio/Widgets/profile_adding_navbar_popup.dart';
import 'package:project_emergio/Widgets/tutorial_coach_mark.dart';
import '../Views/Home/home_screen.dart';
import '../Views/profile page.dart';
import '../Views/search page.dart';
import '../Views/wishlist page.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int initialIndex;
  final bool isFirstTime;

  const CustomBottomNavBar({
    Key? key,
    this.initialIndex = 0,
    this.isFirstTime = false,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int _currentIndex;
  late PageController _pageController;
  final Size designSize = const Size(375, 812);
  final GlobalKey fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isFirstTime) {
        final fabTutorial = FabTutorialCoachMark(context, fabKey);
        FabTutorialCoachMark.shouldShowTutorial().then((shouldShow) {
          if (shouldShow) {
            fabTutorial.showTutorial();
          }
        });
      }
    });
  }

  final List<Widget> _screens = [
    InveStryxHomePage(),
    const SearchScreen(),
    const WishlistScreen(),
    ProfileScreen(),
  ];

  double getResponsiveValue(BuildContext context, double value) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth >= 768;

    if (isTablet) {
      Map<String, double> tabletScaleFactors = {
        'height': 0.7,    // Bottom nav height
        'fab': 0.8,       // FAB size
        'icon': 0.85,     // Icons
        'font': 0.9,      // Text
        'gap': 0.75,      // Center gap
        'margin': 0.8,    // Margins and paddings
        'radius': 0.85,   // Border radius
        'shadow': 0.7,    // Shadow
      };

      double scaleFactor;
      if (value == 60) {  // Bottom nav height
        scaleFactor = tabletScaleFactors['height']!;
      } else if (value == 52) {  // FAB size
        scaleFactor = tabletScaleFactors['fab']!;
      } else if (value == 22 || value == 26) {  // Icons
        scaleFactor = tabletScaleFactors['icon']!;
      } else if (value == 11) {  // Font size
        scaleFactor = tabletScaleFactors['font']!;
      } else if (value == 65) {  // Center gap
        scaleFactor = tabletScaleFactors['gap']!;
      } else if (value == 20) {  // Border radius
        scaleFactor = tabletScaleFactors['radius']!;
      } else if (value == 10) {  // Shadow blur
        scaleFactor = tabletScaleFactors['shadow']!;
      } else {  // Other values
        scaleFactor = tabletScaleFactors['margin']!;
      }

      return (screenWidth / designSize.width) * value * scaleFactor;
    }

    return (screenWidth / designSize.width) * value;
  }

  Future<void> _provideHapticFeedback({HapticFeedbackType type = HapticFeedbackType.selection}) async {
    switch (type) {
      case HapticFeedbackType.selection:
        await HapticFeedback.selectionClick();
        break;
      case HapticFeedbackType.light:
        await HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        await HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        await HapticFeedback.heavyImpact();
        break;
    }
  }

  void _onItemTapped(int index) async {
    if (_currentIndex != index) {
      await _provideHapticFeedback(type: HapticFeedbackType.selection);
      setState(() {
        _currentIndex = index;
        _pageController.jumpToPage(index);
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      await _provideHapticFeedback(type: HapticFeedbackType.light);
      setState(() {
        _currentIndex = 0;
        _pageController.jumpToPage(0);
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 768;

    final bottomNavHeight = getResponsiveValue(context, 60);
    final fabSize = getResponsiveValue(context, 52);
    final iconSize = getResponsiveValue(context, 22);
    final fabIconSize = getResponsiveValue(context, 26);
    final fontSize = getResponsiveValue(context, 11);
    final centerGap = getResponsiveValue(context, 65);

    return WillPopScope(
        onWillPop: _onWillPop,
        child: MediaQuery(
        data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
    child: Scaffold(
        extendBody: true,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _screens,
          onPageChanged: (index) async {
            await _provideHapticFeedback(type: HapticFeedbackType.selection);
            setState(() => _currentIndex = index);
          },
        ),
        floatingActionButton: SizedBox(
          key: fabKey,
          height: fabSize,
          width: fabSize,
          child: FloatingActionButton(
            heroTag: 'navbar_fab',
            onPressed: () async {
              await _provideHapticFeedback(type: HapticFeedbackType.light);
              showDialog(
                context: context,
                builder: (context) => const BusinessOptionsDialog(),
              );
            },
            backgroundColor: const Color(0xFFFFCC00),
            child: Icon(Icons.add, color: Colors.white, size: fabIconSize),
            elevation: isTablet ? 3 : 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(fabSize / 2),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          height: bottomNavHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isTablet ? 0.08 : 0.1),
                blurRadius: getResponsiveValue(context, 10),
                spreadRadius: 0,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(getResponsiveValue(context, 20)),
                  topRight: Radius.circular(getResponsiveValue(context, 20)),
                ),
                child: BottomAppBar(
                  height: bottomNavHeight,
                  padding: EdgeInsets.zero,
                  shape: const CircularNotchedRectangle(),
                  notchMargin: getResponsiveValue(context, 7),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildNavItem(
                                    icon: 'home_icon.png',
                                    label: 'Home',
                                    index: 0,
                                    iconSize: iconSize,
                                    fontSize: fontSize,
                                  ),
                                  _buildNavItem(
                                    icon: 'search_icon.png',
                                    label: 'Search',
                                    index: 1,
                                    iconSize: iconSize,
                                    fontSize: fontSize,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: centerGap),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildNavItem(
                                    icon: 'fav_icon.png',
                                    label: 'Favorites',
                                    index: 2,
                                    iconSize: iconSize,
                                    fontSize: fontSize,
                                  ),
                                  _buildNavIconItem(
                                    icon: Icons.person_outline,
                                    activeIcon: Icons.person,
                                    label: 'Profile',
                                    index: 3,
                                    iconSize: iconSize,
                                    fontSize: fontSize,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: getResponsiveValue(context, 5),
                child: Center(
                  child: Text(
                    'Sell',
                    style: TextStyle(
                      color: const Color(0xff939393),
                      fontSize: fontSize,
                      fontWeight: isTablet ? FontWeight.w500 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        )
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required int index,
    required double iconSize,
    required double fontSize,
  }) {
    final isSelected = _currentIndex == index;
    final isTablet = MediaQuery.of(context).size.width >= 768;

    return GestureDetector(
      onTapDown: (_) async {
        if (!isSelected) {
          await _provideHapticFeedback(type: HapticFeedbackType.light);
        }
      },
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage('assets/$icon'),
              color: isSelected ? const Color(0xFFFFCC00) : const Color(0xff939393),
              size: iconSize,
            ),
            SizedBox(height: getResponsiveValue(context, 1)),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFFCC00) : const Color(0xff939393),
                fontSize: fontSize,
                fontWeight: isTablet ? FontWeight.w500 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIconItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required double iconSize,
    required double fontSize,
  }) {
    final isSelected = _currentIndex == index;
    final isTablet = MediaQuery.of(context).size.width >= 768;

    return GestureDetector(
      onTapDown: (_) async {
        if (!isSelected) {
          await _provideHapticFeedback(type: HapticFeedbackType.light);
        }
      },
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? const Color(0xFFFFCC00) : const Color(0xff939393),
              size: iconSize,
            ),
            SizedBox(height: getResponsiveValue(context, 1)),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFFCC00) : const Color(0xff939393),
                fontSize: fontSize,
                fontWeight: isTablet ? FontWeight.w500 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

enum HapticFeedbackType {
  selection,
  light,
  medium,
  heavy,
}
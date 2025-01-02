// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:project_emergio/services/api_list.dart';
// import '../services/banners.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shimmer/shimmer.dart';
//
// class BannerSlider extends StatefulWidget {
//   final String type;
//   const BannerSlider({Key? key, required this.type}) : super(key: key);
//
//   @override
//   _BannerSliderState createState() => _BannerSliderState();
// }
//
// class _BannerSliderState extends State<BannerSlider> {
//   late List<BannerImage> _bannerImages = [];
//   bool _isLoading = true;
//   bool _hasError = false;
//   bool _noData = false;
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchImages();
//   }
//
//   Future<void> fetchImages() async {
//     try {
//       List<Map<String, dynamic>>? banners = await BannerGet.fetchBanners(widget.type);
//       if (banners != null && banners.isNotEmpty) {
//         List<BannerImage> validImages = [];
//
//         for (var banner in banners) {
//           String? imageUrl = banner['img'] as String?;
//           if (imageUrl != null) {
//             BannerImage? processedImage = _validateAndProcessUrl(imageUrl);
//             if (processedImage != null) {
//               validImages.add(processedImage);
//             }
//           }
//         }
//
//         setState(() {
//           _bannerImages = validImages;
//           _isLoading = false;
//           _hasError = false;
//           _noData = validImages.isEmpty;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _hasError = false;
//           _noData = true;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//         _noData = false;
//       });
//       print('Error fetching banners: $e'); // For debugging
//     }
//   }
//
//   BannerImage? _validateAndProcessUrl(String url) {
//     const String baseUrl = ApiList.imageBaseUrl;
//     if (url.isEmpty) return null;
//
//     try {
//       // Process the URL
//       String processedUrl = url;
//       if (!url.startsWith('http')) {
//         processedUrl = url.startsWith('/') ? url.substring(1) : url;
//         processedUrl = baseUrl + processedUrl;
//       }
//
//       // Check if it's an SVG
//       bool isSvg = processedUrl.toLowerCase().endsWith('.svg');
//       return BannerImage(processedUrl, isSvg);
//     } catch (e) {
//       print('Error processing URL: $e'); // For debugging
//       return null;
//     }
//   }
//
//   Widget _buildLoadingIndicator() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         height: 165.h,
//         width: double.infinity,
//         margin: EdgeInsets.symmetric(horizontal: 5.w),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15.r),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageLoadingIndicator() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15.r),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorMessage() {
//     return Container(
//       height: 250.h,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 40.sp, color: Colors.red),
//             SizedBox(height: 12.h),
//             Text(
//               "Oops! Something went wrong.",
//               style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 6.h),
//             Text(
//               "Please try again later.",
//               style: TextStyle(fontSize: 14.sp),
//             ),
//             SizedBox(height: 12.h),
//             ElevatedButton(
//               onPressed: fetchImages,
//               child: Text("Retry"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme.of(context).primaryColor,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.r),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNoDataMessage() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 165.h,
//       margin: EdgeInsets.symmetric(horizontal: 5.w),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15.r),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.white,
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(15.r),
//         child: Image.asset(
//           'assets/default_banner.png',
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) {
//             return Center(
//               child: Icon(
//                 Icons.image_not_supported,
//                 color: Colors.grey,
//                 size: 40.sp,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBannerImage(BannerImage image) {
//     if (image.isSvg) {
//       return SvgPicture.network(
//         image.url,
//         fit: BoxFit.cover,
//         placeholderBuilder: (BuildContext context) => _buildImageLoadingIndicator(),
//       );
//     } else {
//       return CachedNetworkImage(
//         imageUrl: image.url,
//         fit: BoxFit.cover,
//         placeholder: (context, url) => _buildImageLoadingIndicator(),
//         errorWidget: (context, url, error) => Center(
//           child: Icon(Icons.error, color: Colors.red, size: 40.sp),
//         ),
//       );
//     }
//   }
//
//   Widget _buildCarousel() {
//     return Stack(
//       children: [
//         CarouselSlider(
//           options: CarouselOptions(
//             height: 165.h,
//             autoPlay: true,
//             enlargeCenterPage: true,
//             aspectRatio: 16 / 9,
//             viewportFraction: .97,
//             onPageChanged: (index, reason) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//           ),
//           items: _bannerImages.map((bannerImage) {
//             return Builder(
//               builder: (BuildContext context) {
//                 return Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.symmetric(horizontal: 5.w),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15.r),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.white,
//                         spreadRadius: 1,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15.r),
//                     child: _buildBannerImage(bannerImage),
//                   ),
//                 );
//               },
//             );
//           }).toList(),
//         ),
//         Positioned(
//           bottom: 10.h,
//           left: 0,
//           right: 0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: _bannerImages.asMap().entries.map((entry) {
//               return Container(
//                 width: 8.w,
//                 height: 8.h,
//                 margin: EdgeInsets.symmetric(horizontal: 4.w),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Theme.of(context).cardColor.withOpacity(
//                     _currentIndex == entry.key ? 0.9 : 0.4,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       duration: Duration(milliseconds: 300),
//       child: _buildContent(),
//     );
//   }
//
//   Widget _buildContent() {
//     if (_isLoading) return _buildLoadingIndicator();
//     if (_hasError) return _buildErrorMessage();
//     if (_noData) return _buildNoDataMessage();
//     return _buildCarousel();
//   }
// }
//
// class BannerImage {
//   final String url;
//   final bool isSvg;
//
//   BannerImage(this.url, this.isSvg);
// }


import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_emergio/services/api_list.dart';
import '../services/banners.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class BannerSlider extends StatefulWidget {
  final String type;
  const BannerSlider({Key? key, required this.type}) : super(key: key);

  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  late List<BannerImage> _bannerImages = [];
  bool _isLoading = true;
  bool _hasError = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      List<Map<String, dynamic>>? banners = await BannerGet.fetchBanners(widget.type);
      if (banners != null && banners.isNotEmpty) {
        List<BannerImage> validImages = [];

        for (var banner in banners) {
          String? imageUrl = banner['img'] as String?;
          if (imageUrl != null) {
            BannerImage? processedImage = _validateAndProcessUrl(imageUrl);
            if (processedImage != null) {
              // Preload images for faster display
              if (!processedImage.isSvg) {
                precacheImage(CachedNetworkImageProvider(processedImage.url), context);
              }
              validImages.add(processedImage);
            }
          }
        }

        if (mounted) {
          setState(() {
            _bannerImages = validImages;
            _isLoading = false;
            _hasError = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
      print('Error fetching banners: $e');
    }
  }

  BannerImage? _validateAndProcessUrl(String url) {
    const String baseUrl = ApiList.imageBaseUrl;
    if (url.isEmpty) return null;

    try {
      String processedUrl = url;
      if (!url.startsWith('http')) {
        processedUrl = url.startsWith('/') ? url.substring(1) : url;
        processedUrl = baseUrl + processedUrl;
      }

      bool isSvg = processedUrl.toLowerCase().endsWith('.svg');
      return BannerImage(processedUrl, isSvg);
    } catch (e) {
      print('Error processing URL: $e');
      return null;
    }
  }

  Widget _buildLoadingIndicator() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 165.h,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
    );
  }

  Widget _buildImageLoadingIndicator() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      height: 250.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 40.sp, color: Colors.red),
            SizedBox(height: 12.h),
            Text(
              "Oops! Something went wrong.",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.h),
            Text(
              "Please try again later.",
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: fetchImages,
              child: Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerImage(BannerImage image) {
    if (image.isSvg) {
      return SvgPicture.network(
        image.url,
        fit: BoxFit.cover,
        placeholderBuilder: (BuildContext context) => _buildImageLoadingIndicator(),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: image.url,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (context, url) => _buildImageLoadingIndicator(),
        errorWidget: (context, url, error) => Center(
          child: Icon(Icons.error, color: Colors.red, size: 40.sp),
        ),
      );
    }
  }

  Widget _buildCarousel() {
    if (_bannerImages.isEmpty) return SizedBox.shrink();

    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 165.h,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: .97,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: _bannerImages.map((bannerImage) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: _buildBannerImage(bannerImage),
                  ),
                );
              },
            );
          }).toList(),
        ),
        if (_bannerImages.length > 1) Positioned(
          bottom: 10.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _bannerImages.asMap().entries.map((entry) {
              return Container(
                width: 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).cardColor.withOpacity(
                    _currentIndex == entry.key ? 0.9 : 0.4,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) return _buildLoadingIndicator();
    if (_hasError) return _buildErrorMessage();
    return _buildCarousel();
  }
}

class BannerImage {
  final String url;
  final bool isSvg;

  BannerImage(this.url, this.isSvg);
}
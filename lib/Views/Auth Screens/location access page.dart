import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'Questionnare/Questionnare1.dart';

class LocationService {

  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Future<Position?> getCurrentLocation(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return null;
        }
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10), // Add timeout
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  Future<LocationData> getAddressFromLatLng(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
          // localeIdentifier: 'en'
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks[0];
        return LocationData(
          city: placemark.locality ?? 'Unknown city',
          state: placemark.administrativeArea ?? 'Unknown state',
        );
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
    return LocationData(city: 'Unknown city', state: 'Unknown state');
  }
}

class LocationData {
  final String city;
  final String state;

  LocationData({required this.city, required this.state});
}

class LocationAccessScreen extends StatefulWidget {
  const LocationAccessScreen({super.key});

  @override
  State<LocationAccessScreen> createState() => _LocationAccessScreenState();
}

class _LocationAccessScreenState extends State<LocationAccessScreen>
    with SingleTickerProviderStateMixin {
  final LocationService locationService = LocationService();
  bool _isLoading = false;
  String? _currentLocation;
  late AnimationController _animationController;
  bool _isNavigating = false;
  bool _locationObtained = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2)
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _enableLocation() async {
    if (_isLoading || _isNavigating) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoading = false);
        if (mounted) _showLocationServiceDialog();
        return;
      }

      if (mounted) _showFetchingLocationDialog();

      Position? position = await locationService.getCurrentLocation(context);
      if (!mounted) return;

      if (position != null) {
        LocationData locationData = await locationService.getAddressFromLatLng(position);

        // Set flag before closing dialog
        _locationObtained = true;

        if (mounted) {
          Navigator.of(context).pop(); // Close the fetching dialog

          // Start the transition animation
          setState(() {
            _currentLocation = '${locationData.city}, ${locationData.state}';
            _isLoading = false;
          });

          // Delay for visual feedback
          await Future.delayed(Duration(milliseconds: 300));

          if (!_isNavigating && mounted) {
            _isNavigating = true;

            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    QuestionnareScreen1(
                        city: locationData.city,
                        state: locationData.state
                    ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = 0.0;
                  const end = 1.0;
                  var curve = Curves.easeInOut;

                  var fadeAnimation = Tween(
                    begin: begin,
                    end: end,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: curve,
                  ));

                  return FadeTransition(
                    opacity: fadeAnimation,
                    child: child,
                  );
                },
                transitionDuration: Duration(milliseconds: 400),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          Navigator.of(context).pop(); // Close the fetching dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to get location. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error in _enableLocation: $e');
      if (mounted) {
        Navigator.of(context).pop(); // Close the fetching dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted && !_locationObtained) {
        setState(() {
          _isLoading = false;
          _isNavigating = false;
        });
      }
    }
  }

  void _showFetchingLocationDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            content: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 500),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: Container(
                width: 300.w,
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 180.h,
                      width: 180.w,
                      child: Lottie.asset(
                        'assets/location.json',
                        fit: BoxFit.contain,
                        repeat: true,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Finding your location...',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'This helps us show the best local experiences',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: 180.w,
                      height: 4.h,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFFCC00)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLocationServiceDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r)
          ),
          title: Text(
              'Location Services Disabled',
              style: TextStyle(color: Colors.black)
          ),
          content: Text(
              'Please enable location services to continue.',
              style: TextStyle(color: Colors.black)
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Open Settings', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showNotNowConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Column(
            children: [
              Icon(
                Icons.location_off,
                size: 48.sp,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16.h),
              Text(
                'Are you sure?',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            'Without location access, you won\'t get personalized recommendations and the latest updates from businesses in your area.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Go Back',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 20.w),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFFCC00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Continue Anyway',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.only(bottom: 16.h, top: 8.h),
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              SizedBox(
                height: 180.h,
                child: Image.asset(
                  'assets/map.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 50.h),
              Text(
                'Enable Location',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                    color: Colors.black
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'We need your location to give you a better experience.',
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600]
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 80.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFFCC00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 100.w
                  ),
                ),
                onPressed: _isLoading ? null : () {
                  _animationController.repeat();
                  _enableLocation();
                },
                child: _isLoading
                    ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.w,
                  ),
                )
                    : Text(
                  'Enable Location',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: _isLoading ? null : () async {
                  if (!_isNavigating) {
                    final shouldContinue = await _showNotNowConfirmation();
                    if (shouldContinue && mounted) {
                      _isNavigating = true;
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuestionnareScreen1(
                              city: '',
                              state: ''
                          ),
                        ),
                      );
                      _isNavigating = false;
                    }
                  }
                },
                child: Text(
                  'Not Now',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.sp
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
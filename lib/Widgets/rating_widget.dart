import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:project_emergio/generated/constants.dart';

class CustomRatingDialog extends StatefulWidget {
  final Function(double rating, String review) onSubmit;

  const CustomRatingDialog({
    Key? key,
    required this.onSubmit, required bool isSubmitting,
  }) : super(key: key);

  @override
  State<CustomRatingDialog> createState() => _CustomRatingDialogState();
}

class _CustomRatingDialogState extends State<CustomRatingDialog> {
  double _userRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 28.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_rate_rounded,
                  color: Colors.amber,
                  size: 32.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Rate this Advisor',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 28.h),

            // Rating stars with animation
            _buildRatingStars(),
            SizedBox(height: 14.h),

            // Rating label
            Text(
              _getRatingLabel(),
              style: TextStyle(
                fontSize: 16.sp,
                color: buttonColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24.h),

            // Review Text Field
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Share your experience with this advisor...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15.sp,
                  ),
                  contentPadding: EdgeInsets.all(16.r),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            SizedBox(height: 28.h),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Submit Button
                ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _handleSubmit(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Text(
                    'Submit Rating',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            if (!_isSubmitting) {
              setState(() {
                _userRating = index + 1.0;
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(4.r),
            child: Icon(
              index < _userRating
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: index < _userRating ? Colors.amber : Colors.grey[400],
              size: 40.sp,
            ),
          ),
        );
      }),
    );
  }

  String _getRatingLabel() {
    if (_userRating == 0) return 'Tap to rate';
    if (_userRating == 1) return 'Poor';
    if (_userRating == 2) return 'Fair';
    if (_userRating == 3) return 'Good';
    if (_userRating == 4) return 'Very Good';
    return 'Excellent';
  }

  void _handleSubmit() async {
    if (_userRating == 0) {
      _showErrorSnackBar('Please select a rating');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(_userRating, _reviewController.text);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        _showErrorSnackBar('Failed to submit: ${e.toString()}');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.r),
        content: Text(message),
        backgroundColor: Colors.red[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}


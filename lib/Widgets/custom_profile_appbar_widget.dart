import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_emergio/generated/constants.dart';
import '../Views/dashboard/dashboard_screen.dart';
import '../generated/hero_tag_manager.dart';
import 'bottom navbar_widget.dart';

class CustomProfileHomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onProfileTap;
  final String profileImagePath;
  final VoidCallback? onBackPressed;
  final String type;

  const CustomProfileHomeAppBar({
    required this.type,
    super.key,
    this.title = 'Business',
    this.onProfileTap,
    this.profileImagePath = "assets/profile.png",
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onBackPressed ??
                () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomBottomNavBar(
                    // showBusinessIcon: false
                  ),
                ),
                    (route) => false,
              );
            },
        icon: const Icon(Icons.arrow_back),
      ),
      title: Center(
        child: Text(
          title,
          style:  AppTheme.headingText(lightTextColor).copyWith(fontSize: 22),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
    Hero(
    tag: HeroTagManager.generateUniqueTag('profile_avatar', type),
    child: InkWell(

          onTap: onProfileTap ??
                  () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardScreen(
                      type: type,
                    ),
                  ),
                );
              },
          child: CircleAvatar(
            radius: 22.r,
            backgroundImage: AssetImage(profileImagePath),
          ),
        ),
    ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final Widget? suffixIcon;
  final bool? isBackIcon;
  const CustomAppBarWidget({Key? key, required this.title, this.suffixIcon, this.isBackIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: isBackIcon ?? false,
      backgroundColor: backgroundColor,
      centerTitle: true,
      title: Text(
        title,
        style: AppTheme.headingText(lightTextColor).copyWith(fontSize: 22),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: suffixIcon ?? SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

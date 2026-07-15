import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const BottomNavBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //  height: kBottomNavigationBarHeight,
      decoration: const BoxDecoration(
        borderRadius: .only(topLeft: .circular(15), topRight: .circular(15)),
        gradient: LinearGradient(
          colors: [AppColors.mainColor, AppColors.black],
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,

        items: [
          navItem(AppSvgs.home, 0),
          navItem(AppSvgs.search24, 1),
          navItem(AppSvgs.cart24, 2),
          navItem(AppSvgs.heart24, 3),
          navItem(AppSvgs.user, 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem navItem(String svg, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedIndex == index ? Colors.white : Colors.transparent,
        ),
        child: SvgPicture.asset(
          svg,
          colorFilter: ColorFilter.mode(
            selectedIndex == index ? AppColors.mainColor : AppColors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: '',
    );
  }
}

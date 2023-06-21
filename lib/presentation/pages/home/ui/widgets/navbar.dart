import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBarHome extends StatelessWidget {
  NavBarHome({
    super.key,
  });
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GNav(
        selectedIndex: pageIndex,
        onTabChange: (index) {
          pageIndex = index;
        },
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        backgroundColor: Colors.orange,
        // rippleColor: Colors.grey[800]!, // tab button ripple color when pressed
        // hoverColor: Colors.grey[700]!, // tab button hover color
        haptic: true, // haptic feedback
        tabBorderRadius: 25,
        // tabActiveBorder:
        //     Border.all(color: Colors.black, width: 1), // tab button border
        // tabBorder:
        //     Border.all(color: Colors.grey, width: 1), // tab button border
        // tabShadow: [
        // BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)
        // ], // tab button shadow
        curve: Curves.linear, // tab animation curves
        duration: Duration(milliseconds: 500), // tab animation duration
        gap: 8, // the tab button gap between icon and text
        color: Colors.white70, // unselected icon color
        activeColor: Colors.black, // selected icon and text color
        iconSize: 24, // tab button icon size
        tabBackgroundColor: Colors.white, // selected tab background color
        padding: EdgeInsets.all(15), // navigation bar padding
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.search,
            text: 'Search',
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
          )
        ]);
  }
}

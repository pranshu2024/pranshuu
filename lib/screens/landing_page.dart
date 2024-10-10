import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart'; // Corrected import
import 'package:prophunter/screens/home_screen/home_screen.dart';
import 'package:prophunter/screens/profile/profile.dart';
import 'package:prophunter/screens/search_screen/search_screen.dart';

import '../../constant.dart';
import '../../size_config.dart';
import '../services/getData.dart';

class LandingPage extends StatefulWidget {
  static String routeName = "/landing_screen";

  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    SendData().getStatus(context);
    SendData().getCommunity(context);
    SendData().getBanner(context);
    SendData().getFeaturedCommunity(context);
    SendData().getPropertyType(context);
    SendData().getProperty(context);
    SendData().getTopPicks(context);
    SendData().getUser(context);
    SendData().getMinMax(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Colors.black,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.black,
      ),
      navBarStyle:
          NavBarStyle.style2, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const SearchScreen(),
      const Profile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: kSecondaryColor,
        inactiveColorPrimary: fadeWhite,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.search),
        title: ("Search"),
        activeColorPrimary: kSecondaryColor,
        inactiveColorPrimary: fadeWhite,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person),
        title: ("Profile"),
        activeColorPrimary: kSecondaryColor,
        inactiveColorPrimary: fadeWhite,
      ),
    ];
  }
}

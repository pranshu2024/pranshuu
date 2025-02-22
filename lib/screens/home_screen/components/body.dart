import 'package:flutter/material.dart';
import 'package:prophunter/constant.dart';
import 'package:prophunter/models/featuredCommunity.dart';
import 'package:prophunter/provider/basicDataProvider.dart';
import 'package:prophunter/screens/home_screen/components/banner_component.dart';
import 'package:prophunter/screens/home_screen/components/featured_community.dart';
import 'package:prophunter/screens/home_screen/components/filter_buttons.dart';
import 'package:prophunter/screens/home_screen/components/top_picks.dart';
import 'package:prophunter/widgets/text.dart';
import 'package:provider/provider.dart';

import 'map_widget.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    // For example:
    // Provider.of<BasicDataProvider>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BasicDataProvider>(
      builder: (_, provider, __) {
        // Retrieve data from provider
        List<int> topPicks = provider.getTopPick;
        List<FeaturedCommunity> featuredCommunityList =
            provider.featuredCommunityList;

        // Show loading indicator if any data is loading
        if (provider.isStatusLoading ||
            provider.isPropertyTypeLoading ||
            provider.isCommunityLoading ||
            provider.isPropertyLoading ||
            provider.isBannerLoading ||
            provider.isFeaturedCommunityLoading ||
            provider.isTopPicksLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Build the UI
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Component
            BannerComponent(banners: provider.bannerList),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Search by filter', style: headingWhite22),
                  defaultSpace2x,
                  FilterButton(
                    propertyTypeList: provider.getPropertyTypeList,
                    statusList: provider.getStatusTypeList,
                  ),
                  defaultSpace3x,
                  defaultSpace,
                  Text('Top Picks', style: headingWhite22),
                  defaultSpace2x,
                  TopPicks(topPick: topPicks),
                  defaultSpace3x,
                  defaultSpace,
                  const MapWidget(),
                  defaultSpace2x,
                  Text('Featured Communities', style: headingWhite22),
                  defaultSpace2x,
                  FeaturedCommunityList(
                      featuredCommunity: featuredCommunityList),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

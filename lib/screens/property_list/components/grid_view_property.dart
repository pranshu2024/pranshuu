import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:prophunter/constant.dart';
import 'package:prophunter/models/units.dart';
import 'package:prophunter/widgets/property_card.dart';
import '../../../size_config.dart';
import '../../property_details/property_details.dart';

class GridViewProperty extends StatelessWidget {
  const GridViewProperty({super.key, required this.unitList});
  final List<Units> unitList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        unitList.length,
        (index) => GestureDetector(
          onTap: () {
            pushNewScreen(
              context,
              screen: PropertyDetails(
                property: propertyMap[unitList[index].propertyId]!,
                unit: unitList[index],
              ),
              withNavBar: true, // OPTIONAL VALUE. True by default.
            );
          },
          child: PropertyCard(
            units: unitList[index],
            properties: propertyMap[unitList[index].propertyId]!,
            width: SizeConfig.screenWidth,
          ),
        ),
      ),
    );
  }

  void pushNewScreen(
    BuildContext context, {
    required Widget screen,
    required bool withNavBar,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

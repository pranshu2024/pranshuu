import 'package:flutter/material.dart';
import 'package:prophunter/models/properties.dart';
import 'package:prophunter/models/units.dart';
import 'package:prophunter/screens/property_details/property_details.dart';
import 'package:prophunter/services/queries.dart';
import 'package:prophunter/size_config.dart';
import 'package:prophunter/widgets/property_card.dart';
import 'package:provider/provider.dart';

import '../constant.dart';
import '../provider/propertyProvider.dart';
import '../widgets/custom_map.dart';

// Make the PropertyMap class public
class PropertyMap extends StatefulWidget {
  static const routeName = '/property_map';

  const PropertyMap({super.key});

  @override
  PropertyMapState createState() =>
      PropertyMapState(); // Use the public class name
}

// Make the state class public
class PropertyMapState extends State<PropertyMap> {
  int _selectedIndex = -1;
  List<Units> _unitList = [];

  @override
  void initState() {
    super.initState();
    // Add any initialization logic here if needed
  }

  @override
  Widget build(BuildContext context) {
    List<Properties> propertyList =
        Provider.of<PropertyProvider>(context).propertyList;

    SizeConfig().init(context);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomMap(
            press: (int index) async {
              _unitList = await CustomQuery()
                  .getUnitsByPropertyId(propertyList[index].id);
              _selectedIndex = index;
              setState(() {});
            },
            propertyList: propertyList,
          ),
          if (_selectedIndex != -1)
            Positioned(
              bottom: 30,
              child: SizedBox(
                height: SizeConfig.screenHeight * 0.25,
                width: SizeConfig.screenWidth * 0.98,
                child: Center(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _unitList.length,
                    itemBuilder: (context, j) {
                      Properties property = propertyList[_selectedIndex];
                      Units unit = _unitList[j];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PropertyDetails(
                                  property: propertyMap[unit
                                      .propertyId]!, // Ensure propertyMap is public
                                  unit: unit,
                                ),
                              ),
                            );
                          },
                          child: PropertyCard(
                            units: unit,
                            properties: property,
                            width: SizeConfig.screenWidth * 0.8,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

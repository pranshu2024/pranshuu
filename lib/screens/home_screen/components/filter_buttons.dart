import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:prophunter/models/property_type.dart';
import 'package:prophunter/models/status.dart';
import 'package:prophunter/provider/basicDataProvider.dart';
import 'package:prophunter/screens/property_list/property_list.dart';
import 'package:prophunter/services/queries.dart';
import 'package:prophunter/widgets/bottom_sheet.dart';
import 'package:prophunter/widgets/buttons.dart';
import 'package:prophunter/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

import '../../../constant.dart';
import '../../../models/units.dart';
import '../../../size_config.dart';
import '../../../widgets/text.dart';

// ignore: must_be_immutable
class FilterButton extends StatelessWidget {
  FilterButton(
      {super.key, required this.propertyTypeList, required this.statusList});
  List<PropertyType> propertyTypeList;
  List<Status> statusList;
  RangeValues currPrice = const RangeValues(0, 1000000);

  Widget circlebutton(press, String imageName, String text) {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RawMaterialButton(
            onPressed: press,
            elevation: 2.0,
            fillColor: Colors.black,
            shape: const CircleBorder(side: BorderSide(color: fadeWhite)),
            child: Image.asset(
              'assets/images/$imageName',
              width: getProportionateScreenWidth(60),
              color: kSecondaryColor,
            ),
          ),
          defaultSpace,
          Text(
            text,
            style: titleWhite15,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        circlebutton(() {
          rangeBottomSheet(true, context, 'Price ', () async {
            showLoaderDialog(context);
            List<Units> units = await CustomQuery().getPriceBetween(
                (currPrice.end).round(), currPrice.start.round());
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            pushNewScreen(context,
                screen: PropertyList(
                  unitList: units,
                ));
          });
        }, 'price.png', 'Price Range'),
        circlebutton(() async {
          await bottomSheet(context, propertyTypeList, "Property Type",
              (item) async {
            List<PropertyType> propertyTypeList =
                item.map<PropertyType>((e) => e).toList();
            showLoaderDialog(context);
            List<Units> units = await CustomQuery()
                .getByPropertyType(propertyTypeList, context);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            pushNewScreen(context,
                screen: PropertyList(
                  unitList: units,
                ));
          });
        }, 'property.png', 'Property Type'),
        circlebutton(() {
          rangeBottomSheet(false, context, 'Size', () async {
            showLoaderDialog(context);
            List<Units> units = await CustomQuery().getPropertySizeBetween(
                (currPrice.end).round(), currPrice.start.round());
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            pushNewScreen(context,
                screen: PropertyList(
                  unitList: units,
                ));
          });
        }, 'size.png', 'Property Size'),
        circlebutton(() {
          bottomSheet(context, statusList, "Status", (item) async {
            if (item.isNotEmpty) {
              showLoaderDialog(context);
              List<Status> selectedStatusList =
                  item.map<Status>((e) => e).toList();
              List<Units> units =
                  await CustomQuery().getPropertyStatus(selectedStatusList);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              // ignore: use_build_context_synchronously
              pushNewScreen(context,
                  screen: PropertyList(
                    unitList: units,
                  ));
            }
          });
        }, 'status.png', 'Property Status')
      ],
    );
  }

  rangeBottomSheet(isPrice, BuildContext context, String title, press) {
    BasicDataProvider provider =
        Provider.of<BasicDataProvider>(context, listen: false);
    currPrice = isPrice
        ? RangeValues(
            provider.priceMin.toDouble(), provider.priceMax.toDouble())
        : RangeValues(provider.sizeMin.toDouble(), provider.sizeMax.toDouble());
    showModalBottomSheet(
        context: context,
        elevation: 10,
        isScrollControlled: true,
        useRootNavigator: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        backgroundColor: const Color(0xff1B1B1B),
        // <-- SEE HERE
        builder: (context) {
          return StatefulBuilder(builder: (con, setState) {
            return Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  title,
                  style: headingWhite22,
                ),
                const SizedBox(
                  height: 50,
                ),
                RangeSlider(
                  values: currPrice,
                  max: isPrice
                      ? provider.priceMax.toDouble()
                      : provider.sizeMax.toDouble(),
                  divisions: isPrice
                      ? provider.priceMin.toInt()
                      : provider.sizeMin.toInt(),
                  labels: RangeLabels(
                    currPrice.start.round().toString(),
                    currPrice.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    currPrice = values;
                    setState(() {});
                  },
                  activeColor: fadeWhite,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Min $title', style: titleWhite20),
                      Text('Max $title', style: titleWhite20),
                    ],
                  ),
                ),
                defaultSpace3x,
                DefaultButton(
                    text: 'DONE',
                    press: () {
                      press();
                      Navigator.pop(context);
                    }),
                const SizedBox(
                  height: 200,
                )
              ],
            );
          });
        });
  }

  void pushNewScreen(BuildContext context, {required PropertyList screen}) {}
}

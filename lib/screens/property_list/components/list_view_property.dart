import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prophunter/models/bedrooms.dart';
import '../../../constant.dart';
import '../../../models/units.dart';
import '../../../size_config.dart';
import '../../../widgets/text.dart';
import '../../property_details/property_details.dart';

class ListViewProperty extends StatelessWidget {
  const ListViewProperty({super.key, required this.unitList});
  final List<Units> unitList;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showCheckboxColumn: false,
      dataRowMinHeight: 60, // Minimum height for data rows
      dataRowMaxHeight: 60, // Maximum height for data rows
      columns: [
        DataColumn(
          label: headingIcon('Property', 'property.svg'),
        ),
        DataColumn(
          label: headingIcon('Area(Sqft)', 'area.svg'),
        ),
        DataColumn(
          label: headingIcon('Bedrooms', 'bed.svg'),
        ),
        DataColumn(
          label: headingIcon('Price', 'price.svg'),
        ),
      ],
      columnSpacing: 15,
      rows: List.generate(
        unitList.length,
        (index) => DataRow(
          onSelectChanged: (val) {
            // Use MaterialPageRoute for navigation
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PropertyDetails(
                  property: propertyMap[unitList[index].propertyId]!,
                  unit: unitList[index],
                ),
              ),
            );
          },
          // Use MaterialStateProperty to set the row color
          cells: [
            DataCell(
              Text(
                unitList[index].name,
                style: titleWhite15,
              ),
            ),
            DataCell(
              Text(
                unitList[index].size.toString(),
                style: titleWhite15,
              ),
            ),
            DataCell(
              Text(
                bedRoomMap[unitList[index].bedrooms]!.name,
                style: titleWhite15,
              ),
            ),
            DataCell(
              Text(
                '${unitList[index].price} AED',
                style: titleWhite15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headingIcon(String text, String image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/icons/$image",
          width: getProportionateScreenWidth(20),
          // ignore: deprecated_member_use
          color: kSecondaryColor,
        ),
        Text(
          text,
          style: titleWhite15,
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart'; // Ensure this import is present
import 'package:prophunter/constant.dart';
import 'package:prophunter/models/units.dart';
import 'package:prophunter/screens/property_list/components/grid_view_property.dart';
import 'package:prophunter/screens/property_list/components/list_view_property.dart';
import 'package:prophunter/screens/search_screen/search_screen.dart';
import 'package:prophunter/widgets/search_bar.dart' as search;
import '../../../size_config.dart';
import '../../../widgets/alert_box.dart';
import '../../../widgets/text.dart';

class Body extends StatefulWidget {
  const Body({super.key, required this.unitList});
  final List<Units> unitList;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool viewGrid = true;
  String selectedSort = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          search.SearchBar(),
          _buildOptions(),
          defaultSpace3x,
          _buildPropertyList(),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _optionBox('Filter', CupertinoIcons.text_alignleft, () {
          pushNewScreen(context, screen: const SearchScreen());
        }),
        _optionBox('Sorting', CupertinoIcons.sort_up, () {
          _showSortDialog();
        }),
        _optionBox(
          'View',
          viewGrid
              ? CupertinoIcons.list_bullet
              : CupertinoIcons.rectangle_grid_2x2,
          () {
            setState(() {
              viewGrid = !viewGrid;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPropertyList() {
    return Expanded(
      child: SingleChildScrollView(
        child: viewGrid
            ? GridViewProperty(unitList: widget.unitList)
            : ListViewProperty(unitList: widget.unitList),
      ),
    );
  }

  Widget _optionBox(String text, IconData icon, VoidCallback press) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
          side: const BorderSide(color: fadeWhite, width: 0.5)),
      onPressed: press,
      icon: Icon(
        icon,
        color: kSecondaryColor,
        size: getProportionateScreenWidth(18),
      ),
      label: Text(
        text,
        style: titleWhite18,
      ),
    );
  }

  void _showSortDialog() {
    showAlertDialog(
      context: context,
      title: 'Sort',
      child: _sortBox(),
      press: _applySorting,
    );
  }

  void _applySorting() {
    if (selectedSort == "PRICELOW") {
      widget.unitList.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSort == "PRICEHIGH") {
      widget.unitList.sort((a, b) => b.price.compareTo(a.price));
    } else if (selectedSort == "SIZELOW") {
      widget.unitList.sort((a, b) => a.size.compareTo(b.size));
    } else if (selectedSort == "SIZEHIGH") {
      widget.unitList.sort((a, b) => b.size.compareTo(a.size));
    } else if (selectedSort == "BEDROOM") {
      widget.unitList.sort((a, b) => a.bedrooms.compareTo(b.bedrooms));
    }
    setState(() {});
  }

  Widget _sortBox() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            _buildCheckbox("Price (Low to High)", 'PRICELOW', setState),
            _buildCheckbox("Price (High to Low)", 'PRICEHIGH', setState),
            _buildCheckbox("Size (Low to High)", 'SIZELOW', setState),
            _buildCheckbox("Size (High to Low)", 'SIZEHIGH', setState),
            _buildCheckbox("Bedroom", 'BEDROOM', setState),
          ],
        );
      },
    );
  }

  Widget _buildCheckbox(String title, String value, StateSetter setState) {
    return CheckboxListTile(
      shape: const Border(top: BorderSide(color: fadeWhite, width: 0.5)),
      title: Text(title, style: titleWhite18),
      value: selectedSort == value,
      checkboxShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      activeColor: Colors.blue,
      onChanged: (newValue) {
        setState(() {
          selectedSort = newValue! ? value : "";
        });
      },
    );
  }

  // Define the pushNewScreen method here
  void pushNewScreen(BuildContext context, {required Widget screen}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

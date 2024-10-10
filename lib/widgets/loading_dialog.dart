import 'package:flutter/material.dart';
import 'package:prophunter/custom_animation.dart';

showLoaderDialog(BuildContext context) {
  showDialog(
    useRootNavigator: false,
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async => false,
        child: const CustomAnimation(),
      );
    },
  );
}

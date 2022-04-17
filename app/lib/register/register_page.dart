import 'package:app/utils/custom_widgets.dart';
import 'package:flutter/material.dart';

abstract class RegisterPage {
  void register();
  Future<void> getDevicePosition();

  Future<void> backButtonPressed(
      BuildContext context, VoidCallback? onWillPop) async {
    await cancelRegistrationDialog(context).then((value) => {
          if (value)
            {
              if (onWillPop != null) {onWillPop()},
              Navigator.pop(context)
            }
        });
  }

  Future<bool> onWillPop(BuildContext context, VoidCallback? onWillPop) async {
    bool returnValue = false;
    await cancelRegistrationDialog(context)
        .then((value) => {returnValue = value});
    if (returnValue && onWillPop != null) {
      onWillPop();
    }
    return returnValue;
  }
}

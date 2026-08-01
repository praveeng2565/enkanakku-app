import 'package:flutter/material.dart';

import '../theme/color.dart';
import 'custom_button.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  String title = 'Alert',
  required String subtitle,
  String filledBtnText = 'Continue',
  String outlineBtnText = 'Cancel',
  bool showOutlineBtn = true,
  VoidCallback? onOkPressed,
  VoidCallback? onCancelPressed,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {},
        child: Dialog(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Material(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Palette.primaryColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        inputText: filledBtnText,
                        onTap: onOkPressed,
                      ),
                      if (showOutlineBtn)
                        CustomButton(
                          inputText: outlineBtnText,
                          isFilled: false,
                          onTap: () {
                            Navigator.pop(context);
                            onCancelPressed?.call();
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

import 'package:flutter/material.dart';

import '../theme/color.dart';

Future<void> showAlertDialogv2({
  required BuildContext context,
  required String title,
  required String body,
  String filledBtnText = 'Continue',
  String outlineBtnText = 'Cancel',
  bool cancelBtnReq = true,
  bool okBtnReq = true,
  Function()? onOkPressed,
  Function()? onCancelPressed,
  Color iconColor = Colors.green,
}) async {
  final Widget filledButton = InkWell(
    onTap: onOkPressed,
    child: Container(
      decoration: BoxDecoration(
        color: Palette.greenPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          filledBtnText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );

  final Widget outlineButton = InkWell(
    onTap: onCancelPressed,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Palette.greenPrimary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          outlineBtnText,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ),
  );

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {},
        child: Dialog(
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
                          Icon(Icons.info_outline, color: iconColor),
                          const SizedBox(width: 5),
                          Text(
                            title,
                            style: const TextStyle(
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
                      body,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (okBtnReq) filledButton,
                      if (cancelBtnReq) outlineButton,
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

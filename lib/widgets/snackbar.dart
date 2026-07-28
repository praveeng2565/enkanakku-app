import 'package:flutter/material.dart';

class MessageSnack {
  void showInfoMessage(message, scaffoldKey, [void Function()? onClose]) {
    _showMessage(message, false, scaffoldKey, onClose);
  }

  void showErrorMessage(error, scaffoldKey, [void Function()? onClose]) {
    _showMessage(error.message, true, scaffoldKey, onClose);
  }

  void _showMessage(
    message,
    isError,
    scaffoldKey, [
    void Function()? onClose,
  ]) {
    // if one is open, close it
    scaffoldKey.currentState.hideCurrentSnackBar(
      reason: SnackBarClosedReason.action,
    );

    final SnackBar snackBar = SnackBar(
      key: const Key('error_Snackbar'),
      content: Text(message, key: const Key('error_message')),
      duration: const Duration(seconds: 5),
      backgroundColor: isError ? Colors.redAccent : Colors.grey,
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change!
          scaffoldKey.currentState.hideCurrentSnackBar(
            reason: SnackBarClosedReason.action,
          );
        },
      ),
    );

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    scaffoldKey.currentState.showSnackBar(snackBar).closed.then((reason) {
      // snackbar is now closed, close window
      if (onClose != null) onClose();
    });
  }
}

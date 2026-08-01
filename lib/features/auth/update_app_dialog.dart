import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/update_service.dart';
import 'user_view_model.dart';

Future<void> showUpdateDialog(BuildContext context, UpdateInfo info) async {
  final updateService = UpdateService();

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {},
      child: _UpdateDialogContent(info: info, updateService: updateService),
    ),
  );
}

class _UpdateDialogContent extends StatefulWidget {
  const _UpdateDialogContent({required this.info, required this.updateService});
  final UpdateInfo info;
  final UpdateService updateService;

  @override
  State<_UpdateDialogContent> createState() => _UpdateDialogContentState();
}

class _UpdateDialogContentState extends State<_UpdateDialogContent> {
  bool _downloading = false;
  DownloadProgress _progress = DownloadProgress();
  late UserViewModel userViewModel;

  Future<void> _startUpdate() async {
    userViewModel.appVersionErrorMsg = '';
    setState(() => _downloading = true);
    try {
      await widget.updateService.downloadApk(
        widget.info.apkUrl,
        onProgress: (DownloadProgress progress) {
          setState(() => _progress = progress);
        },
        onCompleted: (String path) async {
          userViewModel.appVersionValidated = true;
          await widget.updateService.installApk(path);
          if (mounted) {
            Navigator.pop(context);
          }
        },
        onCancelled: () {
          if (widget.info.mandatory) {
            Provider.of<UserViewModel>(context, listen: false)
              ..appVersionErrorMsg = 'Downloading Cancelled'
              ..appVersionValidated = false;
            setState(() => _downloading = false);
          } else if (mounted) {
            userViewModel.appVersionValidated = true;
            Navigator.pop(context);
          }
        },
        onError: (String message) {
          if (widget.info.mandatory) {
            userViewModel
              ..appVersionErrorMsg = message
              ..appVersionValidated = false;
            setState(() => _downloading = false);
          } else if (mounted) {
            userViewModel.appVersionValidated = true;
            Navigator.pop(context);
          }
        },
      );
    } catch (e) {
      if (widget.info.mandatory) {
        userViewModel
          ..appVersionErrorMsg = 'Update failed. Please try again.'
          ..appVersionValidated = false;
        setState(() => _downloading = false);
      } else if (mounted) {
        userViewModel.appVersionValidated = true;
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          const Icon(
            Icons.system_update_alt_rounded,
            color: Colors.blue,
            size: 30,
          ),
          const SizedBox(width: 10),
          Text(_downloading ? 'Downloading Update' : 'Update Available'),
        ],
      ),
      content: _downloading
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.downloading, size: 55, color: Colors.blue),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: _progress.progress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 15),
                Text(
                  '${(_progress.progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                if (_progress.isTotalKnown)
                  Text(
                    '${_progress.downloadedMB} MB / ${_progress.totalMB} MB',
                  ),
                if (!_progress.isTotalKnown)
                  Text('${_progress.receivedBytes} MB '),
                const SizedBox(height: 5),
                Text('Speed : ${_progress.speedMBps} MB/s'),
                Text('Remaining Time : ${_progress.remainingSeconds} sec'),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Version ${widget.info.latestVersion} is ready to install.',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Current'),
                    Text(widget.info.currentVersion),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Latest'),
                    Text(widget.info.latestVersion),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "What's New",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('• Bug fixes'),
                const Text('• New Enhancements'),
                if (userViewModel.appVersionErrorMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      '** Oops! ${userViewModel.appVersionErrorMsg}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
      actionsAlignment: _downloading ? MainAxisAlignment.center : null,
      actions: _downloading
          ? [
              TextButton(
                onPressed: () {
                  widget.updateService.cancel();
                },
                child: const Text('Cancel'),
              ),
            ]
          : [
              if (!widget.info.mandatory)
                TextButton(
                  onPressed: () {
                    userViewModel.appVersionValidated = true;
                    Navigator.pop(context);
                  },
                  child: const Text('Later'),
                ),
              FilledButton.icon(
                onPressed: _startUpdate,
                icon: const Icon(Icons.download),
                label: const Text('Download'),
              ),
            ],
    );
  }
}

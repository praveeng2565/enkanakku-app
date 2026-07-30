import 'dart:async';

import 'package:android_package_installer/android_package_installer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class UpdateInfo {
  UpdateInfo({
    required this.latestVersion,
    required this.currentVersion,
    required this.apkUrl,
    required this.mandatory,
  });
  final String latestVersion;
  final String currentVersion;
  final String apkUrl;
  final bool mandatory;
}

class UpdateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(minutes: 10),
      sendTimeout: const Duration(seconds: 20),
      followRedirects: true,
      maxRedirects: 5,
    ),
  );
  CancelToken? _cancelToken;

  /// Compares the installed app version against `app_config/version`.
  /// Returns null if the app is already up to date.
  Future<UpdateInfo?> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version; // e.g. "1.2.0"

    final doc = await _firestore.collection('app_config').doc('version').get();
    if (!doc.exists) {
      return null;
    }

    final data = doc.data()!;
    final latestVersion = data['latestVersion'] as String;

    if (_isNewer(latestVersion, currentVersion)) {
      return UpdateInfo(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        apkUrl: data['apkUrl'] as String,
        mandatory: data['mandatory'] as bool? ?? false,
      );
    }
    return null;
  }

  /// Simple semantic version comparison: "1.3.0" > "1.2.9" etc.
  bool _isNewer(String remote, String current) {
    final r = remote.split('.').map(int.parse).toList();
    final c = current.split('.').map(int.parse).toList();
    for (var i = 0; i < r.length; i++) {
      final cVal = i < c.length ? c[i] : 0;
      if (r[i] > cVal) {
        return true;
      }
      if (r[i] < cVal) {
        return false;
      }
    }
    return false;
  }

  void cancel() {
    _cancelToken?.cancel();
  }

  /// Downloads the APK to app-external storage, reporting progress via
  /// [onProgress] (0.0 - 1.0), then returns the local file path.
  Future<void> downloadApk(
    String url, {
    required void Function(DownloadProgress progress) onProgress,
    required void Function(String path) onCompleted,
    required void Function(String message) onError,
    void Function()? onCancelled,
  }) async {
    _cancelToken = CancelToken();

    final stopwatch = Stopwatch()..start();

    int lastBytes = 0;
    DateTime lastTick = DateTime.now();

    double currentSpeed = 0;
    final dir = await getTemporaryDirectory();
    final savePath = '${dir.path}/kanakku_update.apk';

    try {
      await _dio.download(
        url,
        savePath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          final now = DateTime.now();

          final diffMs = now.difference(lastTick).inMilliseconds;

          // Update speed every second
          if (diffMs >= 1000) {
            final bytesSinceLast = received - lastBytes;

            currentSpeed = bytesSinceLast / (diffMs / 1000);

            lastBytes = received;
            lastTick = now;
          }

          final totalKnown = total > 0;

          final progress = totalKnown ? received / total : 0.0;

          final downloadedMB = received / 1024 / 1024;

          final totalMB = totalKnown ? total / 1024 / 1024 : 0.0;

          int remaining = 0;

          if (totalKnown && currentSpeed > 0 && received < total) {
            remaining = ((total - received) / currentSpeed).ceil();
          }

          onProgress(
            DownloadProgress(
              receivedBytes: received.toStringAsFixed(2),
              totalBytes: total.toString(),
              progress: progress,
              downloadedMB: downloadedMB.toStringAsFixed(2),
              totalMB: totalMB.toStringAsFixed(2),
              speedMBps: (currentSpeed / 1024 / 1024).toStringAsFixed(1),
              remainingSeconds: remaining.toStringAsFixed(0),
              isTotalKnown: totalKnown,
              isCompleted: totalKnown && received == total,
            ),
          );
        },
      );

      stopwatch.stop();

      if (_cancelToken?.isCancelled == true) {
        onCancelled?.call();
        return;
      }

      return onCompleted(savePath);
    } on DioException catch (e) {
      stopwatch.stop();
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return onError('Connection timeout.');

        case DioExceptionType.receiveTimeout:
          return onError('Download timeout.');

        case DioExceptionType.sendTimeout:
          return onError('Send timeout.');

        case DioExceptionType.badResponse:
          return onError('Server error (${e.response?.statusCode}).');

        case DioExceptionType.connectionError:
          return onError('No internet connection.');

        case DioExceptionType.cancel:
          return onCancelled?.call();
        case DioExceptionType.unknown:
        case DioExceptionType.badCertificate:
        case DioExceptionType.transformTimeout:
          return onError(e.error?.toString() ?? 'Unknown error.');
      }
    } catch (e) {
      stopwatch.stop();
      return onError(e.toString());
    }
  }

  /// Triggers the Android install intent for the downloaded APK.
  Future<void> installApk(String apkFilePath) async {
    await AndroidPackageInstaller.installApk(apkFilePath: apkFilePath);
  }
}

class DownloadProgress {
  DownloadProgress({
    this.receivedBytes = '0',
    this.totalBytes = '0',
    this.progress = 0,
    this.downloadedMB = '0',
    this.totalMB = '0',
    this.speedMBps = '0',
    this.remainingSeconds = '0',
    this.isTotalKnown = false,
    this.isCompleted = false,
  });
  final String receivedBytes;
  final String totalBytes;

  final double progress; // 0 - 1 (0 if unknown)
  final String downloadedMB;
  final String totalMB;

  final String speedMBps;
  final String remainingSeconds;

  final bool isTotalKnown;
  final bool isCompleted;
}

class AppConfigModel {
  const AppConfigModel({
    required this.latestVersion,
    this.buildNumber = 0,
    required this.apkUrl,
    this.mandatory = false,
    required this.loginVersion,
    this.releasedAt,
  });
  factory AppConfigModel.fromMap(Map<String, dynamic> m) => AppConfigModel(
    latestVersion: m['latestVersion'] as String,
    buildNumber: (m['buildNumber'] as num).toInt(),
    apkUrl: m['apkUrl'] as String,
    mandatory: m['mandatory'] as bool,
    loginVersion: m['loginVersion'] as String?,
    releasedAt: DateTime.parse(m['releasedAt']),
  );
  factory AppConfigModel.fromJson(Map<String, dynamic> j) =>
      AppConfigModel.fromMap(j);
  final String latestVersion;
  final int buildNumber;
  final String apkUrl;
  final bool mandatory;
  final String? loginVersion;
  final DateTime? releasedAt;
}

import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:absen_online/utils/utils.dart';

class AnalyticsHelper {
  static Future<void> setCurrentScreen(String screenName,
      {String screenClassOverride}) async {
    final FirebaseAnalytics analytics = FirebaseAnalytics();
    await analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClassOverride != null
          ? screenClassOverride
          : '${screenName.replaceAll(RegExp("\\s+"), "")}Screen',
    );
  }

  static Future<void> setLogEvent(String eventName,
      [Map<String, dynamic> source]) async {
    final FirebaseAnalytics analytics = FirebaseAnalytics();

    // UtilLogger.log('LOG EVENT', eventName);
    await analytics.logEvent(
      name: eventName,
      parameters: source,
    );
  }
}

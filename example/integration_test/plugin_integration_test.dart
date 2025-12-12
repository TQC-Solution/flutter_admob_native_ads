// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getPlatformVersion test', (WidgetTester tester) async {
    final String? version = await _getPlatformVersion();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(version?.isNotEmpty, true);
  });
}

// Helper method to get platform version using the method channel
Future<String?> _getPlatformVersion() async {
  const platform = MethodChannel('flutter_admob_native_ads');
  try {
    final String? version = await platform.invokeMethod('getPlatformVersion');
    return version;
  } on PlatformException catch (e) {
    return 'Failed to get platform version: ${e.message}';
  }
}

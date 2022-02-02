import 'package:app/map/map_widget.dart';
import 'package:flutter_map/plugin_api.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('Widget tests', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Initial layout and content', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Material(child: Map())));

      expect(find.byType(FlutterMap), findsOneWidget);
    });
  });
}

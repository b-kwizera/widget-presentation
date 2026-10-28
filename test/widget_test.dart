import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_presentation/main.dart';

void main() {
  testWidgets('shows an InteractiveViewer and toggles panEnabled',
      (tester) async {
    await tester.pumpWidget(const MapViewerApp());

    InteractiveViewer viewer() =>
        tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));

    expect(viewer().panEnabled, isTrue);
    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    expect(viewer().panEnabled, isFalse);
  });
}

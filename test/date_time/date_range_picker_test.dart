import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('renders FastDateRangerPicker', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastDateRangePicker(
        id: 'date_range_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now()..add(Duration(days: 365)),
      ),
    ));

    final fastDateRangePickerFinder = find.byType(FastDateRangePicker);
    final gestureDetectorFinder = find.byType(GestureDetector);
    final iconButtonFinder = find.byType(IconButton);

    expect(fastDateRangePickerFinder, findsOneWidget);
    expect(gestureDetectorFinder.first, findsOneWidget);
    expect(iconButtonFinder, findsOneWidget);
  });

  testWidgets('updates FastDateRangerPicker', (WidgetTester tester) async {
    await tester.pumpWidget(getFastTestWidget(
      FastDateRangePicker(
        id: 'date_range_picker',
        firstDate: DateTime(1900),
        lastDate: DateTime.now()..add(Duration(days: 365)),
      ),
    ));

    final state = tester.state(find.byType(FastDateRangePicker))
        as FastDateRangePickerState;

    expect(state.value, state.widget.initialValue);

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();

    final dateRangePickerText = dateRangPickerTextBuilder(
        state.context, state.value, state.widget.dateFormat);
    final dateRangePickerTextFinder = find.text(dateRangePickerText.data);

    expect(dateRangePickerTextFinder, findsOneWidget);
  });
}
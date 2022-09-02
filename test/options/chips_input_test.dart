import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late List<String> options;

  setUp(() {
    options = const ['Alabama', 'Montana', 'Nebraska', 'Wyoming'];
  });

  testWidgets('renders FastChipsInput as Wrap', (WidgetTester tester) async {
    const helperText = 'helper';
    const labelText = 'label';

    await tester.pumpWidget(buildMaterialTestApp(
      const FastChipsInput(
        name: 'input_chips',
        helperText: helperText,
        labelText: labelText,
      ),
    ));

    expect(find.byType(FastChipsInput), findsOneWidget);
    expect(find.byType(Wrap), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);

    expect(find.text(helperText), findsOneWidget);
    expect(find.text(labelText), findsOneWidget);
  });

  testWidgets('renders FastChipsInput as ListView',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      const FastChipsInput(name: 'input_chips', wrap: false),
    ));

    expect(find.byType(FastChipsInput), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
  });

  testWidgets('shows InputChip', (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastChipsInput(name: 'input_chips', options: options),
    ));

    const text = 'Test';

    await tester.enterText(find.byType(TextFormField), text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.byType(InputChip), findsOneWidget);
  });

  testWidgets('updates FastChipsInput by text input',
      (WidgetTester tester) async {
    final spy = OnChangedSpy<List<String>>();

    await tester.pumpWidget(buildMaterialTestApp(
      FastChipsInput(name: 'input_chips', options: options, onChanged: spy.fn),
    ));

    final state =
        tester.state(find.byType(FastChipsInput)) as FastChipsInputState;

    expect(state.value, state.widget.initialValue);

    const text = 'Test';

    await tester.enterText(find.byType(TextFormField), text);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final testValue = {text};

    expect(spy.calledWith, testValue);
    expect(state.value, testValue);
  });

  testWidgets('updates FastChipsInput by selecting option',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildMaterialTestApp(
      FastChipsInput(name: 'input_chips', options: options),
    ));

    final state =
        tester.state(find.byType(FastChipsInput)) as FastChipsInputState;
    final text = options.last;

    await tester.enterText(find.byType(TextFormField), text);
    await tester.pumpAndSettle();

    final optionFinder = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(InkWell),
    );

    expect(optionFinder, findsOneWidget);

    await tester.tap(optionFinder);
    await tester.pumpAndSettle();

    expect(state.value, {text});
  });
}
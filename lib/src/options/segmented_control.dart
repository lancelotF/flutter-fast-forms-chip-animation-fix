import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form_field.dart';

@immutable
class FastSegmentedControl<T> extends FastFormField<T> {
  FastSegmentedControl({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<T>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    T? initialValue,
    Key? key,
    String? label,
    required String name,
    ValueChanged<T>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    this.backgroundColor = CupertinoColors.tertiarySystemFill,
    required this.children,
    this.errorBuilder,
    this.helperBuilder,
    this.padding = const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
    this.thumbColor,
  })  : assert(children.length >= 2),
        super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? cupertinoSegmentedControlBuilder,
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue ?? children.keys.first,
          key: key,
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final Color backgroundColor;
  final Map<T, Widget> children;
  final FastErrorBuilder<T>? errorBuilder;
  final FastHelperBuilder<T>? helperBuilder;
  final EdgeInsetsGeometry padding;
  final Color? thumbColor;

  @override
  FastSegmentedControlState<T> createState() => FastSegmentedControlState<T>();
}

class FastSegmentedControlState<T> extends FastFormFieldState<T> {
  @override
  FastSegmentedControl<T> get widget => super.widget as FastSegmentedControl<T>;
}

CupertinoFormRow cupertinoSegmentedControlBuilder<T>(FormFieldState<T> field) {
  final state = field as FastSegmentedControlState<T>;
  final widget = state.widget;

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.label is String ? Text(widget.label!) : null,
    helper: (widget.helperBuilder ?? helperBuilder)(state),
    error: (widget.errorBuilder ?? errorBuilder)(state),
    child: CupertinoSlidingSegmentedControl<T>(
      backgroundColor: widget.backgroundColor,
      children: widget.children,
      groupValue: state.value,
      onValueChanged: state.didChange,
      padding: widget.padding,
      thumbColor: widget.thumbColor ??
          const CupertinoDynamicColor.withBrightness(
            color: Color(0xFFFFFFFF),
            darkColor: Color(0xFF636366),
          ),
    ),
  );
}
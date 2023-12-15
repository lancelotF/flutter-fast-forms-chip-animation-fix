import 'package:flutter/material.dart';

import '../form.dart';

typedef FastAutocompleteFieldViewBuilder<O extends Object>
    = AutocompleteFieldViewBuilder Function(FastAutocompleteState<O> field);

typedef FastAutocompleteWillDisplayOption<O extends Object> = bool Function(
    TextEditingValue textEditingValue, O option);

/// A [FastFormField] that contains an [Autocomplete].
@immutable
class FastAutocomplete<O extends Object> extends FastFormField<String> {
  FastAutocomplete({
    FormFieldBuilder<String>? builder,
    FastAutocompleteFieldViewBuilder? fieldViewBuilder,
    TextEditingValue? initialValue,
    FastAutocompleteWillDisplayOption? willDisplayOption,
    super.autovalidateMode,
    super.contentPadding,
    super.decoration,
    super.enabled,
    super.helperText,
    super.key,
    super.labelText,
    required super.name,
    super.onChanged,
    super.onReset,
    super.onSaved,
    super.restorationId,
    super.validator,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.onSelected,
    this.options,
    this.optionsBuilder,
    this.optionsMaxHeight = 200.00,
    this.optionsViewBuilder,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
  })  : assert(options != null || optionsBuilder != null),
        _initialValue = initialValue,
        fieldViewBuilder = fieldViewBuilder ?? _fieldViewBuilder,
        willDisplayOption = willDisplayOption ?? _willDisplayOption,
        super(
          builder: builder ?? autocompleteBuilder,
          initialValue: initialValue?.text ?? '',
        );

  final TextEditingValue? _initialValue;
  final AutocompleteOptionToString<O> displayStringForOption;
  final FastAutocompleteFieldViewBuilder<O> fieldViewBuilder;
  final AutocompleteOnSelected<O>? onSelected;
  final Iterable<O>? options;
  final AutocompleteOptionsBuilder<O>? optionsBuilder;
  final double optionsMaxHeight;
  final AutocompleteOptionsViewBuilder<O>? optionsViewBuilder;
  final OptionsViewOpenDirection optionsViewOpenDirection;
  final FastAutocompleteWillDisplayOption<O> willDisplayOption;

  @override
  FastAutocompleteState<O> createState() => FastAutocompleteState<O>();
}

/// State associated with a [FastAutocomplete] widget.
class FastAutocompleteState<O extends Object>
    extends FastFormFieldState<String> {
  @override
  FastAutocomplete<O> get widget => super.widget as FastAutocomplete<O>;
}

/// A [FastAutocompleteWillDisplayOption] that is the default
/// [FastAutocomplete.willDisplayOption].
bool _willDisplayOption<O extends Object>(TextEditingValue value, O option) {
  return option.toString().toLowerCase().contains(value.text.toLowerCase());
}

/// Returns an [AutocompleteOptionsBuilder] that is the default
/// [Autocomplete.optionsBuilder].
AutocompleteOptionsBuilder<O> _optionsBuilder<O extends Object>(
    Iterable<O> options, FastAutocompleteState<O> field) {
  return (TextEditingValue value) {
    final FastAutocompleteState<O>(:widget) = field;
    if (value.text.isEmpty) {
      return const Iterable.empty();
    }
    return options.where((O option) => widget.willDisplayOption(value, option));
  };
}

/// A [FastAutocompleteFieldViewBuilder] that is the default
/// [FastAutocomplete.fieldViewBuilder].
AutocompleteFieldViewBuilder _fieldViewBuilder<O extends Object>(
    FastAutocompleteState<O> field) {
  return (BuildContext context, TextEditingController textEditingController,
      FocusNode focusNode, VoidCallback onFieldSubmitted) {
    final FastAutocompleteState<O>(:decoration, :didChange, :widget) = field;

    return TextFormField(
      controller: textEditingController,
      decoration: decoration,
      enabled: widget.enabled,
      focusNode: focusNode,
      onChanged: widget.enabled ? didChange : null,
      onFieldSubmitted: (value) => onFieldSubmitted(),
      validator: widget.validator,
    );
  };
}

/// A [FormFieldBuilder] that is the default [FastAutocomplete.builder].
///
/// Returns an [Autocomplete] on any [TargetPlatform].
Widget autocompleteBuilder<O extends Object>(FormFieldState<String> field) {
  final FastAutocompleteState<O>(:widget) = field as FastAutocompleteState<O>;

  return Autocomplete(
    displayStringForOption: widget.displayStringForOption,
    fieldViewBuilder: widget.fieldViewBuilder(field),
    initialValue: widget._initialValue,
    onSelected: widget.onSelected,
    optionsBuilder:
        widget.optionsBuilder ?? _optionsBuilder(widget.options!, field),
    optionsMaxHeight: widget.optionsMaxHeight,
    optionsViewBuilder: widget.optionsViewBuilder,
    optionsViewOpenDirection: widget.optionsViewOpenDirection,
  );
}

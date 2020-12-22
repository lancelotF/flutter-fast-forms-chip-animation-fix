import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'form_store.dart';

@immutable
abstract class FastFormField<T> extends FormField<T> {
  const FastFormField({
    this.autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    @required FormFieldBuilder<T> builder,
    bool enabled = true,
    this.helper,
    @required this.id,
    T initialValue,
    Key key,
    this.label,
    this.onChanged,
    this.onReset,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
  }) : super(
          autovalidateMode: autovalidateMode,
          builder: builder,
          enabled: enabled,
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
        );

  final bool autofocus;
  final String helper;
  final String id;
  final String label;
  final ValueChanged<T> onChanged;
  final VoidCallback onReset;
}

class FastFormFieldState<T> extends FormFieldState<T> {
  bool focused = false;
  bool touched = false;

  FocusNode focusNode;
  FastFormStore store;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode()..addListener(_onFocusChanged);
    store = Provider.of<FastFormStore>(context, listen: false);
    setValue(widget.initialValue);
  }

  @override
  void deactivate() {
    super.deactivate();
    store.unregister(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  @override
  FastFormField<T> get widget => super.widget as FastFormField<T>;

  @override
  Widget build(BuildContext context) {
    store.register(this);
    return super.build(context);
  }

  @override
  void didChange(T value) {
    super.didChange(value);
    onChanged(value);
  }

  @override
  void reset() {
    super.reset();
    onReset();
  }

  void onChanged(T value) {
    if (!touched) setState(() => touched = true);
    setValue(value);
    store.update(this);
  }

  void onReset() {
    setState(() {
      focused = false;
      touched = false;
      setValue(widget.initialValue);
      store.update(this);
    });
  }

  void onSaved(T value) {
    setValue(value);
    store.update(this);
  }

  void _onFocusChanged() {
    setState(() {
      if (focusNode.hasFocus) {
        focused = true;
      } else {
        focused = false;
        touched = true;
        print(touched);
      }
    });
  }
}

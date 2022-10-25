import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    super.key,
    Widget? title,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    void Function(bool? value)? onChange,
    bool initialValue = false,
    bool? value,
    super.autovalidateMode = AutovalidateMode.disabled,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return CheckboxListTile(
                dense: state.hasError,
                title: title,
                value: value ?? state.value,
                onChanged: (value) => onChange != null
                    ? onChange.call(value)
                    : state.didChange(value),
                subtitle: state.hasError
                    ? Builder(
                        builder: (BuildContext context) => Text(
                          state.errorText ?? "",
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ),
                      )
                    : null,
                controlAffinity: ListTileControlAffinity.leading,
              );
            });
}

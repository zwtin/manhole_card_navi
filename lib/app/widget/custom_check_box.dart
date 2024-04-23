import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    this.value,
    this.onChanged,
    super.key,
  });

  final bool? value;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).iconTheme.color ?? Colors.grey,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        Checkbox(
          checkColor: Theme.of(context).iconTheme.color ?? Colors.grey,
          fillColor: MaterialStateProperty.resolveWith(
            (states) {
              return Colors.transparent;
            },
          ),
          value: value,
          onChanged: (newValue) {
            if (onChanged != null) {
              onChanged!(newValue);
            }
          },
        ),
      ],
    );
  }
}

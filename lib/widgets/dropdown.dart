import 'package:flutter/material.dart';
import '../Utils/Appcolor.dart';

class DropdownWidget<T> extends StatefulWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool isDisabled;
  final bool readOnly;
  final Widget? suffix;
  final Color? color;
  final BoxBorder? boxBorder;

  const DropdownWidget({
    super.key,
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.nextFocusNode,
    this.isDisabled = false,
    this.readOnly = false,
    this.suffix,
    this.color,
    this.boxBorder,
  });

  @override
  State<DropdownWidget<T>> createState() => _DropdownWidgetState<T>();
}

class _DropdownWidgetState<T> extends State<DropdownWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (fieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.color ?? AppColors.white,
                border:
                    widget.boxBorder ??
                    Border.all(
                      color: fieldState.hasError
                          ? Colors.red
                          : (widget.color != null
                                ? AppColors.grey
                                : AppColors.themecolor),
                      width: 1,
                    ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  focusNode: widget.focusNode,
                  value: widget.value,
                  hint: Text(
                    widget.hint,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  icon:
                      widget.suffix ??
                      Icon(Icons.arrow_drop_down, color: AppColors.themecolor),
                  isExpanded: true,
                  items: widget.items,
                  onChanged: widget.isDisabled || widget.readOnly
                      ? null
                      : (value) {
                          if (widget.onChanged != null) {
                            widget.onChanged!(value);
                          }
                          fieldState.didChange(value);
                          if (widget.nextFocusNode != null) {
                            FocusScope.of(
                              context,
                            ).requestFocus(widget.nextFocusNode);
                          }
                        },
                  dropdownColor: AppColors.white,
                ),
              ),
            ),
            if (fieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                child: Text(
                  fieldState.errorText ?? '',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}

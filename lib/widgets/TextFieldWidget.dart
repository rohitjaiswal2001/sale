import 'package:bid4style/utils/Appcolor.dart';
import 'package:flutter/material.dart';

class TexfieldWidget extends StatefulWidget {
  final String hint;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? isDisable;
  final double? allPadding;
  final double? allMargin;
  final bool? readonly;
  final Widget? suffix;
  final TextStyle? hintstyle;
  final Color? color;
  final Widget? prefixWidget;
  final int? maxLine;
  final BoxBorder? boxborder;
  final TextInputAction textInputAction;

  TexfieldWidget({
    super.key,
    required this.hint,
    required this.controller,
    this.boxborder,
    this.allMargin,
    this.hintstyle,
    this.allPadding,
    this.prefixWidget,
    this.isDisable,
    this.obscureText = false,
    this.focusNode,
    this.nextFocusNode,
    this.validator,
    this.keyboardType,
    this.color,
    this.maxLine,
    this.suffix,
    this.readonly = false,
    this.textInputAction = TextInputAction.done,
  });

  @override
  State<TexfieldWidget> createState() => _TexfieldWidgetState();
}

class _TexfieldWidgetState extends State<TexfieldWidget> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; // sync with initial state
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField<String>(
          validator: widget.validator,
          builder: (fieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(widget.allMargin ?? 0),
                  padding: EdgeInsets.all(widget.allPadding ?? 0),
                  decoration: BoxDecoration(
                    color: widget.color ?? AppColors.white,
                    border:
                        widget.boxborder ??
                        Border.all(
                          color: widget.color != null
                              ? AppColors.grey
                              : AppColors.themecolor,
                          width: 1,
                        ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    readOnly: widget.readonly ?? false,

                    focusNode: widget.focusNode,
                    obscureText: widget.obscureText && _obscureText,
                    controller: widget.controller,
                    enabled: widget.isDisable ?? true,
                    maxLines: widget.maxLine ?? 1,
                    decoration: InputDecoration(
                      prefixIcon: widget.prefixWidget,

                      suffixIcon: widget.obscureText
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.themecolor,
                              ),
                            )
                          : widget.suffix,
                      contentPadding: const EdgeInsets.all(15),
                      border: InputBorder.none,
                      hintText: widget.hint,
                      hintStyle:
                          widget.hintstyle ??
                          TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w400,
                          ),
                      errorStyle: const TextStyle(height: 0),
                    ),
                    onChanged: (value) {
                      fieldState.didChange(value);
                    },
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    textInputAction: widget.nextFocusNode != null
                        ? TextInputAction.next
                        : widget.textInputAction,
                    keyboardType: widget.keyboardType,
                    onFieldSubmitted: (value) {
                      if (widget.nextFocusNode != null) {
                        FocusScope.of(
                          context,
                        ).requestFocus(widget.nextFocusNode);
                      } else {
                        FocusScope.of(context).unfocus();
                      }
                    },
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
        ),
      ],
    );
  }
}

class TextFeldWidgetEdit extends StatefulWidget {
  final String hint;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? isDisable;
  final bool? readonly;
  final Widget? suffix;
  final Color? color;
  final int? maxLine;
  final BoxBorder? boxborder;
  final TextInputAction textInputAction;

  const TextFeldWidgetEdit({
    super.key,
    required this.hint,
    required this.controller,
    this.boxborder,
    this.isDisable,
    this.obscureText = false,
    this.focusNode,
    this.nextFocusNode,
    this.validator,
    this.keyboardType,
    this.color,
    this.maxLine,
    this.suffix,
    this.readonly,
    this.textInputAction = TextInputAction.done,
  });

  @override
  State<TextFeldWidgetEdit> createState() => _TextFeldWidgetEditState();
}

class _TextFeldWidgetEditState extends State<TextFeldWidgetEdit> {
  bool _obscureText = true;
  String? _errorText; // Track error text locally

  @override
  void initState() {
    super.initState();
    // Ensure the form state is updated with the initial controller value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.validator != null && mounted) {
        final value = widget.controller.text;
        _updateErrorText(value); // Trigger initial validation and update error
      }
    });
  }

  void _updateErrorText(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() {
        _errorText = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.color ?? AppColors.white,
            border:
                widget.boxborder ??
                Border.all(
                  color: widget.color != null
                      ? AppColors.grey
                      : AppColors.themecolor,
                  width: 1,
                ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            readOnly: widget.readonly ?? false,
            focusNode: widget.focusNode,
            obscureText: widget.obscureText && _obscureText,
            controller: widget.controller,
            enabled: widget.isDisable,
            maxLines: widget.maxLine ?? 1,
            decoration: InputDecoration(
              suffixIcon: widget.obscureText
                  ? IconButton(
                      onPressed: () {
                        setState(() => _obscureText = !_obscureText);
                      },
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.themecolor,
                      ),
                    )
                  : widget.suffix,
              contentPadding: const EdgeInsets.all(15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none, // Match container border
              ),
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
              ),
              errorText: null, // Disable native error text
              errorStyle: const TextStyle(height: 0),
            ),
            validator: (value) {
              _updateErrorText(value);
              return null; // Let custom error handling take over
            },
            onChanged: (value) {
              _updateErrorText(value); // Update error on change
            },
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            textInputAction: widget.nextFocusNode != null
                ? TextInputAction.next
                : TextInputAction.done,
            keyboardType: widget.keyboardType,
            onFieldSubmitted: (value) {
              if (widget.nextFocusNode != null) {
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
              } else {
                FocusScope.of(context).unfocus();
              }
            },
          ),
        ),
        if (_errorText != null && _errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 10.0),
            child: Text(_errorText!, style: const TextStyle(color: Colors.red)),
          ),
      ],
    );
  }
}

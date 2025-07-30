import 'package:flutter/material.dart';
import '../Utils/Appcolor.dart';

class TexfieldWidget extends StatefulWidget {
  final String hint;
  final FocusNode? focusNode; // Add focusNode parameter
  final FocusNode? nextFocusNode; // Add nextFocusNode parameter
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? isDisable;
  bool? readonly = false;
  final Widget? suffix;
  final Color? color;
  final int? maxLine;
 final BoxBorder ?boxborder;
  final TextInputAction textInputAction; // New parameter

  TexfieldWidget({
    super.key,
    required this.hint,
    required this.controller,
    this.boxborder,
    this.isDisable,
    this.obscureText = false,
    this.focusNode, // Initialize focusNode
    this.nextFocusNode,
    this.validator,
    this.keyboardType,
    this.color,
    this.maxLine,
    this.suffix,
    this.readonly,
    this.textInputAction = TextInputAction.done, // Default to done
  });

  @override
  State<TexfieldWidget> createState() => _TexfieldWidgetState();
}

class _TexfieldWidgetState extends State<TexfieldWidget> {
  bool _obscureText = true;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // Don't dispose the controller here
    _focusNode.dispose();
    super.dispose();
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
                  decoration: BoxDecoration(
                    color: widget.color ?? AppColors.white,
                    border:widget.boxborder ??  Border.all(
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
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      //   borderSide:
                      //       BorderSide(color: widget.color ?? AppColors.grey),
                      // ),
                      border: InputBorder.none,
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                          color: AppColors.grey, fontWeight: FontWeight.w400),
                      errorStyle: const TextStyle(height: 0),
                    ),
                    onChanged: (value) {
                      fieldState.reset();
                      fieldState.didChange(value);
                    },
                    onTapOutside: (PointerDownEvent event) {
                      FocusScope.of(context)
                          .unfocus(); // Unfocus the text field
                    },
                    textInputAction: widget.nextFocusNode != null
                        ? TextInputAction.next
                        : TextInputAction.done,
                    keyboardType: widget.keyboardType,
                    onFieldSubmitted: (value) {
                      // Explicitly request the next focus if provided, otherwise unfocus
                      if (widget.nextFocusNode != null) {
                        FocusScope.of(context)
                            .requestFocus(widget.nextFocusNode);
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

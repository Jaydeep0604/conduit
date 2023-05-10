import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConduitEditText extends StatefulWidget {
  TextInputType? textInputType;
  String? hint;

  String? name;
  int?   maxLength;
  String? Function(String?)? validator;
  TextInputAction? textInputAction;
  void Function()? onEditingComplete;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool obsecureText;
  bool readOnly;
  bool enabled; 

  TextEditingController? controller;
  List<TextInputFormatter>? inputformtters;
  bool autoFoucs;

  ConduitEditText(
      {this.textInputType,
      this.obsecureText = false,
      this.readOnly = false,
      this.suffixIcon,
      this.prefixIcon,
      this.hint,
      this.name,
      this.textInputAction,
      this.validator,
      this.controller,
      this.inputformtters,
      this.enabled = true,
      this.maxLength,
      this.onEditingComplete,
      this.autoFoucs = false,
      Key? key})
      : super(key: key);

  @override
  _ConduitEditTextState createState() => _ConduitEditTextState();
}

class _ConduitEditTextState extends State<ConduitEditText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        onEditingComplete: widget.onEditingComplete,
        textInputAction: widget.textInputAction,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: widget.textInputType,
        obscureText: widget.obsecureText,
        readOnly: widget.readOnly,
        cursorColor: AppColors.button_color,
        inputFormatters: widget.inputformtters,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        autofocus: widget.autoFoucs,
        toolbarOptions: ToolbarOptions(
          copy: true,
          cut: true,
          paste: false,
          selectAll: false,
        ),
        style: TextStyle(fontSize: 14, //fontFamily: KSMFontFamily.robotoRgular
        ),
        decoration: InputDecoration(
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            errorStyle: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: Colors.red),
            helperStyle: Theme.of(context).textTheme.subtitle1,
            hintStyle: Theme.of(context).textTheme.caption,
            hintText: widget.hint,
            filled: true,
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            label: widget.name != null ? Text(widget.name ?? "") : null,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}
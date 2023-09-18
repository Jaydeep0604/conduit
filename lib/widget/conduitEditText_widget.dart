import 'package:conduit/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConduitEditText extends StatefulWidget {
  TextInputType? textInputType;
  String? hint;
  int? maxLines;
  int? minLines;
  String? name;
  int? maxLength;
  String? Function(String?)? validator;
  TextInputAction? textInputAction;
  void Function()? onEditingComplete;
  void Function(String)? onChanged;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool obsecureText;
  bool readOnly;
  bool enabled;

  TextEditingController? controller;
  List<TextInputFormatter>? inputFormatters;
  bool autoFoucs;

  ConduitEditText(
      {this.textInputType,
      this.obsecureText = false,
      this.readOnly = false,
      this.maxLines,
      this.minLines,
      this.suffixIcon,
      this.prefixIcon,
      this.hint,
      this.name,
      this.textInputAction,
      this.onChanged,
      this.validator,
      this.controller,
      this.inputFormatters,
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
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        autofocus: widget.autoFoucs,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        toolbarOptions: ToolbarOptions(
          copy: true,
          cut: true,
          paste: true,
          selectAll: true,
        ),
        style: TextStyle(
          fontSize: 14, //fontFamily: KSMFontFamily.robotoRgular
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
            contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10),
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

class ConduitSearchEditText extends StatefulWidget {
  TextInputType? textInputType;
  String? hint;
  int? maxLines;
  int? minLines;
  String? name;
  int? maxLength;
  String? Function(String?)? validator;
  TextInputAction? textInputAction;
  void Function()? onEditingComplete;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool obsecureText;
  bool readOnly;
  bool enabled;

  TextEditingController? controller;
  List<TextInputFormatter>? inputFormatters;
  bool autoFoucs;

  ConduitSearchEditText(
      {this.textInputType,
      this.obsecureText = false,
      this.readOnly = false,
      this.maxLines,
      this.minLines,
      this.suffixIcon,
      this.prefixIcon,
      this.hint,
      this.name,
      this.textInputAction,
      this.validator,
      this.controller,
      this.inputFormatters,
      this.enabled = true,
      this.maxLength,
      this.onEditingComplete,
      this.autoFoucs = false,
      Key? key})
      : super(key: key);

  @override
  _ConduitSearchEditTextState createState() => _ConduitSearchEditTextState();
}

class _ConduitSearchEditTextState extends State<ConduitSearchEditText> {
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
        inputFormatters: widget.inputFormatters,
        enabled: widget.enabled,
        maxLength: widget.maxLength,
        autofocus: widget.autoFoucs,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        toolbarOptions: ToolbarOptions(
          copy: true,
          cut: true,
          paste: true,
          selectAll: true,
        ),
        style: TextStyle(
          fontSize: 14, //fontFamily: KSMFontFamily.robotoRgular
        ),
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          fillColor: AppColors.white,
          errorStyle:
              Theme.of(context).textTheme.caption?.copyWith(color: Colors.red),
          helperStyle: Theme.of(context).textTheme.subtitle1,
          hintStyle: Theme.of(context).textTheme.caption,
          hintText: widget.hint,
          filled: true,
          contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10),
          label: widget.name != null ? Text(widget.name ?? "") : null,
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent,
              )),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent,
              )),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent,
              )),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent,
              )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.transparent,
              )),
        ),
      ),
    );
  }
}

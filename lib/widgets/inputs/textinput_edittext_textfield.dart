import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_sizes.dart';
import 'package:flutter_hopper/constants/app_text_direction.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';

class CustomHintLableTextFormField  extends StatefulWidget {
  CustomHintLableTextFormField ({
    Key key,
    this.hintText,
    this.border,
    this.filled,
    this.isFixedHeight = true,
    this.borderRadius,
    this.padding,
    this.fillColor,
    this.textEditingController,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.cursorColor,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.labelText,
    this.labelTextStyle,
    this.hintTextStyle,
    this.prefixWidget,
    this.suffixWidget,
    this.togglePassword = false,
    this.errorText,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
    this.nextFocusNode,
    this.isReadOnly = false,
    this.onTap,
    this.left=20,
    this.right=20,
    this.top=5,
    this.bottom=5
  }) : super(key: key);

  final InputBorder border;
  final bool filled;
  final bool isFixedHeight;
  final double borderRadius;
  final EdgeInsets padding;
  final Color fillColor;
  final TextEditingController textEditingController;
  final bool obscureText;
  final bool togglePassword;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final Color cursorColor;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final String labelText;
  final TextStyle labelTextStyle;

  final String hintText;
  final TextStyle hintTextStyle;

  final Widget prefixWidget;
  final Widget suffixWidget;

  final Function onChanged;
  final Function onFieldSubmitted;
  final String errorText;
  final Function validator;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  final bool isReadOnly;
  final Function onTap;

  final double left;
  final double right;
  final double top;
  final double bottom;

  @override
  _CustomHintLableTextFormFieldState createState() => _CustomHintLableTextFormFieldState();
}

class _CustomHintLableTextFormFieldState extends State<CustomHintLableTextFormField > {
  bool makePasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: widget.isFixedHeight ? AppSizes.inputHeight : null,
          padding: EdgeInsets.fromLTRB(widget.left, widget.top,widget.right,widget.bottom),
          /* decoration: BoxDecoration(
            color: widget.fillColor ?? AppColor.textFieldBackground(context),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.borderRadius ?? 20),
            ),
          ),*/
          child: Row(
            children: <Widget>[
              //show leading widget or empty space if no leading widget was added
              widget.prefixWidget ?? SizedBox.shrink(),

              //add spacing if there is a leading widget
              (widget.prefixWidget != null)
                  ? SizedBox(
                width: 15,
              )
                  : SizedBox.shrink(),

              Expanded(
                child: TextFormField(
                  onTap: widget.onTap,
                  readOnly: widget.isReadOnly,
                  controller: widget.textEditingController,
                  focusNode: widget.focusNode,
                  textAlign: widget.textAlign,
                  textDirection: AppTextDirection.defaultDirection,
                  onFieldSubmitted: (data) {
                    if (widget.onFieldSubmitted != null) {
                      widget.onFieldSubmitted(data);
                    } else {
                      FocusScope.of(context).requestFocus(widget.nextFocusNode);
                    }
                  },
                  onChanged: widget.onChanged,
                  obscureText:
                  (widget.obscureText) ? !makePasswordVisible : false,
                  textInputAction: widget.textInputAction,
                  keyboardType: widget.keyboardType,
                  cursorColor: (widget.cursorColor != null)
                      ? widget.cursorColor
                      : AppColor.cursorColor,
                  style: (widget.textStyle != null)
                      ? widget.textStyle
                      : AppTextStyle.h4TitleTextStyle(
                    color: AppColor.textColor(context),
                  ),
                  validator: widget.validator,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelStyle: widget.labelTextStyle ??
                        AppTextStyle.h4TitleTextStyle(
                          color: AppColor.hintTextColor(context),
                        ),
                    hintStyle: widget.hintTextStyle,
                    labelText: widget.labelText,
                    hintText: widget.hintText,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),

              //suffix widget
              if (widget.togglePassword)
                ButtonTheme(
                  minWidth: 30,
                  height: 30,
                  padding: EdgeInsets.all(0),
                  child: FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        makePasswordVisible = !makePasswordVisible;
                      });
                    },
                    child: Icon(
                      (!makePasswordVisible)
                          ? FlutterIcons.md_eye_off_ion
                          : FlutterIcons.md_eye_ion,
                      color: Colors.grey,
                    ),
                  ),
                )
              else if (widget.suffixWidget != null)
                widget.suffixWidget
              else
                SizedBox.shrink(),
            ],
          ),
        ),

        // Error text widget
        widget.errorText != null
            ? Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.errorText,
            style: AppTextStyle.h6TitleTextStyle(
              color: Colors.red,
            ),
            textDirection: AppTextDirection.defaultDirection,
          ),
        )
            : SizedBox.shrink(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_paddings.dart';
import 'package:flutter_hopper/widgets/state/busy_indicator.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    Key key,
    this.onPressed,
    this.onLongPress,
    this.elevation,
    this.child,
    this.textColor,
    this.disabledTextColor,
    this.color,
    this.disabledColor,
    this.borderColor,
    this.padding,
    this.shape,
    this.loading = false,
  }) : super(key: key);

  final Function onPressed;
  final Function onLongPress;
  final double elevation;
  final Widget child;
  final Color textColor;
  final Color disabledTextColor;
  final Color color;
  final Color disabledColor;
  final Color borderColor;
  final EdgeInsets padding;
  final ShapeBorder shape;
  final bool loading;
  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: widget.elevation ?? 0,
      padding: widget.padding ?? AppPaddings.buttonPadding(),
      color: widget.color ?? Colors.white,
      disabledColor: widget.disabledColor,
      disabledTextColor: widget.disabledTextColor,
      textColor: widget.textColor ?? Colors.black,
      shape: widget.shape ??
          StadiumBorder(
            side: BorderSide(color: widget.borderColor ?? Colors.transparent),
          ),
      onPressed: widget.onPressed,
      onLongPress: widget.onLongPress,
      child: widget.loading ? BusyIndicator() : widget.child,
    );
  }
}

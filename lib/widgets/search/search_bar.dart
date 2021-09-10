import 'package:flutter/material.dart';
import 'package:flutter_hopper/constants/app_color.dart';
import 'package:flutter_hopper/constants/app_text_styles.dart';
import 'package:flutter_hopper/widgets/inputs/custom_text_form_field.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    @required this.onSearchBarPressed,
    this.onSubmit,
    this.readOnly = false,
    this.focusNode,
    this.hintText
  }) : super(key: key);

  final Function onSearchBarPressed;
  final Function onSubmit;
  final bool readOnly;
  final String hintText;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      isReadOnly: readOnly,
      focusNode: this.focusNode,
      hintText: hintText,
      cursorColor: AppColor.primaryColor,
      fillColor: Color(0xFF027A7A),
      textStyle: AppTextStyle.h4TitleTextStyle(
        color: Colors.white,
      ),
      hintTextStyle: AppTextStyle.h4TitleTextStyle(
        color: AppColor.primaryColor,
      ),

      suffixWidget: Icon(
        Icons.search,
        color: AppColor.primaryColor,
      ),
      //suffixWidget: ,
      onTap: this.onSearchBarPressed,
      onFieldSubmitted: this.onSubmit,
    );
  }
}

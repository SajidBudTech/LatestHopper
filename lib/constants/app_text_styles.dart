import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  //Text Sized
  static TextStyle h0TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w800,
  }) {
    return GoogleFonts.montserrat(
      fontSize: 30,
      fontWeight: fontWeight,
      color: color,
    );
  }
  static TextStyle h01TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w800,
  }) {
    return GoogleFonts.montserrat(
      fontSize: 25,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle h1TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w600,
    TextDecoration decoration,
  }) {
    // GoogleFonts.poppins()
    return GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }

  static TextStyle h2TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w600,
    TextDecoration decoration,
  }) {
    return GoogleFonts.montserrat(
      fontSize: 22,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }

  static TextStyle h3TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle h4TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
    TextDecoration decoration,
  }) {
    return GoogleFonts.montserrat(
      fontSize: 15,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }

  static TextStyle h5TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w400,
    TextDecoration decoration,
    FontStyle fontStyle=FontStyle.normal,
  }) {
    return GoogleFonts.montserrat(
      fontSize: 13,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
      fontStyle: fontStyle
    );
  }

  static TextStyle h7TitleTextStyle({
    Color color = Colors.grey,
    FontWeight fontWeight = FontWeight.w400,
    TextDecoration decoration,
  }) {
    return GoogleFonts.montserrat(
      fontSize: 13,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }
  static TextStyle h12TitleTextStyle({
    Color color = Colors.grey,
    FontWeight fontWeight = FontWeight.w400,
    TextDecoration decoration,
  }) {
    return GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }

  static TextStyle h6TitleTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w300,TextDecoration decoration,FontStyle fontStyle = FontStyle.normal}) {
    return GoogleFonts.roboto(
        fontSize: 11, fontWeight: fontWeight, color: color,decoration: decoration,fontStyle: fontStyle);
  }


  static TextStyle h3LineTitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
    TextDecoration decoration
  }) {
    return GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: fontWeight,
      color: color,
      decoration:decoration
    );
  }

  static TextStyle h8TitleTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w300,TextDecoration decoration}) {
    return GoogleFonts.montserrat(
      fontSize: 8, fontWeight: fontWeight, color: color,decoration: decoration,);
  }

}

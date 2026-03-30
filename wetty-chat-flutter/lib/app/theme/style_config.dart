import 'package:flutter/cupertino.dart';

const appBaseTextStyle = TextStyle(fontWeight: FontWeight.w400);

const appCupertinoTheme = CupertinoThemeData(
  // TODO: follow the system settings
  brightness: Brightness.light,
  textTheme: CupertinoTextThemeData(
    textStyle: appBaseTextStyle,
    actionTextStyle: appBaseTextStyle,
    tabLabelTextStyle: appBaseTextStyle,
    navTitleTextStyle: appBaseTextStyle,
    navLargeTitleTextStyle: appBaseTextStyle,
    navActionTextStyle: appBaseTextStyle,
    pickerTextStyle: appBaseTextStyle,
    dateTimePickerTextStyle: appBaseTextStyle,
  ),
);

TextStyle appTextStyle(
  BuildContext context, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  FontStyle? fontStyle,
  TextDecoration? decoration,
  Color? decorationColor,
}) {
  return CupertinoTheme.of(context).textTheme.textStyle.copyWith(
    color: color ?? CupertinoColors.label.resolveFrom(context),
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    fontStyle: fontStyle,
    decoration: decoration,
    decorationColor: decorationColor,
  );
}

TextStyle appSecondaryTextStyle(
  BuildContext context, {
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  FontStyle? fontStyle,
}) {
  return appTextStyle(
    context,
    color: CupertinoColors.secondaryLabel.resolveFrom(context),
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    fontStyle: fontStyle,
  );
}

TextStyle appTitleTextStyle(
  BuildContext context, {
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  return appTextStyle(
    context,
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight ?? FontWeight.w600,
  );
}

TextStyle appBubbleTextStyle(
  BuildContext context, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  FontStyle? fontStyle,
}) {
  return appTextStyle(
    context,
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    fontStyle: fontStyle,
  );
}

TextStyle appBubbleMetaTextStyle(
  BuildContext context, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return appBubbleTextStyle(
    context,
    color: color ?? CupertinoColors.secondaryLabel.resolveFrom(context),
    fontSize: fontSize,
    fontWeight: fontWeight,
  );
}

TextStyle appOnDarkTextStyle(
  BuildContext context, {
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  return appTextStyle(
    context,
    color: color ?? CupertinoColors.white,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );
}

import 'package:flutter/material.dart';

text({@required text, size, color, fontWeight, height, align}) => Text(
      text.toString(),
      textScaleFactor: 1.0,
      softWrap: true,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
          fontSize: size,
          fontFamily: 'almarai',
          color: color,
          fontWeight: fontWeight,
          height: height),
    );

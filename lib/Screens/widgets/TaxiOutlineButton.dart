import 'package:truckngo/brand_colors.dart';
import 'package:flutter/material.dart';

class TaxiOutlineButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;

  const TaxiOutlineButton(
      {required this.title, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          primary: color,
        ),
        child: SizedBox(
          height: 50.0,
          child: Center(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Brand-Bold',
                    color: BrandColors.colorText)),
          ),
        ));
  }
}

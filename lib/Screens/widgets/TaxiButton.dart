import 'package:flutter/material.dart';

class TaxiButton extends StatelessWidget {
  const TaxiButton({required this.title, required this.color, required this.onPressed});
  final String title;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      color: color,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: SizedBox(
        height: 50,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Brand-Bold',
            ),
          ),
        ),
      ),
    );
  }
}

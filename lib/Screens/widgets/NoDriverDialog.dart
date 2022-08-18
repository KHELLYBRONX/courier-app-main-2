import 'package:truckngo/brand_colors.dart';
import 'package:truckngo/Screens/widgets/TaxiOutlineButton.dart';
import 'package:flutter/material.dart';

class NoDriverDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'No driver found',
                  style: TextStyle(fontSize: 22.0, fontFamily: 'Brand-Bold'),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'No available driver close by, we suggest you try again shortly',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 200,
                  child: TaxiOutlineButton(
                    title: 'CLOSE',
                    color: BrandColors.colorLightGrayFair,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

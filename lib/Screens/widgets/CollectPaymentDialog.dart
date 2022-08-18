import 'package:truckngo/brand_colors.dart';
import 'package:truckngo/Screens/widgets/BrandDivider.dart';
import 'package:truckngo/Screens/widgets/TaxiButton.dart';
import 'package:flutter/material.dart';

class CollectPayment extends StatelessWidget {
  final String paymentMethod;
  final int fares;

  const CollectPayment({required this.paymentMethod, required this.fares});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Text('${paymentMethod.toUpperCase()} PAYMENT'),
            const SizedBox(
              height: 20,
            ),
            BrandDivider(),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              '\$$fares',
              style: const TextStyle(fontFamily: 'Brand-Bold', fontSize: 50),
            ),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Amount above is the total fares to be charged to the rider',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 230,
              child: TaxiButton(
                title: (paymentMethod == 'cash') ? 'PAY CASH' : 'CONFIRM',
                color: BrandColors.colorGreen,
                onPressed: () {
                  Navigator.pop(context, 'close');
                },
              ),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}

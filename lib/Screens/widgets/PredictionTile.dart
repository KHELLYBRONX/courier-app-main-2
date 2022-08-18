import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truckngo/Screens/widgets/ProgressDialog.dart';
import 'package:truckngo/brand_colors.dart';
import 'package:truckngo/globalvariables.dart';
import 'package:truckngo/helpers/requesthelper.dart';
import 'package:truckngo/models/address.dart';
import 'package:truckngo/models/prediction.dart';

import '../maps/bloc/maps_bloc.dart';

class PredictionTile extends StatelessWidget {
  final Prediction prediction;
  const PredictionTile({required this.prediction});

  void getPlaceDetails(String placeId, context) async {
    print('this is the $placeId');
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => const ProgressDialog(
              status: 'Please waiitt..',
            ));
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$mapKey';
    var response = await RequestHelper.getRequest(url);
    Navigator.pop(context);
    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      Address thisPlace = Address();
      thisPlace.placeName = response['result']['name'];
      thisPlace.placeId = placeId;
      thisPlace.latitude = response['result']['geometry']['location']['lat'];
      thisPlace.longitude = response['result']['geometry']['location']['lng'];
      BlocProvider.of<MapsBloc>(context)
          .add(UpdateDestinationAddressEvent(thisPlace));
      print(thisPlace.placeName);
      Navigator.pop(context, thisPlace);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapsBloc(),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        onPressed: () {
          getPlaceDetails(prediction.placeId!, context);
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  const Icon(Icons.location_on,
                      color: BrandColors.colorDimText),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          prediction.mainText!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          prediction.secondaryText ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 12, color: BrandColors.colorDimText),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

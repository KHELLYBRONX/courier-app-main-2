import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:truckngo/Screens/widgets/BrandDivider.dart';
import 'package:truckngo/Screens/widgets/PredictionTile.dart';
import 'package:truckngo/brand_colors.dart';
import 'package:truckngo/globalvariables.dart';
import 'package:truckngo/helpers/requesthelper.dart';
import 'package:truckngo/models/prediction.dart';

import 'maps/bloc/maps_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();

  var focusDestination = FocusNode();
  bool focused = false;
  void setFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }

  List<Prediction> destinationPredictionList = [];

  void searchPlace(String placeName) async {
    if (placeName.length > 1) {
      String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=123254251&components=country:gh';
      var response = await RequestHelper.getRequest(url);
      if (response == 'failed') {
        print('RESPONSE FAILED ON SEARCH');
        return;
      }
      if (response['status'] == 'OK') {
        var predictionJson = response['predictions'];
        var thisList = (predictionJson as List)
            .map((e) => Prediction.fromJson(e))
            .toList();
        setState(() {
          destinationPredictionList = thisList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String address = context
        .select((MapsBloc bloc) => bloc.state.pickUpAddress?.placeName ?? '');
    pickupController.text = address;
    setFocus();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 210,
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7))
              ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, top: 48, right: 24, bottom: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      Stack(children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                        const Center(
                          child: Text(
                            'Set Destination',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'Brand-Bold'),
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset(
                            'images/pickicon.png',
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: BrandColors.colorLightGrayFair,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: TextField(
                                  controller: pickupController,
                                  decoration: const InputDecoration(
                                    hintText: 'Pickup Location',
                                    fillColor: BrandColors.colorLightGrayFair,
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 10, top: 8, bottom: 8),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Image.asset(
                            'images/desticon.png',
                            height: 16,
                            width: 16,
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: BrandColors.colorLightGrayFair,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: TextField(
                                  onChanged: (value) {
                                    searchPlace(value);
                                  },
                                  focusNode: focusDestination,
                                  controller: destinationController,
                                  decoration: const InputDecoration(
                                    hintText: 'Where to?',
                                    fillColor: BrandColors.colorLightGrayFair,
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                        left: 10, top: 8, bottom: 8),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            (destinationPredictionList.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      itemBuilder: (context, index) {
                        return BlocProvider(
                          create: (context) => MapsBloc(),
                          child: PredictionTile(
                              prediction: destinationPredictionList[index]),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          BrandDivider(),
                      itemCount: destinationPredictionList.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

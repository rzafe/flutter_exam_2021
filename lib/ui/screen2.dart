import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_exam_2021/model/station.dart';
import 'package:flutter_exam_2021/service/api/cms/station_presenter.dart';
import 'package:flutter_exam_2021/ui/screen3.dart';
import 'package:geolocator/geolocator.dart';

import 'screen1.dart';

class Screen2 extends StatefulWidget {
  const Screen2({
    Key? key,
    this.accessToken,
    this.stationList,
  }) : super(key: key);

  final String? accessToken;
  final List<Station>? stationList;

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final TextEditingController _searchController = TextEditingController();
  final StationPresenter stationPresenter = StationPresenter();
  Future<List<Station>>? futureOrigStationList;
  Future<List<Station>>? futureStationList;
  List<Station> stationList = <Station>[];
  List<Station> stationOrigList = <Station>[];

  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((value) {
      latitude = value.latitude;
      longitude = value.longitude;
    });
    futureStation();
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void futureStation() async {
    setState(() {
      futureOrigStationList = stationPresenter.getStationListAPI(widget.accessToken!);
      futureStationList = futureOrigStationList;
      futureStationList!.then((List<Station> value) {
        setState(() {
          for (int i = 0; i < value.length; i++) {
            double distance = Geolocator.distanceBetween(latitude, longitude, double.parse(value[i].lat!), double.parse(value[i].lng!));
            double distanceInKiloMeters = distance / 1000;
            int roundDistanceInKM = double.parse((distanceInKiloMeters).toStringAsFixed(0)).round();
            value[i].distance = roundDistanceInKM;
          }
          stationList = value;
          stationList.sort((a, b) {
            return a.distance!.compareTo(b.distance!);
          });
          stationOrigList = stationList;
          print(stationList.toString());
        });
      }, onError: (e) {
        stationList = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.deepPurpleAccent,
                title: Text(
                  'Search Station',
                  style: const TextStyle(
                    color: Colors.white,),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    tooltip: 'close',
                    icon: const Icon(Icons.close),
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                Screen1(accessToken: widget.accessToken,)),
                      );
                    },
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                color: Colors.deepPurpleAccent,
                child: Column(
                  children: [
                    Text(
                      'Which PriceLOCQ station will you likely visit?',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    _searchLayout(
                      onChanged: (value) async {
                        setState(() {
                          var outputList = stationOrigList.where((o) => o.name!.contains(value) || o.name!.toLowerCase().contains(value)).toList();
                          stationList = outputList;
                          print(outputList.length);
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Station>>(
                  future: futureStationList,
                  builder: (BuildContext context, AsyncSnapshot<List<Station>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text('Empty'),
                          );
                        }

                        return ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            itemCount: stationList.length,/*(snapshot.data == null
                                ? 0
                                : snapshot.data!.length),*/
                            itemBuilder: (BuildContext context, int index) {
                              // var item = snapshot.data![index];
                              var item = stationList[index];
                              double distance = Geolocator.distanceBetween(latitude, longitude, double.parse(item.lat!), double.parse(item.lng!));
                              double distanceInKiloMeters = distance / 1000;
                              int roundDistanceInKM = double.parse((distanceInKiloMeters).toStringAsFixed(0)).round();

                              return InkWell(
                                onTap: () async {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) =>
                                            Screen3(
                                              accessToken: widget.accessToken,
                                              station: item,
                                              roundDistanceInKM: roundDistanceInKM.toString(),)),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.name!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),),
                                            Text(roundDistanceInKM.toString() + ' km away from you')
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.radio_button_off, color: Colors.grey,),
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      case ConnectionState.none:
                      default:
                        return Center(
                          child: Text('Empty'),
                        );
                    }
                  }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchLayout({ValueChanged? onChanged}) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 30.0, left: 10.0, right: 10.0),
      height: 58,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        // focusNode: emailFocusNode,
        // onFieldSubmitted: (String term) {
        //   _fieldFocusChange(context, emailFocusNode, passwordFocusNode);
        // },
        onChanged: onChanged,
        keyboardType: TextInputType.text,
        // inputFormatters: [
        //   WhitelistingTextInputFormatter(
        //     RegExp('[a-zA-Z0-9_.@]'),
        //   )
        // ],
        cursorColor: Colors.blue,
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: Colors.transparent
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                width: 2.0,
                color: Colors.transparent
            ),
          ),
          border: const OutlineInputBorder(),
          hintText: 'Search',
          // labelText: 'Search',
          labelStyle: const TextStyle(
              fontFamily: 'RobotoRegular',
              fontSize: 15),
          fillColor: Colors.white,
          filled: true,
        ),
        style: const TextStyle(
            fontSize: 15,
            fontFamily: 'RobotoRegular',
            color: Colors.black),
      ),
    );
  }

}

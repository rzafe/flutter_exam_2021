import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_exam_2021/model/station.dart';
import 'package:flutter_exam_2021/service/api/cms/station_presenter.dart';
import 'package:flutter_exam_2021/ui/screen3.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'screen2.dart';

class Screen1 extends StatefulWidget {
  const Screen1({
    Key? key,
    this.accessToken,
  }) : super(key: key);

  final String? accessToken;

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  late BuildContext scaffoldContext;
  final StationPresenter stationPresenter = StationPresenter();
  Future<List<Station>>? futureStationList;
  List<Station> stationList = <Station>[];
  bool isClickButton1 = false;
  bool isClickButton2 = false;
  bool isClickButton3 = false;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition? kGooglePlex;
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  double latitude = 0;
  double longitude = 0;

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((value) {
      latitude = value.latitude;
      longitude = value.longitude;

      setState(() {
        kGooglePlex = CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 14.4746,
        );
      });
    });
    futureStation();
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  void futureStation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      futureStationList = stationPresenter.getStationListAPI(widget.accessToken!);
      futureStationList!.then((List<Station> value) {
        setState(() {
          for (int i = 0; i < value.length; i++) {
            double distance = Geolocator.distanceBetween(position.latitude, position.longitude, double.parse(value[i].lat!), double.parse(value[i].lng!));
            double distanceInKiloMeters = distance / 1000;
            int roundDistanceInKM = double.parse((distanceInKiloMeters).toStringAsFixed(0)).round();
            value[i].distance = roundDistanceInKM;
          }
          stationList = value;
          stationList.sort((a, b) {
            return a.distance!.compareTo(b.distance!);
          });
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
                    tooltip: 'Search',
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                Screen2(
                                  accessToken: widget.accessToken,)
                        ),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.deepPurpleAccent,
                        child: Center(
                          child: Text(
                            'Which PriceLOCQ station will you likely visit?',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),),
                        ),
                      ),
                      Expanded(
                        child: kGooglePlex == null ? Container() : GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: kGooglePlex!,
                          myLocationEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            setState(() {
                              _controller.complete(controller);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            'Nearby Stations',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: stationList.length == 0 ? Center(child: CircularProgressIndicator(),) : Column(
                        children: [
                          item(
                            title: stationList[0].name,
                            subTitle: stationList[0].distance.toString() + ' km away from you',
                            isClick: isClickButton1 ? true : false,
                            onTap: () {
                              setState(() {
                                isClickButton1 = true;
                                isClickButton2 = false;
                                isClickButton3 = false;
                                // _goToLocation(latitude: double.parse(stationList[0].lat!), longitude: double.parse(stationList[0].lng!));

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          Screen3(
                                            accessToken: widget.accessToken,
                                            station: stationList[0],
                                            roundDistanceInKM: stationList[0].distance.toString(),)),
                                );
                              });
                            }
                          ),
                          item(
                            title: stationList[1].name,
                            subTitle: stationList[1].distance.toString() + ' km away from you',
                            isClick: isClickButton2 ? true : false,
                            onTap: () {
                              setState(() {
                                isClickButton1 = false;
                                isClickButton2 = true;
                                isClickButton3 = false;
                                // _goToLocation(latitude: double.parse(stationList[1].lat!), longitude: double.parse(stationList[1].lng!));

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          Screen3(
                                            accessToken: widget.accessToken,
                                            station: stationList[1],
                                            roundDistanceInKM: stationList[1].distance.toString(),)),
                                );
                              });
                            }
                          ),
                          item(
                            title: stationList[2].name,
                            subTitle: stationList[2].distance.toString() + ' km away from you',
                            isClick: isClickButton3 ? true : false,
                            onTap: () {
                              setState(() {
                                isClickButton1 = false;
                                isClickButton2 = false;
                                isClickButton3 = true;
                                // _goToLocation(latitude: double.parse(stationList[2].lat!), longitude: double.parse(stationList[2].lng!));

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          Screen3(
                                            accessToken: widget.accessToken,
                                            station: stationList[2],
                                            roundDistanceInKM: stationList[2].distance.toString(),)),
                                );
                              });
                            }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  Widget item({String? title, String? subTitle, bool? isClick, Function? onTap}) {
    return InkWell(
      onTap: () async {
        onTap!();
      },
      child: Container(
        // padding: EdgeInsets.all(15),
        margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title!,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),),
                  Text(subTitle!)
                ],
              ),
            ),
            Icon(isClick! ? Icons.radio_button_checked : Icons.radio_button_off, color: Colors.grey,),
          ],
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> _goToLocation({double? latitude, double? longitude}) async {
    final GoogleMapController controller = await _controller.future;
    final CameraPosition _kLake = CameraPosition(
        target: LatLng(latitude!, longitude!),
        zoom: 19.151926040649414);
    
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

}

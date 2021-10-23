import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_exam_2021/model/station.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'screen1.dart';
import 'screen2.dart';

class Screen3 extends StatefulWidget {
  const Screen3({
    Key? key,
    this.accessToken,
    this.station,
    this.roundDistanceInKM,
  }) : super(key: key);

  final String? accessToken;
  final Station? station;
  final String? roundDistanceInKM;

  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
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
    kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.station!.lat!), double.parse(widget.station!.lng!)),
      zoom: 19.4746,
    );
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
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: kGooglePlex!,
                          myLocationEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
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
                            'Back to list',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        Screen1(
                                          accessToken: widget.accessToken,)
                                ),
                              );
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.station!.name!,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          Text(
                            widget.station!.address!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 25),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.time_to_leave),
                          SizedBox(width: 5,),
                          Text(widget.roundDistanceInKM! + ' km away',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10),),
                          SizedBox(width: 15,),
                          Icon(Icons.access_time_outlined),
                          SizedBox(width: 5,),
                          Text('Open 24 hours',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

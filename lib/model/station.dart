
class Station {
  Station({
    this.id,
    this.code,
    this.mobileNum,
    this.area,
    this.province,
    this.city,
    this.name,
    this.businessName,
    this.address,
    this.lat,
    this.lng,
    this.type,
    this.depotId,
    this.dealerId,
    this.distance,
    // this.createdAt,
    // this.updatedAt
  });

  int? id;
  String? code;
  String? mobileNum;
  String? area;
  String? province;
  String? city;
  String? name;
  String? businessName;
  String? address;
  String? lat;
  String? lng;
  String? type;
  int? depotId;
  int? dealerId;
  int? distance;
  // String? createdAt;
  // String? updatedAt;

  @override
  String toString() {
    return 'Station{id: $id, code: $code, mobileNum: $mobileNum, area: $area, province: $province, city: $city, name: $name, businessName: $businessName, address: $address, lat: $lat, lng: $lng, type: $type, depotId: $depotId, dealerId: $dealerId, distance: $distance}';
  }

  factory Station.fromMap(Map<String, dynamic> json) => Station(
      id: json['id'],
      code: json['code'],
      mobileNum: json['mobileNum'],
      area: json['area'],
      province: json['province'],
      city: json['city'],
      name: json['name'],
      businessName: json['businessName'],
      address: json['address'],
      lat: json['lat'],
      lng: json['lng'],
      type: json['type'],
      depotId: json['depotId'],
      dealerId: json['dealerId'],
      distance: 0,
      // createdAt: json['createdAt'],
      // updatedAt: json['updatedAt'],
  );

  factory Station.fromSnapshot(Station station) {
    return Station(
      id : station.id,
      code : station.code,
      mobileNum : station.mobileNum,
      area : station.area,
      province : station.province,
      city : station.city,
      name : station.name,
      businessName : station.businessName,
      address : station.address,
      lat : station.lat,
      lng : station.lng,
      type : station.type,
      depotId : station.depotId,
      dealerId : station.dealerId,
      distance: station.distance,
    );
  }

}
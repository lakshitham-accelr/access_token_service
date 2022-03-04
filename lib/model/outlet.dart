class Outlet {
  Outlet({
    required this.outletCode,
    required this.outletName,
    required this.outletAddress,
    required this.gpsLat,
    required this.gpsLong,
    required this.phoneNumber,
    required this.enabled,
  });

  late final String outletCode;
  late final String outletName;
  late final String outletAddress;
  late final double gpsLat;
  late final double gpsLong;
  late final String phoneNumber;
  late final bool enabled;

  Outlet.fromJson(Map<String, dynamic> json) {
    outletCode = json['outletCode'];
    outletName = json['outletName'];
    outletAddress = json['outletAddress'];
    gpsLat = json['gpsLat'];
    gpsLong = json['gpsLong'];
    phoneNumber = json['phoneNumber'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['outletCode'] = outletCode;
    _data['outletName'] = outletName;
    _data['outletAddress'] = outletAddress;
    _data['gpsLat'] = gpsLat;
    _data['gpsLong'] = gpsLong;
    _data['phoneNumber'] = phoneNumber;
    _data['enabled'] = enabled;
    return _data;
  }
}

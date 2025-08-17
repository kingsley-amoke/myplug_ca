class UserLocation {
  final double latitude;
  final double longitude;
  final String? address;

  UserLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory UserLocation.fromMap(Map<String, dynamic> map) => UserLocation(
        latitude: map['latitude'],
        longitude: map['longitude'],
        address: map['address'],
      );

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      };

  UserLocation copyWith(
      {double? latitude, double? longitude, String? address}) {
    return UserLocation(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address);
  }
}

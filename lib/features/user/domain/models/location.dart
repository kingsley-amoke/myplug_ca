class UserLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? state;

  UserLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.state,
  });

  factory UserLocation.fromMap(Map<String, dynamic> map) => UserLocation(
        latitude: map['latitude'],
        longitude: map['longitude'],
        address: map['address'],
        state: map['state'],
      );

  Map<String, dynamic> toMap() => {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'state': state,
      };

  UserLocation copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? state,
  }) {
    return UserLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      state: state ?? this.state,
    );
  }
}

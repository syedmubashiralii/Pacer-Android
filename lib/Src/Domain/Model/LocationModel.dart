class LocationModel {
  final String id;
  final String name;
  final String type;
  final String address;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}

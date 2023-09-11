class PlaceModel {
  final String id;
  final String placeName;
  final String placeAddress;
  final double latitude;
  final double longitude;
  final String category;
  final String icon;

  PlaceModel({
    required this.id,
    required this.placeName,
    required this.placeAddress,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.icon,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'],
      placeName: json['placename'],
      placeAddress: json['placeaddress'],
      latitude: json['lat'],
      longitude: json['lng'],
      category: json['category'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placename': placeName,
      'placeaddress': placeAddress,
      'lat': latitude,
      'lng': longitude,
      'category': category,
      'icon': icon,
    };
  }
}

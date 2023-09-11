class TrackModel {
  final String timestamp;
  final int steps;
  final int floor;
  final double accuracy;
  final double altitude;
  final double heading;
  final bool isMocked;
  final String location;
  final double latitude;
  final double longitude;
  final double speed;
  final double speedAccuracy;
  final double distance;
  final double calories;
  final Duration duration;

  TrackModel(
      {required this.timestamp,
      required this.floor,
      required this.accuracy,
      required this.altitude,
      required this.heading,
      required this.steps,
      required this.isMocked,
      required this.location,
      required this.latitude,
      required this.longitude,
      required this.speed,
      required this.speedAccuracy,
      required this.distance,
      required this.calories,
      required this.duration});

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      timestamp: json['timestamp'],
      floor: json['floor'],
      accuracy: json['accuracy'],
      steps: json["steps"],
      altitude: json['altitude'],
      heading: json['heading'],
      isMocked: json['isMocked'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      speed: json['speed'],
      speedAccuracy: json['speedAccuracy'],
      distance: json['distance'],
      calories: json['calories'],
      duration: Duration(seconds: json['duration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'floor': floor,
      'accuracy': accuracy,
      'altitude': altitude,
      'heading': heading,
      'steps': steps,
      'isMocked': isMocked,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'speedAccuracy': speedAccuracy,
      'distance': distance,
      'calories': calories,
      'duration': duration.inSeconds
    };
  }
}

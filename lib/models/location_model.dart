class LocationModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;

  LocationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
  });

  String get displayName {
    if (admin1 != null && admin1!.isNotEmpty && admin1 != name) {
      return '$name, $admin1';
    }
    if (country != null && country!.isNotEmpty) {
      return '$name, $country';
    }
    return name;
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] is int ? json['id'] : (json['name'].hashCode),
      name: json['name'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'],
      admin1: json['admin1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'admin1': admin1,
    };
  }
}

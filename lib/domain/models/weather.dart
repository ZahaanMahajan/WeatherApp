import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String description;
  final String icon;
  final double temp;
  final double tempMin;
  final double tempMax;
  final String name;
  final String country;
  final DateTime lastUpdated;
  final double windSpeed;
  final int humidity;
  final int pressure;
  const Weather({
    required this.description,
    required this.icon,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.name,
    required this.country,
    required this.lastUpdated,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];
    final wind = json['wind'];

    return Weather(
      description: weather['description'],
      icon: weather['icon'],
      temp: main['temp'],
      tempMin: main['temp_min'],
      tempMax: main['temp_max'],
      name: '',
      country: '',
      lastUpdated: DateTime.now(),
      windSpeed: wind['speed'],
      humidity: main['humidity'],
      pressure: main['pressure'],
    );
  }

  factory Weather.initial() => Weather(
        description: '',
        icon: '',
        temp: 100.0,
        tempMin: 100.0,
        tempMax: 100.0,
        name: '',
        country: '',
        lastUpdated: DateTime(1970),
        windSpeed: 0.0,
        humidity: 0,
        pressure: 0,
      );

  @override
  List<Object> get props {
    return [
      description,
      icon,
      temp,
      tempMin,
      tempMax,
      name,
      country,
      lastUpdated,
      windSpeed,
      humidity,
      pressure,
    ];
  }

  @override
  String toString() {
    return 'Weather(description: $description, icon: $icon, temp: $temp, tempMin: $tempMin, tempMax: $tempMax, name: $name, country: $country, lastUpdated: $lastUpdated, windSpeed: $windSpeed, humidity: $humidity, pressure: $pressure)';
  }

  Weather copyWith({
    String? description,
    String? icon,
    double? temp,
    double? tempMin,
    double? tempMax,
    String? name,
    String? country,
    DateTime? lastUpdated,
    double? windSpeed,
    int? humidity,
    int? pressure,
  }) {
    return Weather(
      description: description ?? this.description,
      icon: icon ?? this.icon,
      temp: temp ?? this.temp,
      tempMin: tempMin ?? this.tempMin,
      tempMax: tempMax ?? this.tempMax,
      name: name ?? this.name,
      country: country ?? this.country,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      windSpeed: windSpeed ?? this.windSpeed,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
    );
  }
}

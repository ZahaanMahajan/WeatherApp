import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import '../../../domain/models/custom_error.dart';
import '../../../domain/models/weather.dart';
import '../../../infrastructure/repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherCubit({required this.weatherRepository})
      : super(WeatherState.initial());

  //// FETCH WEATHER
  Future<void> fetchWeather(String city) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final Weather weather = await weatherRepository.fetchWeather(city);

      emit(state.copyWith(
        status: WeatherStatus.loaded,
        weather: weather,
      ));
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: WeatherStatus.error,
        error: e,
      ));
    }
  }

  Future<void> fetchWeatherByLocation() async {
    try {
      emit(state.copyWith(status: WeatherStatus.loading));

      bool serviceEnabled;
      LocationPermission permission;

      // Check if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = await weatherRepository.getLocationName(position);
      final weather = await weatherRepository.fetchWeather(location);

      emit(state.copyWith(
        status: WeatherStatus.loaded,
        weather: weather,
      ));
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: WeatherStatus.error,
        error: e,
      ));
    }
  }
}

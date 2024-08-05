import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:weatherapp/application/cubits/weather/weather_cubit.dart';
import 'package:weatherapp/presentation/pages/home/search_page.dart';
import 'package:weatherapp/presentation/widgets/error_dialog.dart';

import '../../../domain/constants/constants.dart';
import '../../../application/cubits/temp_settings/temp_settings_cubit.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchWeatherForCurrentLocation();
  }

  Future<void> _fetchWeatherForCurrentLocation() async {
    context.read<WeatherCubit>().fetchWeatherByLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _showWeather(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Weather',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            final city = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );

            if (city != null) {
              if (!context.mounted) return;
              context.read<WeatherCubit>().fetchWeather(city);
            }
          },
          icon: const Icon(Icons.search),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;

    if (tempUnit == TempUnit.fahrenheit) {
      return '${((temperature * 9 / 5) + 32).toStringAsFixed(0)}℉';
    }

    return '${temperature.toStringAsFixed(0)}℃';
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
    );
  }

  Widget formatText(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: const TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, "Something went wrong, try again!");
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }

        if (state.status == WeatherStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == WeatherStatus.error && state.weather.name == '') {
          return const Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }
        return Scaffold(
          body: Column(
            children: [
              /*===== Temperatur Card =====*/
              SizedBox(
                height: 280,
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 36,
                      ),
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF67E1D2),
                            Color(0xFF54A8FF),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 50,
                      height: 130,
                      child: Image.asset('assets/weather.png'),
                    ),
                    Positioned(
                      top: 50,
                      right: 60,
                      child: Text(
                        showTemperature(state.weather.temp),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 70,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 50,
                      bottom: 70,
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          state.weather.name,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      bottom: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            TimeOfDay.fromDateTime(state.weather.lastUpdated)
                                .format(context),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${state.weather.country})',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "More Info",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(
                              Icons.air,
                              color: Colors.blue,
                              size: 42,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'WIND',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${state.weather.windSpeed.toStringAsFixed(1)} km/h',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(
                              Icons.invert_colors,
                              color: Colors.blue,
                              size: 42,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Humidity',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${state.weather.humidity}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(
                              Icons.line_weight,
                              color: Colors.blue,
                              size: 42,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Pressure',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${state.weather.pressure} hPa',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//Column(
//  children: [
//    Text(
//      showTemperature(state.weather.tempMax),
//      style: const TextStyle(fontSize: 16.0),
//    ),
//    const SizedBox(height: 10.0),
//    Text(
//      showTemperature(state.weather.tempMin),
//      style: const TextStyle(fontSize: 16.0),
//    ),
//  ],
//),



/*
 ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              state.weather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(state.weather.lastUpdated)
                      .format(context),
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(width: 10.0),
                Text(
                  '(${state.weather.country})',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            const SizedBox(height: 60.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showTemperature(state.weather.temp),
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20.0),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 3,
                  child: formatText(state.weather.description),
                ),
              ],
            ),
          ],
        );

 */



/*
 
Column(
                      children: [
                        const Icon(
                          Icons.air,
                          color: Colors.blue,
                          size: 42,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'WIND',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${state.weather.pressure}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    );
 */

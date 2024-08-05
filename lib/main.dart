import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/application/bloc/auth/auth_bloc.dart';
import 'package:weatherapp/application/cubits/weather/weather_cubit.dart';
import 'package:weatherapp/firebase_options.dart';
import 'package:weatherapp/infrastructure/repositories/auth_repository.dart';
import 'package:weatherapp/presentation/pages/splash.dart';
import 'package:weatherapp/infrastructure/services/weather_api_services.dart';
import 'package:http/http.dart' as http;
import 'application/cubits/temp_settings/temp_settings_cubit.dart';
import 'infrastructure/repositories/weather_repository.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => WeatherRepository(
              weatherApiServices:
                  WeatherApiServices(httpClient: http.Client())),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<WeatherCubit>(
            create: (context) => WeatherCubit(
                weatherRepository: context.read<WeatherRepository>()),
          ),
          BlocProvider<TempSettingsCubit>(
            create: (context) => TempSettingsCubit(),
          ),
        ],
        child: const MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          home: Splash(),
        ),
      ),
    );
  }
}

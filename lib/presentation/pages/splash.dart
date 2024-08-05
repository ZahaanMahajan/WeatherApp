
import 'package:flutter/material.dart';
import 'package:weatherapp/infrastructure/repositories/auth_repository.dart';
import 'package:weatherapp/presentation/pages/home/home_page.dart';
import 'package:weatherapp/presentation/pages/auth/signup_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _navigateBasedOnAuthStatus();
  }

  void _navigateBasedOnAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = _authRepository.currentUser;
    if (user != null) {
      // User is signed in, navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      // User is not signed in, navigate to sign-up page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUp(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/weather.png',
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}

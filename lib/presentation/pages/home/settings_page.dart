import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/application/bloc/auth/auth_bloc.dart';
import 'package:weatherapp/application/bloc/auth/auth_event.dart';
import 'package:weatherapp/presentation/pages/auth/signup_page.dart';

import '../../../application/cubits/temp_settings/temp_settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Temperature Unit'),
              subtitle: const Text('Celsius/Fahrenheit (Default: Celsius)'),
              trailing: Switch(
                value: context.watch<TempSettingsCubit>().state.tempUnit ==
                    TempUnit.celsius,
                onChanged: (_) {
                  context.read<TempSettingsCubit>().toggleTempUnit();
                },
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              trailing: IconButton(
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignUp()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

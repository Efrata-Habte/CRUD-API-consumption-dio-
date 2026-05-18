import 'package:crud_api_consumption_dio/blocs/country/country_bloc.dart';
import 'package:crud_api_consumption_dio/blocs/country/country_event.dart';
import 'package:crud_api_consumption_dio/screens/home_screen.dart';
import 'package:crud_api_consumption_dio/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CountryBloc()..add(const LoadCountries()),
      child: MaterialApp(
        title: 'Atlas Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            surface: AppColors.surface,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Roboto', // Premium core typography fallback
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            iconTheme: IconThemeData(color: AppColors.textDark),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}


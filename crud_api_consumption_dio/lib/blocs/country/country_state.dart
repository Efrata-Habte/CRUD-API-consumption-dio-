import 'package:crud_api_consumption_dio/models/country.dart';
import 'package:flutter/foundation.dart';

@immutable
class CountryState {
  final List<Country> countries;
  final int visibleCount;
  final bool isLoading;
  final String? errorMessage;
  final bool operationSuccess;
  final String? successMessage;
  final String? deletedCountryName;
  final String? lastAction;

  const CountryState({
    required this.countries,
    required this.visibleCount,
    required this.isLoading,
    this.errorMessage,
    required this.operationSuccess,
    this.successMessage,
    this.deletedCountryName,
    this.lastAction,
  });

  factory CountryState.initial() {
    return const CountryState(
      countries: [],
      visibleCount: 10,
      isLoading: false,
      errorMessage: null,
      operationSuccess: false,
      successMessage: null,
      deletedCountryName: null,
      lastAction: null,
    );
  }

  // Getters for pagination (matching the properties of the old provider)
  List<Country> get visibleCountries => countries.take(visibleCount).toList();
  int get totalCount => countries.length;
  bool get hasMore => visibleCount < countries.length;
  bool get canShowLess => visibleCount > 10;

  CountryState copyWith({
    List<Country>? countries,
    int? visibleCount,
    bool? isLoading,
    String? errorMessage,
    bool? operationSuccess,
    String? successMessage,
    String? deletedCountryName,
    String? lastAction,
  }) {
    return CountryState(
      countries: countries ?? this.countries,
      visibleCount: visibleCount ?? this.visibleCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // allows clearing error by setting to null or resetting explicitly
      operationSuccess: operationSuccess ?? this.operationSuccess,
      successMessage: successMessage ?? this.successMessage,
      deletedCountryName: deletedCountryName ?? this.deletedCountryName,
      lastAction: lastAction ?? this.lastAction,
    );
  }
}

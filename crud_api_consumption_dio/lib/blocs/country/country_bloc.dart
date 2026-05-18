import 'package:crud_api_consumption_dio/blocs/country/country_event.dart';
import 'package:crud_api_consumption_dio/blocs/country/country_state.dart';
import 'package:crud_api_consumption_dio/models/country.dart';
import 'package:crud_api_consumption_dio/models/currency.dart';
import 'package:crud_api_consumption_dio/models/name.dart';
import 'package:crud_api_consumption_dio/models/native_name.dart';
import 'package:crud_api_consumption_dio/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc() : super(CountryState.initial()) {
    on<LoadCountries>(_onLoadCountries);
    on<LoadSingleCountry>(_onLoadSingleCountry);
    on<LoadMoreCountries>(_onLoadMoreCountries);
    on<ShowFewerCountries>(_onShowFewerCountries);
    on<CreateCountry>(_onCreateCountry);
    on<UpdateCountry>(_onUpdateCountry);
    on<DeleteCountry>(_onDeleteCountry);
    on<ClearError>(_onClearError);
  }

  Future<void> _onLoadCountries(
    LoadCountries event,
    Emitter<CountryState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      operationSuccess: false,
      deletedCountryName: null,
      lastAction: null,
    ));

    try {
      final countries = await ApiService.getCountries();
      emit(state.copyWith(
        countries: countries,
        visibleCount: 10,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _onLoadSingleCountry(
    LoadSingleCountry event,
    Emitter<CountryState> emit,
  ) async {
    if (event.name.trim().isEmpty) {
      add(const LoadCountries());
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      operationSuccess: false,
      deletedCountryName: null,
      lastAction: null,
    ));

    try {
      final country = await ApiService.getCountry(event.name.trim());
      emit(state.copyWith(
        countries: [country],
        visibleCount: 10,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void _onLoadMoreCountries(
    LoadMoreCountries event,
    Emitter<CountryState> emit,
  ) {
    final nextVisible = state.visibleCount + 10;
    emit(state.copyWith(
      visibleCount: nextVisible > state.countries.length
          ? state.countries.length
          : nextVisible,
    ));
  }

  void _onShowFewerCountries(
    ShowFewerCountries event,
    Emitter<CountryState> emit,
  ) {
    emit(state.copyWith(visibleCount: 10));
  }

  Future<void> _onCreateCountry(
    CreateCountry event,
    Emitter<CountryState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      operationSuccess: false,
    ));

    final newCountry = Country(
      name: Name(
        common: event.commonName,
        official: event.officialName,
        nativeName: event.nativeLangCode.isNotEmpty
            ? {
                event.nativeLangCode: NativeName(
                  official: event.nativeOfficial,
                  common: event.nativeCommon,
                ),
              }
            : {},
      ),
      currency: event.currencyCode.isNotEmpty
          ? {
              event.currencyCode: Currency(
                name: event.currencyName,
                symbol: event.currencySymbol,
              ),
            }
          : {},
      capitals: event.capital.isNotEmpty ? [event.capital] : [],
    );

    try {
      await ApiService.postCountry(newCountry);
      // Since it's a client-side simulated mutation, we prepend to local list:
      final updatedCountries = [newCountry, ...state.countries];
      emit(state.copyWith(
        countries: updatedCountries,
        isLoading: false,
        operationSuccess: true,
        lastAction: 'create',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _onUpdateCountry(
    UpdateCountry event,
    Emitter<CountryState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      operationSuccess: false,
    ));

    final updatedCountry = Country(
      name: Name(
        common: event.commonName,
        official: event.officialName,
        nativeName: event.nativeLangCode.isNotEmpty
            ? {
                event.nativeLangCode: NativeName(
                  official: event.nativeOfficial,
                  common: event.nativeCommon,
                ),
              }
            : {},
      ),
      currency: event.currencyCode.isNotEmpty
          ? {
              event.currencyCode: Currency(
                name: event.currencyName,
                symbol: event.currencySymbol,
              ),
            }
          : {},
      capitals: event.capital.isNotEmpty ? [event.capital] : [],
    );

    final oldCountryIndex = state.countries.indexWhere(
      (c) => c.name.common.toLowerCase() == event.oldCommonName.toLowerCase(),
    );

    if (oldCountryIndex == -1) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Country "${event.oldCommonName}" not found locally.',
      ));
      return;
    }

    try {
      final oldCountry = state.countries[oldCountryIndex];
      final patchBody = ApiService.diffJson(
        oldCountry.toJson(),
        updatedCountry.toJson(),
      );

      await ApiService.patchCountry(event.oldCommonName, patchBody);

      final updatedCountries = List<Country>.from(state.countries);
      updatedCountries[oldCountryIndex] = updatedCountry;

      emit(state.copyWith(
        countries: updatedCountries,
        isLoading: false,
        operationSuccess: true,
        lastAction: 'update',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _onDeleteCountry(
    DeleteCountry event,
    Emitter<CountryState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      operationSuccess: false,
      deletedCountryName: null,
    ));

    try {
      await ApiService.deleteCountry(event.commonName);

      final updatedCountries = state.countries
          .where((c) =>
              c.name.common.toLowerCase() != event.commonName.toLowerCase())
          .toList();

      emit(state.copyWith(
        countries: updatedCountries,
        isLoading: false,
        operationSuccess: true,
        deletedCountryName: event.commonName,
        lastAction: 'delete',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void _onClearError(
    ClearError event,
    Emitter<CountryState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }
}

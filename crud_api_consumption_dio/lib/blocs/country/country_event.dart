import 'package:flutter/foundation.dart';

@immutable
abstract class CountryEvent {
  const CountryEvent();
}

class LoadCountries extends CountryEvent {
  const LoadCountries();
}

class LoadSingleCountry extends CountryEvent {
  final String name;

  const LoadSingleCountry(this.name);
}

class LoadMoreCountries extends CountryEvent {
  const LoadMoreCountries();
}

class ShowFewerCountries extends CountryEvent {
  const ShowFewerCountries();
}

class CreateCountry extends CountryEvent {
  final String commonName;
  final String officialName;
  final String nativeLangCode;
  final String nativeOfficial;
  final String nativeCommon;
  final String currencyCode;
  final String currencyName;
  final String currencySymbol;
  final String capital;

  const CreateCountry({
    required this.commonName,
    required this.officialName,
    required this.nativeLangCode,
    required this.nativeOfficial,
    required this.nativeCommon,
    required this.currencyCode,
    required this.currencyName,
    required this.currencySymbol,
    required this.capital,
  });
}

class UpdateCountry extends CountryEvent {
  final String oldCommonName;
  final String commonName;
  final String officialName;
  final String nativeLangCode;
  final String nativeOfficial;
  final String nativeCommon;
  final String currencyCode;
  final String currencyName;
  final String currencySymbol;
  final String capital;

  const UpdateCountry({
    required this.oldCommonName,
    required this.commonName,
    required this.officialName,
    required this.nativeLangCode,
    required this.nativeOfficial,
    required this.nativeCommon,
    required this.currencyCode,
    required this.currencyName,
    required this.currencySymbol,
    required this.capital,
  });
}

class DeleteCountry extends CountryEvent {
  final String commonName;

  const DeleteCountry(this.commonName);
}

class ClearError extends CountryEvent {
  const ClearError();
}

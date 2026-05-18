import 'dart:convert';

import 'package:crud_api_consumption_dio/models/country.dart';
import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio();

  static const String _allUrl =
      'https://restcountries.com/v3.1/all?fields=name,capital,currencies';
  static const String _nameUrl = 'https://restcountries.com/v3.1/name/';

  static Future<List<Country>> getCountries() async {
    try {
      final response = await _dio.get(_allUrl);
      if (response.statusCode == 200) {
        final List<dynamic> json = response.data;
        return json.map((e) => Country.fromJson(e)).toList();
      }
      throw Exception('Failed to load countries (${response.statusCode})');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode != null) {
        throw Exception('Failed to load countries ($statusCode)');
      }
      throw Exception('Failed to load countries: ${e.message}');
    }
  }

  static Future<Country> getCountry(String name) async {
    try {
      final url = '$_nameUrl${Uri.encodeComponent(name)}?fields=name,capital,currencies';
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> json = response.data;
        return Country.fromJson(json.first);
      }
      throw Exception('Country "$name" not found (${response.statusCode})');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode != null) {
        throw Exception('Country "$name" not found ($statusCode)');
      }
      throw Exception('Country "$name" not found: ${e.message}');
    }
  }

  static Future<void> postCountry(Country country) async {
    try {
      await _dio.post(
        _allUrl,
        data: country.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (_) {}
  }

  static Future<void> patchCountry(
    String oldName,
    Map<String, dynamic> patchBody,
  ) async {
    try {
      await _dio.patch(
        '$_nameUrl${Uri.encodeComponent(oldName)}',
        data: patchBody,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (_) {}
  }

  static Future<void> deleteCountry(String name) async {
    try {
      await _dio.delete(
        '$_nameUrl${Uri.encodeComponent(name)}',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (_) {}
  }

  static Map<String, dynamic> diffJson(
    Map<String, dynamic> oldMap,
    Map<String, dynamic> newMap,
  ) {
    final diff = <String, dynamic>{};
    newMap.forEach((key, newValue) {
      final oldValue = oldMap[key];
      if (newValue is Map<String, dynamic> && oldValue is Map<String, dynamic>) {
        final nested = diffJson(oldValue, newValue);
        if (nested.isNotEmpty) diff[key] = nested;
      } else if (jsonEncode(newValue) != jsonEncode(oldValue)) {
        diff[key] = newValue;
      }
    });
    return diff;
  }

  static Map<String, dynamic> deepMerge(
    Map<String, dynamic> base,
    Map<String, dynamic> overrides,
  ) {
    final result = Map<String, dynamic>.from(base);
    overrides.forEach((key, value) {
      if (value is Map<String, dynamic> && result[key] is Map<String, dynamic>) {
        result[key] = deepMerge(result[key] as Map<String, dynamic>, value);
      } else {
        result[key] = value;
      }
    });
    return result;
  }
}
import 'package:flutter_test/flutter_test.dart';
import 'package:crud_api_consumption_dio/blocs/country/country_state.dart';

void main() {
  test('CountryState initial status and pagination getters test', () {
    final state = CountryState.initial();
    
    expect(state.countries, isEmpty);
    expect(state.visibleCount, 10);
    expect(state.isLoading, false);
    expect(state.errorMessage, isNull);
    expect(state.operationSuccess, false);
    
    // Pagination getters
    expect(state.visibleCountries, isEmpty);
    expect(state.totalCount, 0);
    expect(state.hasMore, false);
    expect(state.canShowLess, false);
  });
}

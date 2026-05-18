import 'package:crud_api_consumption_dio/blocs/country/country_bloc.dart';
import 'package:crud_api_consumption_dio/blocs/country/country_event.dart';
import 'package:crud_api_consumption_dio/blocs/country/country_state.dart';
import 'package:crud_api_consumption_dio/models/country.dart';
import 'package:crud_api_consumption_dio/screens/country_form_screen.dart';
import 'package:crud_api_consumption_dio/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _delete(BuildContext context, String commonName) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 20,
              offset: Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.warning,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Remove from Atlas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Are you sure you want to permanently delete "$commonName"? This record will be erased immediately from your local database.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.borderLight, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text(
                      'Keep Country',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text(
                      'Confirm Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (confirmed != true || !context.mounted) return;

    context.read<CountryBloc>().add(DeleteCountry(commonName));
  }

  Future<void> _openCreate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CountryFormScreen(mode: FormMode.create),
      ),
    );
  }

  Future<void> _openUpdate(BuildContext context, Country country) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CountryFormScreen(
          mode: FormMode.update,
          existingCountry: country,
        ),
      ),
    );
  }

  Widget _buildDashboardHero(CountryState state) {
    final totalExplored = state.countries.length;
    final totalCapitals = state.countries.where((c) => c.capitals.isNotEmpty).length;
    final totalCurrencies = state.countries
        .map((c) => c.currency.keys)
        .expand((keys) => keys)
        .toSet()
        .length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ATLAS EXPLORER',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Explore the Globe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.sync_rounded, color: Colors.white, size: 22),
                    tooltip: 'Refresh Database',
                    onPressed: () {
                      _searchCtrl.clear();
                      context.read<CountryBloc>().add(const LoadCountries());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatBadge('Countries', totalExplored.toString(), Icons.public_rounded),
                _buildStatBadge('Capitals', totalCapitals.toString(), Icons.account_balance_rounded),
                _buildStatBadge('Currencies', totalCurrencies.toString(), Icons.payments_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white60, size: 18),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: _searchCtrl,
        onSubmitted: (val) {
          context.read<CountryBloc>().add(LoadSingleCountry(val));
        },
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: 'Search country name (e.g. Canada)...',
          hintStyle: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted, size: 18),
                  onPressed: () {
                    _searchCtrl.clear();
                    context.read<CountryBloc>().add(const LoadCountries());
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (val) {
          if (val.isEmpty) {
            context.read<CountryBloc>().add(const LoadCountries());
          }
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, Country country) {
    final currencies = country.currency.entries
        .map((e) => '${e.value.name} (${e.value.symbol})')
        .join(', ');

    final String firstLetter = country.name.common.isNotEmpty
        ? country.name.common[0].toUpperCase()
        : '?';

    final firstLangCode = country.name.nativeName.keys.firstOrNull;
    final avatarStyle = DesignSystem.getAvatarStyle(country.name.common);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: AppStyles.boxDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _openUpdate(context, country),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: avatarStyle.gradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          firstLetter,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: avatarStyle.textColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  country.name.common,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (firstLangCode != null) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    firstLangCode.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            country.name.official,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_note_rounded, color: AppColors.textMuted, size: 24),
                          tooltip: 'Edit Info',
                          onPressed: () => _openUpdate(context, country),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.warning, size: 20),
                          tooltip: 'Delete',
                          onPressed: () => _delete(context, country.name.common),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    DesignSystem.buildTag(
                      icon: Icons.location_city_rounded,
                      label: country.capitals.isEmpty
                          ? 'No Capital'
                          : country.capitals.join(', '),
                      baseColor: AppColors.secondary,
                    ),
                    DesignSystem.buildTag(
                      icon: Icons.payments_rounded,
                      label: currencies.isEmpty ? 'No Currency' : currencies,
                      baseColor: AppColors.accent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationPanel(BuildContext context, CountryState state) {
    final bloc = context.read<CountryBloc>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(color: Colors.grey.shade100, thickness: 1.2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Viewing ${state.visibleCountries.length} of ${state.totalCount}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              Expanded(
                child: Divider(color: Colors.grey.shade100, thickness: 1.2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.canShowLess)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primary, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => bloc.add(const ShowFewerCountries()),
                      icon: const Icon(Icons.keyboard_arrow_up_rounded, color: AppColors.primary, size: 20),
                      label: const Text(
                        'Show Less',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              if (state.hasMore)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => bloc.add(const LoadMoreCountries()),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20),
                      label: const Text(
                        'Load More',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<CountryBloc, CountryState>(
            builder: (ctx, state) => _buildDashboardHero(state),
          ),
          _buildSearchBar(context),
          Expanded(
            child: BlocConsumer<CountryBloc, CountryState>(
              listener: (context, state) {
                if (state.operationSuccess && state.lastAction == 'delete') {
                  final deletedName = state.deletedCountryName ?? 'Country';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '"$deletedName" removed from Atlas.',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(20),
                    ),
                  );
                } else if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: AppColors.warning,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                  context.read<CountryBloc>().add(const ClearError());
                }
              },
              builder: (context, state) {
                if (state.isLoading && state.countries.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 3.5,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Mapping the globe...',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.warning,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Connection Failed',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              height: 1.4,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            onPressed: () {
                              context.read<CountryBloc>().add(const ClearError());
                              context.read<CountryBloc>().add(const LoadCountries());
                            },
                            child: const Text(
                              'Retry Connection',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state.countries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.borderLight,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.map_rounded,
                            color: AppColors.textMuted,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Countries Discovered',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Try searching for another name or register one.',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final visibleCountries = state.visibleCountries;

                return Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.only(bottom: 96, top: 4),
                      itemCount: visibleCountries.length + 1,
                      itemBuilder: (ctx, i) {
                        if (i == visibleCountries.length) {
                          if (state.totalCount <= 1) {
                            return const SizedBox.shrink();
                          }
                          return _buildPaginationPanel(ctx, state);
                        }
                        return _buildCard(ctx, visibleCountries[i]);
                      },
                    ),
                    if (state.isLoading)
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          color: AppColors.primary,
                          backgroundColor: Colors.transparent,
                          minHeight: 2.5,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        elevation: 4,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onPressed: () => _openCreate(context),
        icon: const Icon(Icons.add_location_alt_rounded, size: 20, color: Colors.white),
        label: const Text(
          'Add Country',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}

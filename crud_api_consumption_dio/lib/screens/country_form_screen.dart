import 'package:crud_api_consumption_dio/blocs/country/country_bloc.dart';
import 'package:crud_api_consumption_dio/blocs/country/country_event.dart';
import 'package:crud_api_consumption_dio/blocs/country/country_state.dart';
import 'package:crud_api_consumption_dio/models/country.dart';
import 'package:crud_api_consumption_dio/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FormMode { create, update }

class CountryFormScreen extends StatefulWidget {
  final FormMode mode;
  final Country? existingCountry;

  const CountryFormScreen({
    super.key,
    required this.mode,
    this.existingCountry,
  });

  @override
  State<CountryFormScreen> createState() => _CountryFormScreenState();
}

class _CountryFormScreenState extends State<CountryFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _commonName;
  late final TextEditingController _officialName;
  late final TextEditingController _nativeLangCode;
  late final TextEditingController _nativeOfficial;
  late final TextEditingController _nativeCommon;
  late final TextEditingController _currencyCode;
  late final TextEditingController _currencyName;
  late final TextEditingController _currencySymbol;
  late final TextEditingController _capital;

  @override
  void initState() {
    super.initState();
    final c = widget.existingCountry;

    _commonName = TextEditingController(text: c?.name.common ?? '');
    _officialName = TextEditingController(text: c?.name.official ?? '');

    final firstNative = c?.name.nativeName.entries.firstOrNull;
    _nativeLangCode = TextEditingController(text: firstNative?.key ?? '');
    _nativeOfficial =
        TextEditingController(text: firstNative?.value.official ?? '');
    _nativeCommon =
        TextEditingController(text: firstNative?.value.common ?? '');

    final firstCurrency = c?.currency.entries.firstOrNull;
    _currencyCode = TextEditingController(text: firstCurrency?.key ?? '');
    _currencyName =
        TextEditingController(text: firstCurrency?.value.name ?? '');
    _currencySymbol =
        TextEditingController(text: firstCurrency?.value.symbol ?? '');

    _capital = TextEditingController(
      text: (c?.capitals.isNotEmpty ?? false) ? c!.capitals.first : '',
    );

    for (final ctrl in [
      _commonName, _officialName, _nativeLangCode,
      _nativeOfficial, _nativeCommon, _currencyCode,
      _currencyName, _currencySymbol, _capital
    ]) {
      ctrl.addListener(_rebuildOnInput);
    }
  }

  void _rebuildOnInput() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final ctrl in [
      _commonName, _officialName, _nativeLangCode,
      _nativeOfficial, _nativeCommon, _currencyCode,
      _currencyName, _currencySymbol, _capital,
    ]) {
      ctrl.removeListener(_rebuildOnInput);
      ctrl.dispose();
    }
    super.dispose();
  }


  void _submit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please correct validation errors on the form.'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final isCreate = widget.mode == FormMode.create;

    if (isCreate) {
      context.read<CountryBloc>().add(
        CreateCountry(
          commonName: _commonName.text.trim(),
          officialName: _officialName.text.trim(),
          nativeLangCode: _nativeLangCode.text.trim(),
          nativeOfficial: _nativeOfficial.text.trim(),
          nativeCommon: _nativeCommon.text.trim(),
          currencyCode: _currencyCode.text.trim(),
          currencyName: _currencyName.text.trim(),
          currencySymbol: _currencySymbol.text.trim(),
          capital: _capital.text.trim(),
        ),
      );
    } else {
      context.read<CountryBloc>().add(
        UpdateCountry(
          oldCommonName: widget.existingCountry!.name.common,
          commonName: _commonName.text.trim(),
          officialName: _officialName.text.trim(),
          nativeLangCode: _nativeLangCode.text.trim(),
          nativeOfficial: _nativeOfficial.text.trim(),
          nativeCommon: _nativeCommon.text.trim(),
          currencyCode: _currencyCode.text.trim(),
          currencyName: _currencyName.text.trim(),
          currencySymbol: _currencySymbol.text.trim(),
          capital: _capital.text.trim(),
        ),
      );
    }
  }

  Widget _buildPreviewCard() {
    final common = _commonName.text.trim().isEmpty ? 'Country Name' : _commonName.text.trim();
    final official = _officialName.text.trim().isEmpty ? 'Official Name Designation' : _officialName.text.trim();
    final capital = _capital.text.trim().isEmpty ? 'Not Specified' : _capital.text.trim();
    
    String currencyStr = 'No Currency';
    if (_currencyName.text.trim().isNotEmpty || _currencyCode.text.trim().isNotEmpty) {
      final code = _currencyCode.text.trim().isEmpty ? 'CUR' : _currencyCode.text.trim().toUpperCase();
      final name = _currencyName.text.trim().isEmpty ? 'Currency Unit' : _currencyName.text.trim();
      final symbol = _currencySymbol.text.trim().isEmpty ? '¤' : _currencySymbol.text.trim();
      currencyStr = '$code: $name ($symbol)';
    }

    final String firstLetter = common.isNotEmpty ? common[0].toUpperCase() : '?';
    final avatarStyle = DesignSystem.getAvatarStyle(common);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: AppStyles.boxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
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
                      Text(
                        common,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        official,
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
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                DesignSystem.buildTag(
                  icon: Icons.location_city_rounded,
                  label: capital,
                  baseColor: AppColors.secondary,
                ),
                DesignSystem.buildTag(
                  icon: Icons.payments_rounded,
                  label: currencyStr,
                  baseColor: AppColors.accent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.boxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8, bottom: 16),
            child: Divider(color: AppColors.borderLight, height: 1, thickness: 1.2),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController ctrl,
    required String label,
    required IconData icon,
    String? hint,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: const TextStyle(
            color: AppColors.textMuted,
            fontWeight: FontWeight.normal,
          ),
          hintStyle: TextStyle(
            color: AppColors.textMuted.withOpacity(0.4),
            fontSize: 13,
          ),
          prefixIcon: Icon(icon, color: AppColors.textMuted, size: 18),
          suffixIcon: ctrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted, size: 16),
                  onPressed: () => ctrl.clear(),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderLight, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderLight, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF94A3B8), width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.warning, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.warning, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCreate = widget.mode == FormMode.create;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isCreate ? 'New Country' : 'Update Country',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textDark,
            letterSpacing: -0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<CountryBloc, CountryState>(
        listener: (context, state) {
          if (state.operationSuccess &&
              (state.lastAction == 'create' || state.lastAction == 'update')) {
            final message = state.lastAction == 'create'
                ? 'Country successfully discovered and registered!'
                : 'Country modifications saved!';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(20),
              ),
            );
            Navigator.pop(context, true);
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.warning,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
            context.read<CountryBloc>().add(const ClearError());
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 12, bottom: 48),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPreviewCard(),
                      const SizedBox(height: 12),

                      // Section 1: Geography
                      _buildSectionCard(
                        title: 'Geography',
                        icon: Icons.public_rounded,
                        children: [
                          _field(
                            ctrl: _commonName,
                            label: 'Common Name',
                            hint: 'e.g. Canada',
                            icon: Icons.travel_explore_rounded,
                            required: true,
                          ),
                          _field(
                            ctrl: _officialName,
                            label: 'Official Name',
                            hint: 'e.g. Dominion of Canada',
                            icon: Icons.gavel_rounded,
                            required: true,
                          ),
                          _field(
                            ctrl: _capital,
                            label: 'Capital City',
                            hint: 'e.g. Ottawa',
                            icon: Icons.location_city_rounded,
                          ),
                        ],
                      ),

                      // Section 2: Native Identity
                      _buildSectionCard(
                        title: 'Identity & Language',
                        icon: Icons.translate_rounded,
                        children: [
                          _field(
                            ctrl: _nativeLangCode,
                            label: 'Language ISO Code',
                            hint: 'e.g. eng, fra',
                            icon: Icons.code_rounded,
                          ),
                          _field(
                            ctrl: _nativeOfficial,
                            label: 'Native Official Name',
                            hint: 'e.g. Dominion of Canada',
                            icon: Icons.translate_rounded,
                          ),
                          _field(
                            ctrl: _nativeCommon,
                            label: 'Native Common Name',
                            hint: 'e.g. Canada',
                            icon: Icons.font_download_rounded,
                          ),
                        ],
                      ),

                      // Section 3: Finance
                      _buildSectionCard(
                        title: 'Finance & Currencies',
                        icon: Icons.payments_outlined,
                        children: [
                          _field(
                            ctrl: _currencyCode,
                            label: 'Currency ISO Code',
                            hint: 'e.g. CAD',
                            icon: Icons.monetization_on_outlined,
                          ),
                          _field(
                            ctrl: _currencyName,
                            label: 'Currency Name',
                            hint: 'e.g. Canadian dollar',
                            icon: Icons.savings_outlined,
                          ),
                          _field(
                            ctrl: _currencySymbol,
                            label: 'Currency Symbol',
                            hint: 'e.g. \$',
                            icon: Icons.paid_rounded,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: state.isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  isCreate ? 'Add  Country' : 'Update Country',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (state.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.2),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

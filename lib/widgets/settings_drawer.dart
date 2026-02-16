import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wish_saver/config/app_contacts.dart';
import 'package:wish_saver/l10n/app_localizations.dart';

class SettingsDrawer extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;
  final void Function(Locale) onLocaleChanged;
  final VoidCallback onHistoryTap;

  const SettingsDrawer({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
    required this.onLocaleChanged,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        child: Container(
          width: 300,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _ThemeMenuItem(
                      isDark: isDark,
                      onThemeChanged: onThemeChanged,
                    ),
                    const SizedBox(height: 12),
                    _LanguageMenuItem(
                      onLocaleChanged: onLocaleChanged,
                    ), // <- передаём сюда
                    const SizedBox(height: 12),
                    _HistoryMenuItem(onTap: onHistoryTap),
                    const SizedBox(height: 12),
                    _ContactMenuItem(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // version label (bottom)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final packageInfo = snapshot.data;
                    final versionText = packageInfo == null
                        ? 'Version'
                        : 'Version ${packageInfo.version}+${packageInfo.buildNumber}';

                    return Text(
                      versionText,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ... (оставляем _ThemeMenuItem, _HistoryMenuItem, _ContactMenuItem как у тебя) ...
// Ниже — обновлённый _LanguageMenuItem

class _ThemeMenuItem extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const _ThemeMenuItem({required this.isDark, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.theme,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSecondaryContainer,
            ),
          ),

          const Spacer(),

          Icon(
            Icons.light_mode,
            size: 18,
            color: colorScheme.onSecondaryContainer,
          ),
          Switch(value: isDark, onChanged: onThemeChanged),
          Icon(
            Icons.dark_mode,
            size: 18,
            color: colorScheme.onSecondaryContainer,
          ),
        ],
      ),
    );
  }
}

class _LanguageMenuItem extends StatefulWidget {
  final void Function(Locale) onLocaleChanged;

  const _LanguageMenuItem({required this.onLocaleChanged});

  @override
  State<_LanguageMenuItem> createState() => _LanguageMenuItemState();
}

class _LanguageMenuItemState extends State<_LanguageMenuItem> {
  bool _expanded = false;
  late String _selected;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Обновляем выбранную локаль каждый раз
    _selected = Localizations.localeOf(context).languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        constraints: const BoxConstraints(minHeight: 60),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// HEADER
            SizedBox(
              height: 36,
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),

            /// EXPANDED
            if (_expanded) ...[
              const SizedBox(height: 8),

              /// RU
              RadioMenuButton<String>(
                value: 'ru',
                groupValue: _selected,
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(
                    colorScheme.onSecondaryContainer,
                  ),
                ),
                onChanged: (value) {
                  if (value == null) return;

                  widget.onLocaleChanged(Locale(value));

                  setState(() {
                    _selected = value;
                    _expanded = false;
                  });

                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.russian),
              ),

              /// EN
              RadioMenuButton<String>(
                value: 'en',
                groupValue: _selected,
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(
                    colorScheme.onSecondaryContainer,
                  ),
                ),
                onChanged: (value) {
                  if (value == null) return;

                  widget.onLocaleChanged(Locale(value));

                  setState(() {
                    _selected = value;
                    _expanded = false;
                  });

                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.english),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HistoryMenuItem extends StatelessWidget {
  final VoidCallback onTap;

  const _HistoryMenuItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.history,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSecondaryContainer.withValues(alpha: 0.72),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactMenuItem extends StatelessWidget {
  const _ContactMenuItem();

  Future<void> _openUrl(BuildContext context, String rawUrl) async {
    final uri = Uri.tryParse(rawUrl);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.wrongUrl)),
      );
    }
  }

  Future<void> _openEmail(BuildContext context, String email) async {
    final uri = Uri(scheme: 'mailto', path: email);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.wrongUrl)),
      );
    }
  }

  void _showContactsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                subtitle: const Text(AppContacts.email),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _openEmail(context, AppContacts.email);
                },
              ),
              ListTile(
                leading: const Icon(Icons.telegram),
                title: const Text('Telegram'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _openUrl(context, AppContacts.telegramUrl);
                },
              ),
              ListTile(
                leading: const Icon(Icons.hub_outlined),
                title: const Text('Linktree'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _openUrl(context, AppContacts.linktreeUrl);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: Text(AppLocalizations.of(context)!.cancel),
                onTap: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showContactsSheet(context),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              AppLocalizations.of(context)!.contact,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSecondaryContainer.withValues(alpha: 0.72),
            ),
          ],
        ),
      ),
    );
  }
}

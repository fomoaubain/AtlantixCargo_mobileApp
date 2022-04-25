import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Languages/english.dart';
import 'Languages/french.dart';

import 'strings_enum.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<Strings, String>> _localizedValues = {
    'en': english(),
    'fr': french(),
  };

  String? getString(Strings key) {
    return _localizedValues[locale.languageCode]![key];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en','fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of AppLocalizations.
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

extension StateExtension on State {
  String? getString(Strings key) {
    return context.getString(key);
  }
}

extension ContextExtension on BuildContext {
  String? getString(Strings key) {
    return AppLocalizations.of(this)!.getString(key);
  }
}

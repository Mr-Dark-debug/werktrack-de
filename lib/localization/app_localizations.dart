import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'WerkTrack DE'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @worked.
  ///
  /// In en, this message translates to:
  /// **'WORKED'**
  String get worked;

  /// No description provided for @gross.
  ///
  /// In en, this message translates to:
  /// **'GROSS'**
  String get gross;

  /// No description provided for @estimatedNet.
  ///
  /// In en, this message translates to:
  /// **'EST. NET'**
  String get estimatedNet;

  /// No description provided for @projectedMonth.
  ///
  /// In en, this message translates to:
  /// **'PROJECTED MONTH'**
  String get projectedMonth;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'THIS WEEK'**
  String get thisWeek;

  /// No description provided for @residenceAllowance.
  ///
  /// In en, this message translates to:
  /// **'RESIDENCE ALLOWANCE'**
  String get residenceAllowance;

  /// No description provided for @minijob.
  ///
  /// In en, this message translates to:
  /// **'MINIJOB'**
  String get minijob;

  /// No description provided for @nextPlannedShift.
  ///
  /// In en, this message translates to:
  /// **'Next planned shift'**
  String get nextPlannedShift;

  /// No description provided for @warnings.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get warnings;

  /// No description provided for @recentWork.
  ///
  /// In en, this message translates to:
  /// **'Recent work'**
  String get recentWork;

  /// No description provided for @addWork.
  ///
  /// In en, this message translates to:
  /// **'Add Work'**
  String get addWork;

  /// No description provided for @startTimer.
  ///
  /// In en, this message translates to:
  /// **'Start Timer'**
  String get startTimer;

  /// No description provided for @planShift.
  ///
  /// In en, this message translates to:
  /// **'Plan Shift'**
  String get planShift;

  /// No description provided for @addPayslip.
  ///
  /// In en, this message translates to:
  /// **'Add Payslip'**
  String get addPayslip;

  /// No description provided for @canIWork.
  ///
  /// In en, this message translates to:
  /// **'Can I Work?'**
  String get canIWork;

  /// No description provided for @employers.
  ///
  /// In en, this message translates to:
  /// **'Employers'**
  String get employers;

  /// No description provided for @academicPeriods.
  ///
  /// In en, this message translates to:
  /// **'Academic periods'**
  String get academicPeriods;

  /// No description provided for @rulesAndSources.
  ///
  /// In en, this message translates to:
  /// **'Rules & Sources'**
  String get rulesAndSources;

  /// No description provided for @exportAndBackup.
  ///
  /// In en, this message translates to:
  /// **'Export & Backup'**
  String get exportAndBackup;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Important context'**
  String get disclaimerTitle;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'WerkTrack DE is an organisational and estimation tool. German employment, immigration, tax and social-insurance treatment can depend on individual circumstances, employment type and residence conditions. Consult the relevant authority or qualified adviser where necessary.'**
  String get disclaimer;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Know your work,\nnot just your shifts.'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Private, offline-first tracking for hours, earnings and your configured references in Germany.'**
  String get welcomeBody;

  /// No description provided for @noWorkYet.
  ///
  /// In en, this message translates to:
  /// **'No work recorded yet'**
  String get noWorkYet;

  /// No description provided for @noWorkBody.
  ///
  /// In en, this message translates to:
  /// **'Add an employer, then record a completed shift or start the timer.'**
  String get noWorkBody;

  /// No description provided for @thresholdReview.
  ///
  /// In en, this message translates to:
  /// **'Threshold exceeded — review may be required.'**
  String get thresholdReview;

  /// No description provided for @estimatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated net'**
  String get estimatedLabel;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @simulate.
  ///
  /// In en, this message translates to:
  /// **'Simulate'**
  String get simulate;

  /// No description provided for @offlineReady.
  ///
  /// In en, this message translates to:
  /// **'Works completely offline'**
  String get offlineReady;

  /// No description provided for @optionalSync.
  ///
  /// In en, this message translates to:
  /// **'Optional cloud sync'**
  String get optionalSync;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

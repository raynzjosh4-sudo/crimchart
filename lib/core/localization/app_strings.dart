import 'app_base_translations.dart';
import '../../settings/localization/localization.dart';

import '../../settings/localization/chartdialog/info_sheet_translations.dart';

class AppStrings {
  static Map<String, Map<String, String>> get _baseTranslations =>
      AppBaseTranslations.translations;

  static Map<String, Map<String, String>> get translations {
    final Map<String, Map<String, String>> merged = {};

    final locales = {
      ..._baseTranslations.keys,
      ...LandingPageTranslations.translations.keys,
      ...MobileNumberTranslations.translations.keys,
      ...CountrySelectorTranslations.translations.keys,
      ...GoogleSignInTranslations.translations.keys,
      ...NamePageTranslations.translations.keys,
      ...BirthdayPageTranslations.translations.keys,
      ...UsernamePageTranslations.translations.keys,
      ...ChartTitleTranslations.translations.keys,
      ...ProfilePictureTranslations.translations.keys,
      ...PasswordPageTranslations.translations.keys,
      ...SettingsTranslations.translations.keys,
      ...AccountPrivacyTranslations.translations.keys,
      ...BlockedTranslations.translations.keys,
      ...HideStoryTranslations.translations.keys,
      ...VisibilityOffChartTranslations.translations.keys,
      ...MessagesRepliesTranslations.translations.keys,
      ...ActivityStatusTranslations.translations.keys,
      ...DeliverRequestsTranslations.translations.keys,
      ...CommentControlsTranslations.translations.keys,
      ...PrivacySettingsMoreTranslations.translations.keys,
      ...DeepSettingsTranslations.translations.keys,
      ...InfoHelpTranslations.translations.keys,
      ...ProfileTranslations.translations.keys,
      ...EditProfileTranslations.translations.keys,
      ...PersonalInfoTranslations.translations.keys,
      ...PhotoEditTranslations.translations.keys,
      ...ChannelsTranslations.translations.keys,
      ...SearchTranslations.translations.keys,
      ...ChannelDetailsTranslations.translations.keys,
      ...ChannelPageTranslations.translations.keys,
      ...ChannelSettingsTranslations.translations.keys,
      ...PostTranslations.translations.keys,
      ...VideoTranslations.translations.keys,
      ...ChartOptionsTranslations.translations.keys,
      ...OnboardingTranslations.translations.keys,
      ...LoginTranslations.translations.keys,
      ...AccountSelectorTranslations.translations.keys,
      ...InfoSheetTranslations.translations.keys,
    };

    for (var locale in locales) {
      merged[locale] = {
        ..._baseTranslations[locale] ?? {},
        ...LandingPageTranslations.translations[locale] ?? {},
        ...MobileNumberTranslations.translations[locale] ?? {},
        ...CountrySelectorTranslations.translations[locale] ?? {},
        ...GoogleSignInTranslations.translations[locale] ?? {},
        ...NamePageTranslations.translations[locale] ?? {},
        ...BirthdayPageTranslations.translations[locale] ?? {},
        ...UsernamePageTranslations.translations[locale] ?? {},
        ...ChartTitleTranslations.translations[locale] ?? {},
        ...ProfilePictureTranslations.translations[locale] ?? {},
        ...PasswordPageTranslations.translations[locale] ?? {},
        ...SettingsTranslations.translations[locale] ?? {},
        ...AccountPrivacyTranslations.translations[locale] ?? {},
        ...BlockedTranslations.translations[locale] ?? {},
        ...HideStoryTranslations.translations[locale] ?? {},
        ...VisibilityOffChartTranslations.translations[locale] ?? {},
        ...MessagesRepliesTranslations.translations[locale] ?? {},
        ...ActivityStatusTranslations.translations[locale] ?? {},
        ...DeliverRequestsTranslations.translations[locale] ?? {},
        ...CommentControlsTranslations.translations[locale] ?? {},
        ...PrivacySettingsMoreTranslations.translations[locale] ?? {},
        ...DeepSettingsTranslations.translations[locale] ?? {},
        ...InfoHelpTranslations.translations[locale] ?? {},
        ...ProfileTranslations.translations[locale] ?? {},
        ...EditProfileTranslations.translations[locale] ?? {},
        ...PersonalInfoTranslations.translations[locale] ?? {},
        ...PhotoEditTranslations.translations[locale] ?? {},
        ...ChannelsTranslations.translations[locale] ?? {},
        ...SearchTranslations.translations[locale] ?? {},
        ...ChannelDetailsTranslations.translations[locale] ?? {},
        ...ChannelPageTranslations.translations[locale] ?? {},
        ...ChannelSettingsTranslations.translations[locale] ?? {},
        ...PostTranslations.translations[locale] ?? {},
        ...VideoTranslations.translations[locale] ?? {},
        ...ChartOptionsTranslations.translations[locale] ?? {},
        ...OnboardingTranslations.translations[locale] ?? {},
        ...LoginTranslations.translations[locale] ?? {},
        ...AccountSelectorTranslations.translations[locale] ?? {},
        ...InfoSheetTranslations.translations[locale] ?? {},
      };
    }

    return merged;
  }

  static const List<Map<String, String>> languages = [
    {'native': 'English', 'english': 'English (en) - Baseline', 'code': 'en'},
    {
      'native': 'Español',
      'english': 'Spanish (es) - Latin America & US',
      'code': 'es',
    },
    {'native': '中文', 'english': 'Mandarin Chinese (zh) - Asia', 'code': 'zh'},
    {'native': 'हिन्दी', 'english': 'Hindi (hi) - India', 'code': 'hi'},
    {
      'native': 'Français',
      'english': 'French (fr) - Europe & Africa',
      'code': 'fr',
    },
    {
      'native': 'العربية',
      'english': 'Arabic (ar) - Middle East & North Africa',
      'code': 'ar',
    },
    {
      'native': 'Kiswahili',
      'english': 'Swahili (sw) - East Africa',
      'code': 'sw',
    },
    {'native': 'Hausa', 'english': 'Hausa (ha) - West Africa', 'code': 'ha'},
    {
      'native': 'Português',
      'english': 'Portuguese (pt) - Brazil & Southern Africa',
      'code': 'pt',
    },
    {'native': 'Luganda', 'english': 'Luganda', 'code': 'lg'},
  ];
}

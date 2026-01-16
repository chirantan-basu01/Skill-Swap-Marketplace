import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_service.g.dart';

/// Keys for shared preferences
class StorageKeys {
  StorageKeys._();

  static const String onboardingSeen = 'onboarding_seen';
  static const String userTimezone = 'user_timezone';
}

/// Provider for SharedPreferences instance
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return SharedPreferences.getInstance();
}

/// Provider for checking if onboarding has been seen
@riverpod
Future<bool> onboardingSeen(OnboardingSeenRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return prefs.getBool(StorageKeys.onboardingSeen) ?? false;
}

/// Service for local storage operations
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  bool get onboardingSeen => _prefs.getBool(StorageKeys.onboardingSeen) ?? false;

  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(StorageKeys.onboardingSeen, true);
  }

  String? get userTimezone => _prefs.getString(StorageKeys.userTimezone);

  Future<void> setUserTimezone(String timezone) async {
    await _prefs.setString(StorageKeys.userTimezone, timezone);
  }

  Future<void> clear() async {
    await _prefs.clear();
  }
}

/// Provider for StorageService
@riverpod
Future<StorageService> storageService(StorageServiceRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return StorageService(prefs);
}
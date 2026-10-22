/// Run without Supabase, using the bundled sample destinations:
///
///     flutter run -d chrome --dart-define=OFFLINE_DEMO=true
const bool kOfflineDemo = bool.fromEnvironment('OFFLINE_DEMO');

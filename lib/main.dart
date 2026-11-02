import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart';
import 'app/routes.dart';
import 'core/routes/route_names.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://99ef24027a51626ad3162d6decd21399@o4512363054235648.ingest.de.sentry.io/4512363061510225'; // Замініть на ваш DSN із Sentry.io
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const VolunteerHubApp()),
  );
}

class VolunteerHubApp extends StatelessWidget {
  const VolunteerHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VolunteerHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: RouteNames.login,
      routes: AppRoutes.routes,
    );
  }
}
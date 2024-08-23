import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home101/pages/auth/formLogin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_home101/pages/auth/register.dart';
import 'package:smart_home101/pages/home/create.dart';
import 'package:smart_home101/pages/home/home.dart';
import 'package:smart_home101/pages/home/list.dart';
import 'package:smart_home101/pages/settings/list.dart';
import 'package:smart_home101/providers/locale_provider.dart';
import 'package:smart_home101/providers/user_profile_provider.dart';
import 'package:smart_home101/utils/global.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    print('Dotenv loaded successfully');
  } catch (e) {
    print('Error loading .env file: $e');
  }

  final prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey('languageCode')) {
    // เซ็ตค่าเริ่มต้นภาษาในครั้งแรกที่เปิดแอพ
    await prefs.setString('languageCode', getDeviceLocale().languageCode);
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          print(localeProvider.locale);
          return MaterialApp(
            locale: localeProvider.locale,
            title: 'Flutter Demo',
            theme: ThemeData(
              scaffoldBackgroundColor: const Color.fromRGBO(245, 245, 245, 1),
              textTheme: GoogleFonts.promptTextTheme(
                Theme.of(context).textTheme,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
              ),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('th', ''), // Thai
              Locale('en', ''), // English
            ],
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const HomeScreen();
                  } else {
                    return const FormLogin();
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            routes: {
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const FormLogin(),
              '/register': (context) => const RegisterScreen(),
              '/settings': (context) => const SettingsRoutes(),
              '/settings/home/list': (context) => const HomeListScreen(),
            },
          );
        },
      ),
    );
  }
}

class HomeRoutes extends StatelessWidget {
  const HomeRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/home':
            builder = (BuildContext _) => const HomeScreen();
            break;

          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class SettingsRoutes extends StatelessWidget {
  const SettingsRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/settings':
            builder = (BuildContext _) => const SettingsScreen();
            break;
          case '/settings/home/list':
            builder = (BuildContext _) => const HomeListScreen();
            break;

          case '/settings/home/create':
            builder = (BuildContext _) => HomeCreateScreen();
            break;

          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

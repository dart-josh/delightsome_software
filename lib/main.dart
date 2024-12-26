import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/pages/login.page.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:month_year_picker2/month_year_picker2.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppData(),
      builder: (context, snapshot) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext _context) {
    ThemeMode theme = Provider.of<AppData>(_context).themeMode;
    bool isDark = theme == ThemeMode.dark;

    return MaterialApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Delightsome Inventory',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.light_secondaryTextColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isDark ? Colors.white : Colors.black),
          ),
        ),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.dark_secondaryTextColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: theme,
      home: LoginPage(),
      builder: ((context, child) {
        return Stack(
          children: [
            child!,

            // Positioned.fill(child: NotificationCover(rootContext: _context)),

            Positioned(right: 0, child: IconButton(onPressed: () {
              if (isDark) {
            Provider.of<AppData>(context, listen: false)
                .update_themeMode(ThemeMode.light);
          } else {
            Provider.of<AppData>(context, listen: false)
                .update_themeMode(ThemeMode.dark);
          }
            }, icon: Icon(Icons.refresh),))

          ],
        );
      }),
    );
  }
}

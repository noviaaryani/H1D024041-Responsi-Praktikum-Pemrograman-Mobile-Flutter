import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'theme/app_theme.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi locale bahasa Indonesia untuk format tanggal
  await initializeDateFormatting('id_ID', null);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const LangitKuApp());
}

class LangitKuApp extends StatelessWidget {
  const LangitKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
      ],
      child: MaterialApp(
        title: 'LangitKu',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}

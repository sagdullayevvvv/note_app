import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lesson20/domain/database/favorite_history.dart';
import 'package:lesson20/domain/database/hive_box.dart';
import 'package:lesson20/weather_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.bottom,
    ],
  );
  
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteHistoryAdapter());
  await Hive.openBox<FavoriteHistory>(HiveBox.favotiteBox);
  
  
  
  await dotenv.load(fileName: '.env');
  runApp(const WeatherApp());
}


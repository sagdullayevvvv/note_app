import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lesson20/domain/api/api.dart';
import 'package:lesson20/domain/database/favorite_history.dart';
import 'package:lesson20/domain/database/hive_box.dart';
import 'package:lesson20/domain/models/coord.dart';
import 'package:lesson20/domain/models/weather_data.dart';
import 'package:lesson20/ui/resources/appbg.dart';
import 'package:lesson20/ui/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherProvider extends ChangeNotifier {
  //Хранение координат

  Coord? _coords;

  //данные о погоде

  WeatherData? _weatherData;
  WeatherData? get weatherData => _weatherData;

  //текущие данные о погоде

  Current? _current;

  //контролер поиска
  final searchController = TextEditingController();

  ///Главная функция которую мы будем запускать во FutureBuilder

  Future<WeatherData?> setUp({String? cityName}) async {
    
    cityName = (await pref).getString('city_name');
    
    _coords = await Api.getCoords(cityName: cityName ?? 'Tashkent');
    _weatherData = await Api.getWeather(_coords);
    _current = _weatherData?.current;

    setCurrentDay();
    setCurrentDayTime();
    setCurrentTime();
    setHumidity();
    setCurrentTemp();
    setWindSpeed();
    setFeelsLike();
    setWeekDay();
    getCurrentCity();

    return _weatherData;
  }
  
  //установка текущего города
  final pref = SharedPreferences.getInstance();
  //
  Future<void> setCurrentCity (BuildContext context, {String? cityName}) async{
    if (searchController.text != '') {
      cityName = searchController.text;
      (await pref).setString('city_name', cityName);
      await setUp(cityName: (await pref).getString('city_name')).then((value) => context.go(AppRoutes.home)).then((value) => searchController.clear()
      );
    }else{
      context.go(AppRoutes.home);
    }
  }

  //текущая дата
  String? currentDay;

  String setCurrentDay() {
    final getTime = (_current?.dt ?? 0) + (_weatherData?.timezoneOffset ?? 0);
    final setTime = DateTime.fromMillisecondsSinceEpoch(getTime * 1000);
    currentDay = DateFormat('MMMM d').format(setTime);
    return currentDay ?? 'Error';
  }
  
  
  String currentCity = '';
  Future<String> getCurrentCity() async{
    currentCity = (await pref).getString('city_name') ?? 'Ташкент';
    return capitalize(currentCity);
  }
 
  // текущая дата ./././

  String? currentDayTime;

  String setCurrentDayTime() {
    final getTime = (_current?.dt ?? 0) + (_weatherData?.timezoneOffset ?? 0);
    final setTime = DateTime.fromMillisecondsSinceEpoch(getTime * 1000);
    currentDayTime = DateFormat('yMd').format(setTime);
    return currentDayTime ?? 'Error';
  }
  
  //текущее время
    String? currentTime;

  String setCurrentTime() {
    final getTime = (_current?.dt ?? 0) + (_weatherData?.timezoneOffset ?? 0);
    final setTime = DateTime.fromMillisecondsSinceEpoch(getTime * 1000);
    currentTime = DateFormat('HH:mm a').format(setTime);
    return currentTime ?? 'Error';
  }
  
  //текушая иконка в зависимости от статуса погоды
  final String _weatherIconUrl = 'http://api.openweathermap.org/img/w/';
  
  String iconData(){
    return '$_weatherIconUrl${_current?.weather?[0].icon}.png';
  }
  
  //текущий статус погоды
  String currentStatus = '';
  String getCurrentStatus(){
    currentStatus = _current?.weather?[0].description ?? 'Ощибка';
    return capitalize(currentStatus);
  }
  
  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);
  
  int kelvin = -273;
  //получение температуры
  
  
  int currentTemp = 0;
  int setCurrentTemp() {
    currentTemp = ((_current?.temp ?? -kelvin) + kelvin).round();
    return currentTemp;
  }
  
  // влажность
  int humidity = 0;
  int setHumidity(){
    humidity = ((_current?.humidity ?? 0) / 1).round();
    return humidity;
  }
  
  //скорость ветра
  dynamic windSpeed = 0;
  dynamic setWindSpeed(){
    windSpeed = _current?.windSpeed ?? 0;
    return windSpeed;
  }
  
  // ощущуние температуры
  int feelsLike = 0;
  int setFeelsLike() {
    feelsLike = ((_current?.temp ?? -kelvin) + kelvin).round();
    return feelsLike;
  }
  
  //установка дней недели
  final List<String> date = [];
  List<Daily> daily = [];
  
  void setWeekDay(){
    daily = _weatherData?.daily ?? [];
    for (var i = 0; i < daily.length; i++) {
      if (i == 0 && daily.isNotEmpty) {
        date.clear();
      }
      var timeNum = daily[i].dt * 1000;
      var itemDate = DateTime.fromMillisecondsSinceEpoch(timeNum);
      var dayTime = DateFormat('EEE d').format(itemDate);
      date.add(capitalize(dayTime));
    }
  }
  
  //иконки на неделю
  String setDailyIcons(int index){
    final String getIcon = '${_weatherData?.daily?[index].weather?[0].icon}';
    final String setIcon = '$_weatherIconUrl$getIcon.png';
    return setIcon;
  }
  
  //температура на неделю
   dynamic setDailyTemp(int index){
    final dynamic dayTemp = ((_weatherData?.daily?[index].temp?.day ?? - kelvin) + kelvin).round();
    return dayTemp;
   }
   
   //скорость ветра на неделю
   
   dynamic setDailyWindSpeed(int index){
    final int dailyWindSpeed =
    (_weatherData?.daily?[index].windSpeed ?? 0).round();
    return dailyWindSpeed;
   }
   
   //время восхода
   String setSunRise(){
    final getSunTime = 
    (_current?.sunrise ?? 0) + (_weatherData?.timezoneOffset ?? 0);
    final setSunRise = DateTime.fromMillisecondsSinceEpoch(getSunTime * 1000);
    final String sunRise = DateFormat('HH:mm a').format(setSunRise);
    return sunRise;
   }
   //время заката
   String setSunSet(){
    final getSunTime = 
    (_current?.sunset ?? 0) + (_weatherData?.timezoneOffset ?? 0);
    final setSunSet = DateTime.fromMillisecondsSinceEpoch(getSunTime * 1000);
    final String sunSet = DateFormat('HH:mm a').format(setSunSet);
    return sunSet;
   }
   
   //Установка заднего фона
   String? currentBg;
   
   String setBg(){
    int id = _current?.weather?[0].id ?? -1;
    if (id == -1 || _current?.sunset == null || _current?.dt == null) {
      currentBg = AppBg.shinyDay;
    }
    
    try {
      if (_current?.sunset < _current?.dt) {
        if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyNight;
        }else if(id >= 600 && id <= 622 ){
          currentBg = AppBg.snowNight;
        }else if (id >= 701 && id <= 781 ) {
          currentBg = AppBg.fogNight;
        }else if (id == 800){
          currentBg = AppBg.shinyNight;
        }else if (id >= 801 && id <= 804){
          currentBg = AppBg.cloudyNight;
        }
      }else{
         if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyDay;
        }else if(id >= 600 && id <= 622 ){
          currentBg = AppBg.snowDay;
        } else if (id >= 701 && id <= 781 ) {
          currentBg = AppBg.fogDay;
        }else if (id == 800){
          currentBg = AppBg.shinyDay;
        }else if (id >= 801 && id <= 804){
          currentBg = AppBg.cloudyDay;
        }
      }
      
    } catch (e) {
      return AppBg.shinyDay;
    }
    return currentBg ?? AppBg.shinyDay;
  }
  
  var box = Hive.box<FavoriteHistory>(HiveBox.favotiteBox);
  
  //добавление в избранное
  Future<void> setFavorite(BuildContext context,{String? cityName}) async{
    box.add(
      FavoriteHistory(
        cityName: cityName ?? 'Error', 
        currentStatus: currentStatus, 
        humidity: '${setHumidity()}', 
        windSpeed: '$windSpeed', 
        icon: iconData(), 
        temp: '$currentTemp',
      ),
    ).then(
      (value) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: 
          Text('The city $cityName has been added to favorite list'),
        ),
      ),
    );
  }
  
  //удаление из избранного
  Future<void> delete(int index) async{
    box.deleteAt(index);
  }
}
  


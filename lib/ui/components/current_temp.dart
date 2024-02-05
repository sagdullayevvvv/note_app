import 'package:flutter/material.dart';
import 'package:lesson20/domain/providers/weather_provider.dart';
import 'package:lesson20/ui/style/app_style.dart';
import 'package:provider/provider.dart';

class CurrentTemp extends StatelessWidget {
  const CurrentTemp({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${model.currentTemp}', 
          style: AppStyle.fonstyle.copyWith(
            fontSize: 86,
            fontWeight: FontWeight.w500,
            height: 86 / 86,
          ),
        ),
        Text(
          '°C',
          style: AppStyle.fonstyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
         ),
      ],
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lesson20/domain/providers/weather_provider.dart';
import 'package:lesson20/ui/components/current_temp.dart';
import 'package:lesson20/ui/components/custom_appbar.dart';
import 'package:lesson20/ui/components/row_items.dart';
import 'package:lesson20/ui/components/sunrise_sunset_widget.dart';
import 'package:lesson20/ui/components/week_day_tems.dart';

import 'package:lesson20/ui/style/app_colors.dart';
import 'package:lesson20/ui/style/app_style.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.watch<WeatherProvider>().setUp(),
      builder: (context, snapshot) {
      switch (snapshot.connectionState){
        case ConnectionState.waiting:
        return const Center(
          child: CupertinoActivityIndicator(),
        );
        case ConnectionState.done:
        return Scaffold(
          backgroundColor: AppColors.black,
          extendBodyBehindAppBar: true,
          appBar:const CustomAppbar(),
          body: const WeatherBody(),
        );
        default:
        return const SizedBox();
       }
     }
    );
  }
}


class WeatherBody extends StatelessWidget {
  const WeatherBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return Container(
      decoration:  BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            model.setBg(),
            ),
          ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView(
        children: [
          Text(
            '${model.currentDay}',
          textAlign: TextAlign.center,
          style: AppStyle.fonstyle.copyWith(
            fontSize: 40, 
            fontWeight: FontWeight.w500,
          ),
          ),
        const SizedBox(height: 10),
        Text(
          '${model.currentDayTime} ${model.currentTime}',
          textAlign: TextAlign.center,
          style: AppStyle.fonstyle.copyWith(
            fontSize: 16, 
            fontWeight: FontWeight.w300,
          ),
          ),
           const SizedBox(height: 30),
           Image.network(
            model.iconData(),
            height: 80,
            ),
           Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              model.getCurrentStatus(), 
              textAlign: TextAlign.center,
              style: AppStyle.fonstyle.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.w700
            ),
          ),
         ),
         const CurrentTemp(),
          const SizedBox(height: 30),
          const RowItems(),
          const SizedBox(height: 15),
          const WeekDayItems(),
          const SizedBox(height: 15),
          const SunriseSunsetWidget(),
        ],
      ),
    );
  }
}
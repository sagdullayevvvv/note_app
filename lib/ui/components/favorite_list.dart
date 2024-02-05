import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lesson20/domain/database/favorite_history.dart';
import 'package:lesson20/domain/database/hive_box.dart';
import 'package:lesson20/domain/providers/weather_provider.dart';
import 'package:lesson20/ui/style/app_colors.dart';
import 'package:lesson20/ui/style/app_style.dart';
import 'package:provider/provider.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: Hive.box<FavoriteHistory>(HiveBox.favotiteBox).listenable(),
        builder: (context, value, _) {
          return ListView.separated(
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, i){
              return  Dismissible(
                key: UniqueKey(),
                onDismissed: (direction){
                  model.delete(i);
                },
                child: FavoriteCard(
                  index: i,
                  value: value,
                ),
              );
            }, 
            separatorBuilder: (context, i) => const SizedBox(height: 25), 
            itemCount: value.length,
          );
        }
      ),
    );
  }
}
class FavoriteCard extends StatelessWidget {
  const FavoriteCard({
    super.key,
    required this.index,
    required this.value,
  });
  final int index;
  final Box<FavoriteHistory> value;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)) ,
      color: AppColors.cardColor.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CurrentItems(index: index, value: value),
            WeatherItems(index: index, value: value),
          ],
        ),
      ),
    );
  }
}

class CurrentItems extends StatelessWidget {
  const CurrentItems({super.key, required this.index, required this.value,});
  
  final int index;
  final Box<FavoriteHistory> value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.getAt(index)?.cityName ?? 'Error',
          style: AppStyle.fonstyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          ),
          const SizedBox(height: 8),
          Text(
            value.getAt(index)?.currentStatus ?? 'Error',
            style: AppStyle.fonstyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              shadows: [],
            ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: 'Humidity',
                style: AppStyle.fonstyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: AppColors.white.withOpacity(0.8),
                ),
                children: [
                  TextSpan(
                    text: '${value.getAt(index)?.humidity}%',
                    style: AppStyle.fonstyle.copyWith(
                      fontSize: 16,
                      ),
                  ),
                ],
              ),
              ),
            const  SizedBox(height: 5),
                        RichText(
              text: TextSpan(
                text: 'Wind',
                style: AppStyle.fonstyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: AppColors.white.withOpacity(0.8),
                ),
                children: [
                  TextSpan(
                    text: '${value.getAt(index)?.windSpeed} km/h',
                    style: AppStyle.fonstyle.copyWith(
                      fontSize: 16,
                      ),
                  ),
                ],
              ),
              ),
      ],
    );
  }
}


class WeatherItems extends StatelessWidget {
  const WeatherItems({super.key, required this.index, required this.value});
  
  final int index;
  final Box<FavoriteHistory> value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        //Поменять на Image
       Image.network(
        '${value.getAt(index)?.icon}',
       ),
        Text(
          '${value.getAt(index)?.temp} °C',
          style: AppStyle.fonstyle.copyWith(
            fontSize: 48,
            fontWeight: FontWeight.w500,
          ),
          ),
      ],
    );
  }
}
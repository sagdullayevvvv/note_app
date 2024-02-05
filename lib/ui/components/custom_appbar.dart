import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lesson20/domain/providers/weather_provider.dart';
import 'package:lesson20/ui/resources/app_icons.dart';
import 'package:lesson20/ui/routes/app_routes.dart';
import 'package:lesson20/ui/style/app_colors.dart';
import 'package:lesson20/ui/style/app_style.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                model.setFavorite(context, cityName: model.weatherData?.timezone);
              }, 
              icon: Icon(
                Icons.location_on,
                size: 30,
                color: AppColors.white,
                ), 
              label: Text(
              model.currentCity, 
              style:AppStyle.fonstyle,
            ),
            ),
            IconButton(
              onPressed: () {
                context.go(AppRoutes.search);
              }, 
              icon: SvgPicture.asset(AppIcons.menu),
            )
            
            
          ],
        ),
      ),
    );
  }
  @override
  Size get preferredSize => const Size(double.infinity, 60);
}
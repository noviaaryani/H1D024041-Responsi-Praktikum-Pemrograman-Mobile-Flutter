import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import 'search_screen.dart';
import 'widgets/daily_forecast_list.dart';
import 'widgets/weather_detail_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherVM = context.watch<WeatherViewModel>();
    final searchVM = context.watch<SearchViewModel>();

    final isFav = weatherVM.currentLocation != null &&
        searchVM.isLocationFavorite(weatherVM.currentLocation!);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFEDF3), // Soft pastel pink
              Color(0xFFF0F6FF), // Soft sky blue
              Color(0xFFFFFFFF), // Pure white
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            color: AppTheme.primaryPink,
            onRefresh: () => weatherVM.fetchWeather(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // APP BAR
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryPink.withValues(alpha: 0.15),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.location_on_rounded,
                                color: AppTheme.primaryPink,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  weatherVM.currentLocation?.name ?? 'Memuat...',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                                if (weatherVM.currentLocation?.admin1 != null)
                                  Text(
                                    '${weatherVM.currentLocation!.admin1}, ${weatherVM.currentLocation!.country ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (weatherVM.currentLocation != null)
                              IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  color: isFav ? AppTheme.primaryPink : AppTheme.textDark,
                                ),
                                onPressed: () {
                                  searchVM.toggleFavorite(weatherVM.currentLocation!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: AppTheme.textDark,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      content: Text(
                                        isFav
                                            ? '${weatherVM.currentLocation!.name} dihapus dari favorit'
                                            : '${weatherVM.currentLocation!.name} ditambahkan ke favorit 💕',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.search_rounded, color: AppTheme.primaryBlue, size: 20),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // BODY CONTENT (BASED ON STATUS)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  sliver: SliverToBoxAdapter(
                    child: _buildBody(context, weatherVM),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel vm) {
    switch (vm.status) {
      case WeatherStatus.loading:
      case WeatherStatus.initial:
        return const SizedBox(
          height: 400,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppTheme.primaryPink),
                SizedBox(height: 16),
                Text(
                  'Mengambil data cuaca...',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                ),
              ],
            ),
          ),
        );

      case WeatherStatus.error:
        return Container(
          margin: const EdgeInsets.only(top: 60),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, color: AppTheme.primaryPink, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Gagal Mengambil Data Cuaca',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
              ),
              const SizedBox(height: 8),
              Text(
                vm.errorMessage ?? 'Periksa koneksi internet Anda dan coba lagi.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => vm.fetchWeather(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        );

      case WeatherStatus.success:
        final weather = vm.weatherData!;
        final todayDaily = weather.daily.isNotEmpty ? weather.daily.first : null;

        return Column(
          children: [
            // MAIN WEATHER HERO CARD (Aesthetic Gradient)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF94B9), // Vibrant soft pink
                    Color(0xFFB4C8FF), // Soft sky blue
                  ],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPink.withValues(alpha: 0.28),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    weather.current.weatherIcon,
                    style: const TextStyle(fontSize: 70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${weather.current.temperature.round()}°C',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.white,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    weather.current.weatherDescription,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Terasa seperti ${weather.current.apparentTemperature.round()}°C',
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (todayDaily != null) ...[
                          const Text(' • ', style: TextStyle(color: Colors.white70)),
                          Text(
                            '↑${todayDaily.maxTemp.round()}°  ↓${todayDaily.minTemp.round()}°',
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // DETAIL CUACA
            WeatherDetailCard(
              current: weather.current,
              todayDaily: todayDaily,
            ),

            const SizedBox(height: 24),

            // PREDIKSI BEBERAPA HARI KE DEPAN
            DailyForecastList(items: weather.daily),

            const SizedBox(height: 32),
          ],
        );
    }
  }
}

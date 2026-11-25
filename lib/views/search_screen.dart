import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/location_model.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectLocation(LocationModel location) {
    final weatherVM = Provider.of<WeatherViewModel>(context, listen: false);
    final searchVM = Provider.of<SearchViewModel>(context, listen: false);

    searchVM.onLocationSelected(location);
    weatherVM.setLocation(location);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final searchVM = context.watch<SearchViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFE),
      appBar: AppBar(
        title: const Text('Cari & Lokasi'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // SEARCH INPUT BOX
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryPink.withValues(alpha: 0.12),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => searchVM.searchLocations(value),
                  decoration: InputDecoration(
                    hintText: 'Cari nama kota (misal: Bandung, Tokyo)...',
                    hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryPink),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, color: AppTheme.textMuted, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              searchVM.searchLocations('');
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.arrow_forward_rounded, color: AppTheme.primaryBlue),
                            onPressed: () => searchVM.searchLocations(_searchController.text),
                          ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // SEARCH CONTENT
            Expanded(
              child: _buildSearchBody(searchVM),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBody(SearchViewModel searchVM) {
    if (searchVM.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppTheme.primaryPink),
            SizedBox(height: 12),
            Text('Mencari lokasi dari Open-Meteo...', style: TextStyle(color: AppTheme.textMuted)),
          ],
        ),
      );
    }

    if (searchVM.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppTheme.primaryPink, size: 48),
              const SizedBox(height: 12),
              Text(
                searchVM.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    // Jika sedang ada hasil pencarian
    if (_searchController.text.trim().isNotEmpty) {
      if (searchVM.searchResults.isEmpty) {
        return const Center(
          child: Text(
            'Lokasi tidak ditemukan 🍃\nCoba kata kunci lain.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: searchVM.searchResults.length,
        itemBuilder: (context, index) {
          final loc = searchVM.searchResults[index];
          final isFav = searchVM.isLocationFavorite(loc);

          return _buildLocationTile(
            location: loc,
            isFavorite: isFav,
            onTap: () => _selectLocation(loc),
            onFavoriteTap: () => searchVM.toggleFavorite(loc),
          );
        },
      );
    }

    // Tampilan Default: Daftar Favorit & Riwayat Pencarian
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        // DAFTAR FAVORIT
        if (searchVM.favorites.isNotEmpty) ...[
          const Row(
            children: [
              Icon(Icons.favorite_rounded, color: AppTheme.primaryPink, size: 20),
              SizedBox(width: 8),
              Text(
                'Lokasi Favorit',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...searchVM.favorites.map(
            (loc) => _buildLocationTile(
              location: loc,
              isFavorite: true,
              onTap: () => _selectLocation(loc),
              onFavoriteTap: () => searchVM.toggleFavorite(loc),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // RIWAYAT PENCARIAN
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.history_rounded, color: AppTheme.primaryBlue, size: 20),
                SizedBox(width: 8),
                Text(
                  'Riwayat Pencarian',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                ),
              ],
            ),
            if (searchVM.history.isNotEmpty)
              TextButton(
                onPressed: () => searchVM.clearHistory(),
                child: const Text('Hapus Semua', style: TextStyle(color: AppTheme.primaryPink, fontSize: 12)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (searchVM.history.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 36),
            alignment: Alignment.center,
            child: const Text(
              'Belum ada riwayat pencarian.\nKetik nama kota di atas untuk memulai!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
          )
        else
          ...searchVM.history.map(
            (loc) => _buildLocationTile(
              location: loc,
              isFavorite: searchVM.isLocationFavorite(loc),
              onTap: () => _selectLocation(loc),
              onFavoriteTap: () => searchVM.toggleFavorite(loc),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationTile({
    required LocationModel location,
    required bool isFavorite,
    required VoidCallback onTap,
    required VoidCallback onFavoriteTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.softPink.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.location_city_rounded, color: AppTheme.primaryPink, size: 20),
        ),
        title: Text(
          location.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark),
        ),
        subtitle: Text(
          '${location.admin1 ?? ''}${location.admin1 != null && location.country != null ? ', ' : ''}${location.country ?? ''}',
          style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFavorite ? AppTheme.primaryPink : AppTheme.textMuted,
          ),
          onPressed: onFavoriteTap,
        ),
      ),
    );
  }
}

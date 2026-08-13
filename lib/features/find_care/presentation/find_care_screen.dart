import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FindCareScreen extends StatefulWidget {
  const FindCareScreen({super.key});

  @override
  State<FindCareScreen> createState() => _FindCareScreenState();
}

class _FindCareScreenState extends State<FindCareScreen>
    with TickerProviderStateMixin {
  late final AnimatedMapController mapController;

  List providers = [];
  bool isLoading = true;
  String selectedFilter = 'all';

  LatLng userLocation = const LatLng(30.033333, 31.233334);

  @override
  void initState() {
    super.initState();
    mapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
    );
    init();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  Future<void> init() async {
    await getUserLocation();
    await getData();
  }

  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) return;

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() => userLocation = LatLng(pos.latitude, pos.longitude));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        mapController.animateTo(dest: userLocation, zoom: 14);
      });
    } catch (e) {
      debugPrint("LOCATION ERROR: $e");
    }
  }

  Future<void> getData() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.functions.invoke(
        'nearby_hospital_doctors',
        body: {
          "lat": userLocation.latitude,
          "lng": userLocation.longitude,
          "radius": 5000,
        },
      );

      final raw = response.data;
      List data = [];

      if (raw is Map && raw['places'] is List) {
        data = raw['places'];
      } else if (raw is List) {
        data = raw;
      }

      setState(() {
        providers = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("EDGE ERROR: $e");
      setState(() {
        providers = [];
        isLoading = false;
      });
    }
  }

  List get filteredProviders {
    if (selectedFilter == 'all') return providers;
    return providers.where((e) => e['type'] == selectedFilter).toList();
  }

  List<Marker> buildMarkers() {
    return filteredProviders
        .where((e) => e['lat'] != null && e['lng'] != null)
        .map((item) {
          return Marker(
            point: LatLng(
              (item['lat'] as num).toDouble(),
              (item['lng'] as num).toDouble(),
            ),
            width: 55,
            height: 55,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on,
                color: Color(0xFFDC2626),
                size: 32,
              ),
            ),
          );
        })
        .toList();
  }

  String getName(item) => item['name'] ?? "Unknown";

  String getType(item) => item['type'] ?? "";

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    final filters = [
      {'key': 'all', 'en': 'All', 'ar': 'الكل'},
      {'key': 'hospital', 'en': 'Hospitals', 'ar': 'مستشفيات'},
      {'key': 'clinic', 'en': 'Clinics', 'ar': 'عيادات'},
      {'key': 'pharmacy', 'en': 'Pharmacies', 'ar': 'صيدليات'},
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Stack(
          children: [
            /// MAP + HEADER
            Column(
              children: [
                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                            color: cs.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isArabic ? "ابحث عن رعاية" : "Find Care",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: cs.errorContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.location_pin,
                          color: cs.error,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                /// MAP
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: cs.shadow.withOpacity(0.15),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: FlutterMap(
                        mapController: mapController.mapController,
                        options: MapOptions(
                          initialCenter: userLocation,
                          initialZoom: 14,
                          minZoom: 3,
                          maxZoom: 18,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                            userAgentPackageName: 'com.fady.salamty',
                            maxZoom: 18,
                            keepBuffer: 3,
                            tileDisplay: TileDisplay.fadeIn(),
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: userLocation,
                                width: 60,
                                height: 60,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(
                                      0xFF2563EB,
                                    ).withOpacity(0.2),
                                  ),
                                  child: const Icon(
                                    Icons.person_pin_circle,
                                    color: Color(0xFF2563EB),
                                    size: 42,
                                  ),
                                ),
                              ),
                              ...buildMarkers(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// RECENTER BUTTON
            Positioned(
              right: 16,
              top: 390,
              child: GestureDetector(
                onTap: () =>
                    mapController.animateTo(dest: userLocation, zoom: 14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainer,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withOpacity(0.15),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(Icons.my_location, color: cs.primary),
                ),
              ),
            ),

            /// BOTTOM SHEET
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.52,
                padding: const EdgeInsets.only(top: 18),
                decoration: BoxDecoration(
                  color: cs.surfaceContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// BOTTOM SHEET HEADER
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isArabic
                                ? "${filteredProviders.length} أماكن قريبة"
                                : "${filteredProviders.length} Nearby Places",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.local_hospital,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// FILTER CHIPS
                    SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: filters.map((filter) {
                          final isSelected = selectedFilter == filter['key'];
                          return GestureDetector(
                            onTap: () =>
                                setState(() => selectedFilter = filter['key']!),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? cs.primary
                                    : cs.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? cs.primary
                                      : cs.outlineVariant,
                                ),
                              ),
                              child: Text(
                                isArabic ? filter['ar']! : filter['en']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? cs.onPrimary
                                      : cs.onSurfaceVariant,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// LIST
                    Expanded(
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: cs.primary,
                              ),
                            )
                          : filteredProviders.isEmpty
                          ? Center(
                              child: Text(
                                isArabic ? "لا توجد أماكن" : "No places found",
                                style: TextStyle(color: cs.onSurfaceVariant),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              itemCount: filteredProviders.length,
                              itemBuilder: (context, index) {
                                return _buildModernCard(
                                  filteredProviders[index],
                                  cs,
                                  isArabic,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCard(item, ColorScheme cs, bool isArabic) {
    final type = getType(item);

    final typeLabel =
        {
          'hospital': isArabic ? 'مستشفى' : 'Hospital',
          'clinic': isArabic ? 'عيادة' : 'Clinic',
          'pharmacy': isArabic ? 'صيدلية' : 'Pharmacy',
        }[type] ??
        type;

    final typeIcon =
        {
          'hospital': Icons.local_hospital,
          'clinic': Icons.medical_services_outlined,
          'pharmacy': Icons.local_pharmacy_outlined,
        }[type] ??
        Icons.local_hospital;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(typeIcon, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  getName(item),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  typeLabel,
                  style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              final lat = item['lat'];
              final lng = item['lng'];
              if (lat != null && lng != null) {
                mapController.animateTo(
                  dest: LatLng(
                    (lat as num).toDouble(),
                    (lng as num).toDouble(),
                  ),
                  zoom: 16,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isArabic ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                size: 14,
                color: cs.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class TrackOrdersMap extends StatefulWidget {
  const TrackOrdersMap({super.key});

  @override
  State<TrackOrdersMap> createState() => _TrackOrdersMapState();
}

class _TrackOrdersMapState extends State<TrackOrdersMap> {
  String username = '';
  String address = '';
  String phoneNumber = '';
  LatLng _markerPosition = const LatLng(-6.9344, 107.6071);

  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _fetchUserAddress();
  }

  Future<void> _getUserInfo() async {
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final user = authService.getCurrentUser();

    if (user != null) {
      final userId = user.id;
      final usernameFromDb = await authService.getUsernameByUserId(userId);

      setState(() {
        username = usernameFromDb ?? '';
      });
    }
  }

  void _fetchUserAddress() async {
    final supabaseAuthService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final userId = supabaseAuthService.getCurrentUser()?.id;

    if (userId != null) {
      try {
        final userAddress = await supabaseAuthService.getUserAddress(userId);

        setState(() {
          address = userAddress['address'] ?? '';
          phoneNumber = userAddress['phoneNumber'] ?? '';
        });

        if (address.isNotEmpty) {
          var locations = await locationFromAddress(address);
          if (locations.isNotEmpty) {
            final latitude = locations[0].latitude;
            final longitude = locations[0].longitude;

            setState(() {
              _markerPosition = LatLng(latitude, longitude);
            });

            _mapController.move(_markerPosition, 14.0);
          }
        }
      } catch (e) {
        setState(() {
          address = 'Gagal memuat';
          phoneNumber = 'Gagal memuat';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: buildMaps()),
        ],
      ),
      bottomNavigationBar: buildDetail(),
    );
  }

  Widget buildMaps() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _markerPosition,
        initialZoom: 11,
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            const LatLng(-90, -180),
            const LatLng(90, 180),
          ),
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(markers: [
          Marker(
            point: _markerPosition,
            width: 60,
            height: 60,
            alignment: Alignment.centerLeft,
            child: const Icon(
              Icons.location_on,
              color: Colors.blue,
              size: 40,
            ),
          ),
          Marker(
            point: const LatLng(-6.9344, 107.6071),
            width: 60,
            height: 60,
            child: Image.asset(
              'assets/image/delivery.png',
              width: 50,
              height: 50,
            ),
          ),  
        ]),
        PolylineLayer(polylines: [
          Polyline(points: [
             const LatLng(-6.9344, 107.6071),
             _markerPosition,
          ],
          strokeWidth: 4.0,
          color: Colors.blue,
          )
        ])
      ],
    );
  }

  Widget buildDetail() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    const Text(
                      '10 menit lagi',
                      style: TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: warnaKopi2),
                    ),
                    const Gap(18),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                          border: Border.all(color: warnaKopi2, width: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(padding: EdgeInsets.all(4)),
                          Image.asset(
                            'assets/image/coffee_delivery.png',
                            height: 54,
                            width: 54,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pesanan sedang diantar ke alamatmu',
                                style: TextStyle(
                                    fontFamily: "poppinsregular",
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: warnaKopi),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Penerima: $username',
                                style: const TextStyle(
                                    fontFamily: "poppinsregular",
                                    fontSize: 11,
                                    color: warnaKopi),
                              ),
                              Text(
                                'No Hp: $phoneNumber',
                                style: const TextStyle(
                                    fontFamily: "poppinsregular",
                                    fontSize: 11,
                                    color: warnaKopi),
                              ),
                              Text(
                                'Alamat: $address',
                                style: const TextStyle(
                                    fontFamily: "poppinsregular",
                                    fontSize: 11,
                                    color: warnaKopi),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ]))
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: warnaHitam2,
            ),
          ),
        ),
      ],
    );
  }
}

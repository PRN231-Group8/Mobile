import 'package:explore_now/features/daily_check_in/screens/home/widgets/popular_destinations.dart';
import 'package:explore_now/features/daily_check_in/screens/home/widgets/search_box.dart';
import 'package:explore_now/features/daily_check_in/screens/home/widgets/section_title.dart';
import 'package:explore_now/features/daily_check_in/screens/home/widgets/trending_locations.dart';
import 'package:flutter/material.dart';
import 'package:explore_now/utils/constants/sizes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Import the geocoding package
import 'package:provider/provider.dart';

import '../controllers/location_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _locationMessage = 'Loading Location';
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = 'Location services are disabled.';
      });
      return;
    }

    // Check for location permission and request if not granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          print('Location permissions are denied.');
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        print('Location permissions are permanently denied.');
      });
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Reverse geocoding to get the place name
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];

      setState(() {
        _locationMessage =
        '${place.locality}, ${place.administrativeArea}, ${place.country}';
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Viet Nam";
        print('Error fetching location: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationController()..fetchLocations(),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Location Icon and Personalized Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello Shanto,',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _locationMessage ?? '',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.location_on, color: Colors.blue),
                    onPressed: () => _getCurrentLocation(),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const SizedBox(height: 20),

              /// Search Box
              const SearchBox(),
              const SizedBox(height: 30),

              /// Trending Destinations Section
              const SectionTitle(title: 'Trending Locations'),
              const SizedBox(height: 10),

              /// Fetch and display trending destinations
              Consumer<LocationController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.locations.isNotEmpty) {
                    return TrendingDestinations(
                      trendingLocations: controller.locations,
                    );
                  } else {
                    return const Center(child: Text('No locations available.'));
                  }
                },
              ),

              const SizedBox(height: 30),

              /// Popular Destinations Section
              const SectionTitle(title: 'Popular Tours'),
              const SizedBox(height: 10),
              const PopularDestinations(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:explore_now/features/home_screens/screens/home/tours/all_tours.dart';
import 'package:explore_now/features/home_screens/screens/home/widgets/popular_destinations.dart';
import 'package:explore_now/features/home_screens/screens/home/widgets/search_box.dart';
import 'package:explore_now/features/home_screens/screens/home/widgets/section_title.dart';
import 'package:explore_now/features/home_screens/screens/home/widgets/trending_locations.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../locations/widgets/all_locations.dart';
import '../../locations/widgets/location_detail.dart';
import '../controllers/location_controller.dart';
import '../controllers/tour_controller.dart';
import '../controllers/user_controller.dart';  // Add your user controller import
import '../models/location_model.dart';
import '../models/tour_model.dart';
import '../tours/tour_detail.dart';

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
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() {
          _locationMessage = 'Location permissions are denied';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert latitude and longitude to an address
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      geo.Placemark place = placemarks[0];
      setState(() {
        _locationMessage = "${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        _locationMessage = 'Could not fetch location';
      });
    }
  }

  void _navigateToDetails(Location location) {
    Get.to(() => LocationDetailScreen(location: location));
  }

  void _navigateToViewAll() {
    Get.to(() => ChangeNotifierProvider(
      create: (_) => LocationController(),
      child: LocationsScreen(),
    ));
  }

  void _navigateToAllTours(){
    Get.to(() => ChangeNotifierProvider(
      create: (_) => TourController(),
      child: AllToursScreen(),
    ));
  }

  void onTourTap(Tour tour) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourDetailScreen(tourId: tour.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationController()..fetchLocations()),
        ChangeNotifierProvider(create: (_) => TourController()..fetch4Tours()),
        ChangeNotifierProvider(create: (_) => UserController()..fetchUser()),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<UserController>(
                        builder: (context, userController, child) {
                          if (userController.isLoading) {
                            return const Text(
                              'Hello,',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          } else if (userController.userName != null) {
                            return Text(
                              'Hello, ${userController.userName},',
                              style: const TextStyle(
                                color: Colors.black38,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          } else {
                            return const Text(
                              'Hello, Guest,',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }
                        },
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

              // Search Box
              const SearchBox(),
              const SizedBox(height: 30),

              // Trending Destinations Section
              SectionTitle(
                title: 'Trending Locations',
                onViewAllPressed: () => _navigateToViewAll(),
              ),
              const SizedBox(height: 10),

              Consumer<LocationController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.locations.isNotEmpty) {
                    return TrendingDestinations(
                      trendingLocations: controller.locations,
                      onLocationTap: _navigateToDetails,
                    );
                  } else {
                    return const Center(child: Text('No locations available.'));
                  }
                },
              ),

              const SizedBox(height: 30),
              SectionTitle(
                title: 'Popular Tours',
                onViewAllPressed: () => _navigateToAllTours(),
              ),
              const SizedBox(height: 10),
              TourDestinations(
                onTourTap: onTourTap, // Pass the updated onTourTap callback
              ),
            ],
          ),
        ),
      ),
    );
  }
}

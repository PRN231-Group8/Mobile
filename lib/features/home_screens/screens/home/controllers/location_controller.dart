import 'package:explore_now/data/services/location/location_service.dart';
import 'package:flutter/material.dart';

import '../models/location_model.dart';

class LocationController with ChangeNotifier {
  final LocationService _locationService = LocationService();
  List<Location> _locations = [];
  bool _isLoading = false;

  List<Location> get locations => _locations;

  bool get isLoading => _isLoading;

  LocationController();

  Future<void> fetchLocations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _locations = await _locationService.fetchLocations();
      print('Locations fetched: ${_locations.length}');
    } catch (error) {
      print('Error fetching locations: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllLocations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _locations = await _locationService.fetchAllLocations();
      print('All locations fetched: ${_locations.length}');
    } catch (error) {
      print('Error fetching all locations: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

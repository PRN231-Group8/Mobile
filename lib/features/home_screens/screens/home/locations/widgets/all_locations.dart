import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../controllers/location_controller.dart';
import 'location_card.dart';
import 'location_detail.dart';

class LocationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationController =
        Provider.of<LocationController>(context, listen: false);
    locationController.fetchAllLocations();

    return Scaffold(
      appBar: AppBar(
        title: Text('Những địa điểm ưu thích'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<LocationController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.locations.isEmpty) {
            return Center(child: Text('No locations found.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: controller.locations.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 4,
                ),
                itemBuilder: (context, index) {
                  final location = controller.locations[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LocationDetailScreen(location: location),
                        ),
                      );
                    },
                    child: LocationCard(location: location),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

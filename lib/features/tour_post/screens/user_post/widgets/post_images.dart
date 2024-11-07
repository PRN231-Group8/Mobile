import 'package:flutter/material.dart';
import 'package:explore_now/features/tour_post/models/photo_model.dart';

class CustomPostImage extends StatelessWidget {
  final List<PhotoModel> photos;
  final VoidCallback onTap;

  const CustomPostImage({
    super.key,
    required this.photos,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double containerWidth = 380.0;
    const double imageHeightSingle = 380.0;
    const double imageHeightDouble = 200.0;

    if (photos.isEmpty) {
      return const SizedBox.shrink();
    } else if (photos.length == 1) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: containerWidth,
          height: imageHeightSingle,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(photos[0].url),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else if (photos.length == 2) {
      return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: containerWidth,
          height: imageHeightDouble,
          child: Row(
            children: photos.map((photo) {
              return Expanded(
                child: Container(
                  height: imageHeightDouble,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(photo.url),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    } else {
      const double imageHeight = 100.0;

      return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: containerWidth,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: imageHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(photos[0].url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 1),
                  Expanded(
                    child: Container(
                      height: imageHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(photos[1].url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: imageHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(photos[2].url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  if (photos.length > 3)
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: imageHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(photos[3].url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: imageHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.4),
                            ),
                            child: Center(
                              child: Text(
                                '+${photos.length - 3}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}

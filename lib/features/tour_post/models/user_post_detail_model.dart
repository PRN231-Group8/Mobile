class UserPostDetailModel {
  final int packageId;
  final String packageName;
  final double packagePrice;
  final String packageType;
  final String packageDescription;
  final String packageSize;
  final String packageThumbnailUrl;
  final List<DishModel> dishes;

  UserPostDetailModel({
    required this.packageId,
    required this.packageName,
    required this.packagePrice,
    required this.packageType,
    required this.packageDescription,
    required this.packageSize,
    required this.packageThumbnailUrl,
    required this.dishes,
  });

  factory UserPostDetailModel.fromJson(Map<String, dynamic> json) {
    List<DishModel> dishes = (json['dishes_of_package'] as List)
        .map((item) => DishModel.fromJson(item))
        .toList();

    return UserPostDetailModel(
      packageId: json['package_id'],
      packageName: json['package_name'],
      packagePrice: json['package_price'].toDouble(),
      packageType: json['package_type'],
      packageDescription: json['package_description'],
      packageSize: json['package_size'],
      packageThumbnailUrl: json['package_thumbnail_Url'],
      dishes: dishes,
    );
  }
}

class DishModel {
  final String dishName;
  final double dishPrice;
  final int dishQuantity;

  DishModel({
    required this.dishName,
    required this.dishPrice,
    required this.dishQuantity,
  });

  factory DishModel.fromJson(Map<String, dynamic> json) {
    return DishModel(
      dishName: json['dish_name'],
      dishPrice: json['dish_price'].toDouble(),
      dishQuantity: json['dish_quantity'],
    );
  }
}

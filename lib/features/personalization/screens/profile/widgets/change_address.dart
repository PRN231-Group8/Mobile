// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:get/get.dart';
//
// import '../../../../../common/widgets/appbar/appbar.dart';
// import '../../../../../utils/constants/sizes.dart';
// import '../../../../../utils/constants/text_strings.dart';
// import '../../../../../utils/validators/validation.dart';
// import '../../../controller/user_profile_controller.dart';
// import '../../address/address_picker.dart';
//
// class ChangeAddress extends StatelessWidget {
//   const ChangeAddress({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(UserProfileController());
//     return Scaffold(
//       appBar: TAppBar(
//         showBackArrow: true,
//         title:
//             Text('Địa chỉ', style: Theme.of(context).textTheme.headlineSmall),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(TSizes.defaultSpace),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Headings
//             Text(
//               'Địa chỉ là vô cũng cần thiết để đơn hàng được giao đến tay bạn',
//               style: Theme.of(context).textTheme.labelMedium,
//             ),
//             const SizedBox(height: TSizes.spaceBtwSections),
//
//             Form(
//               key: controller.profileFormKey,
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Flexible(
//                         child: TextFormField(
//                           controller: controller.address,
//                           validator: (value) =>
//                               TValidator.validateEmptyText('Địa chỉ', value),
//                           expands: false,
//                           decoration: InputDecoration(
//                             labelText: TTexts.address,
//                             prefixIcon: const Icon(Iconsax.home),
//                             suffixIcon: Tooltip(
//                               message: 'Chọn địa chỉ trên google map',
//                               child: IconButton(
//                                 icon: const Icon(Iconsax.map5,size: 30),
//                                 onPressed: () async {
//                                   final result = await Get.to(const LocationPicker());
//                                   if (result != null && result['address'] != null) {
//                                     controller.updateAddress(
//                                       address: result['address'],
//                                       latitude: result['latitude'],
//                                       longitude: result['longitude'],
//                                     );
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: TSizes.spaceBtwSections),
//
//             // Save Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => controller.updateUserProfile(),
//                 child: const Text('Lưu'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

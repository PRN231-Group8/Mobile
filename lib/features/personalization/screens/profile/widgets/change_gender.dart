import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/user_controller.dart';

class ChangeUserGender extends StatelessWidget {
  const ChangeUserGender({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    final Map<String, String> genderDisplayMap = {
      'Male': 'Nam',
      'Female': 'Nữ',
      'Other': 'Khác',
    };
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title:
            Text('Giới tính', style: Theme.of(context).textTheme.headlineSmall),
      ),
      // AppBar
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(
              'Bạn có thể cung cấp giới tính giúp chúng tôi biết bạn là ai',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            // Text
            const SizedBox(height: TSizes.spaceBtwSections),

            // Text field and Button
            Form(
              key: controller.profileFormKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: controller.gender.text.isEmpty
                        ? null
                        : controller.gender.text,
                    items:
                        <String>['Male', 'Female', 'Other'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(genderDisplayMap[value] ?? value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      controller.gender.text = newValue ?? '';
                    },
                    decoration: const InputDecoration(
                      labelText: 'Giới tính',
                      prefixIcon: Icon(Iconsax.user),
                    ),
                    validator: (value) =>
                        TValidator.validateEmptyText('Giới tính', value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.updateUserProfile(),
                  child: const Text('Lưu')),
            ),
            // SizedBox
          ],
        ),
      ),
    );
  }
}

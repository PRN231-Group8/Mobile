import 'package:explore_now/features/authentication/screens/signup/widgets/terms_and_conditions_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';

class TSignUpForm extends StatelessWidget {
  const TSignUpForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              ///First Name
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Họ', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: TTexts.firstName,
                      prefixIcon: Icon(Iconsax.user_add)),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputFields),

              ///Last Name
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Tên', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: TTexts.lastName,
                      prefixIcon: Icon(Iconsax.user_add)),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          ///Email
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            expands: false,
            decoration: const InputDecoration(
                labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          ///User name
          TextFormField(
            controller: controller.userName,
            validator: (value) => TValidator.validateUsername(value),
            expands: false,
            decoration: const InputDecoration(
                labelText: TTexts.username, prefixIcon: Icon(Iconsax.user)),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          ///Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => TValidator.validatePassword(value),
              expands: false,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye)),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          /// Confirm Password
          Obx(
                () => TextFormField(
              controller: controller.confirmPassword,
              validator: controller.validateConfirmPassword,
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: TTexts.confirmPassword,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                    !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye)),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          /// Term and conditions checkbox
          const TTermsAndConditionCheckbox(),

          const SizedBox(height: TSizes.spaceBtwSections),

          ///Signup Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: () => controller.signup(),
                child: const Text(TTexts.createAccount)),
          ),
        ],
      ),
    );
  }
}

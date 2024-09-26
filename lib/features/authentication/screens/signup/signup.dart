import 'package:explore_now/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: dark ? TColors.white : TColors.dark,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

             const TPrimaryHeaderContainer(
              child: Column(
                children: [
                  Image(
                    width: 400,
                    height: 180,
                    image: AssetImage('assets/images/signin/signin-bkg.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(TSizes.spaceBtwItems),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(TTexts.signupTitle,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// Form
                  const TSignUpForm(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  ///Divider
                  const TFormDivider(dividerText: TTexts.orSignUpWith),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  ///Social Buttons
                  const TSocialButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

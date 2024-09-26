import 'package:explore_now/features/authentication/screens/login/widgets/login_form.dart';
import 'package:explore_now/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title & Sub-Title
              TLoginHeader(),

              ///Form
              TLoginForm(),

              ///divider
              TFormDivider(dividerText: TTexts.orSignInWith),
              SizedBox(height: TSizes.spaceBtwSections),

              ///Social Button
              TSocialButton(),
            ],
          ),
        ),
      ),
    );
  }
}





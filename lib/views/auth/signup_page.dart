import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:validators/validators.dart' as validator;

import '../../config/wp_config.dart';
import '../../core/components/headline_with_row.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/sizedbox_const.dart';
import '../../core/controllers/auth/auth_controller.dart';
import '../../core/utils/app_utils.dart';
import 'components/already_have_account_button.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SignupForm(),
          ),
        ),
      ),
      bottomNavigationBar: const AlreadyHaveAccountButton(),
    );
  }
}

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<SignupForm> {
  late TextEditingController _username;
  late TextEditingController _email;
  late TextEditingController _pass;

  bool _isCreating = false;

  bool _isAgreed = false;

  Future<void> _signUp() async {
    if (_isCreating) {
      // so that we won't trigger our function twice
      return;
    } else {
      bool isValid = _formKey.currentState?.validate() ?? false;
      if (isValid && _isAgreed) {
        _isCreating = true;
        if (mounted) setState(() {});

        bool isValidUser = await ref.read(authController.notifier).signup(
              username: _username.text,
              email: _email.text,
              password: _pass.text,
              context: context,
            );
        if (isValidUser) {
        } else {
          _isCreating = false;
          if (mounted) setState(() {});
        }
      } else if (!_isAgreed) {
        Fluttertoast.showToast(msg: 'Terms & Services must be Agreed');
      }
    }
  }

  /// Formkey
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _username = TextEditingController();
    _email = TextEditingController();
    _pass = TextEditingController();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const HeadlineRow(
                  headline: 'sign_up',
                  fontColor: AppColors.primary,
                ),
                AppSizedBox.h16,
                Text(
                  'sign_up_message'.tr(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                AppSizedBox.h16,
                AppSizedBox.h16,
                TextFormField(
                  controller: _username,
                  decoration: InputDecoration(
                    labelText: 'username'.tr(),
                    prefixIcon: const Icon(IconlyLight.profile),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (v) {
                    if (v == null || v == '') {
                      return 'user_name_required';
                    }
                    return null;
                  },
                ),
                AppSizedBox.h16,
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'email'.tr(),
                    prefixIcon: const Icon(IconlyLight.message),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || !validator.isEmail(v)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                AppSizedBox.h16,
                TextFormField(
                  controller: _pass,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'password'.tr(),
                    prefixIcon: const Icon(IconlyLight.password),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (v) {
                    if (v == null || v == '') {
                      return 'password_required'.tr();
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Checkbox(
                value: _isAgreed,
                onChanged: (v) {
                  _isAgreed = !_isAgreed;
                  setState(() {});
                },
              ),
              Expanded(
                child: Row(
                  children: [
                    const Text('Agree to our '),
                    TextButton(
                      onPressed: () {
                        AppUtil.openLink(WPConfig.termsAndServicesUrl);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text('Terms & Services'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _signUp,
              child: _isCreating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('sign_up'.tr()),
            ),
          ),
        ),
      ],
    );
  }
}

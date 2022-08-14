import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validators/validators.dart' as validator;

import '../../core/components/headline_with_row.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_defaults.dart';
import '../../core/constants/sizedbox_const.dart';
import '../../core/controllers/auth/auth_controller.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/app_utils.dart';
import 'components/dont_have_account_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
        child: Center(child: SingleChildScrollView(child: LoginFormSection())),
      ),
      bottomNavigationBar: const DontHaveAccountButton(),
    );
  }
}

class LoginFormSection extends ConsumerStatefulWidget {
  const LoginFormSection({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends ConsumerState<LoginFormSection> {
  late TextEditingController _email;
  late TextEditingController _pass;

  bool _isLoggingIn = false;

  String? _loginErrorMessage;

  Future<void> _login() async {
    if (_isLoggingIn) {
      // so that we won't trigger our function twice
      return;
    } else {
      bool isValid = _formKey.currentState?.validate() ?? false;
      if (isValid) {
        AppUtil.dismissKeyboard(context: context);
        _loginErrorMessage = null;
        _isLoggingIn = true;
        if (mounted) setState(() {});

        String? result = await ref.read(authController.notifier).login(
              email: _email.text,
              password: _pass.text,
              context: context,
            );
        if (result == null) {
        } else {
          _loginErrorMessage = result;
          _isLoggingIn = false;
          if (mounted) setState(() {});
        }
      }
    }
  }

  /// Formkey
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _pass = TextEditingController();
  }

  @override
  void dispose() {
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
                  headline: 'login',
                  fontColor: AppColors.primary,
                ),
                AppSizedBox.h16,
                Text(
                  'login_message'.tr(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                AppSizedBox.h16,
                AppSizedBox.h16,
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'email'.tr(),
                    prefixIcon: const Icon(IconlyLight.message),
                    hintText: 'you@email.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v != null) {
                      if (validator.isEmail(v)) {
                      } else {
                        return 'Email is not valid';
                      }
                    }
                    return null;
                  },
                  onFieldSubmitted: (v) => _login(),
                ),
                AppSizedBox.h16,
                TextFormField(
                  controller: _pass,
                  obscureText: true,
                  decoration: InputDecoration(
                    errorText: _loginErrorMessage,
                    labelText: 'password'.tr(),
                    prefixIcon: const Icon(IconlyLight.password),
                    hintText: '*******',
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'password_required'.tr();
                    }
                    return null;
                  },
                  onFieldSubmitted: (v) => _login(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDefaults.margin),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _login,
              child: _isLoggingIn
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('login'.tr()),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDefaults.padding,
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.forgotPass);
              },
              child: Text('forgot_pass'.tr()),
            ),
          ),
        ),
      ],
    );
  }
}

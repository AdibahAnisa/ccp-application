import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/biometric_helper.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/src/localization/app_localizations.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/widget/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late bool showPassword;
  late ValueNotifier<bool> _showPasswordNotifier;
  late LoginFormBloc formBloc;
  final BiometricHelper biometricHelper = BiometricHelper();

  @override
  void initState() {
    super.initState();
    showPassword = true;
    _showPasswordNotifier = ValueNotifier<bool>(showPassword);
  }

  @override
  void dispose() {
    _showPasswordNotifier.dispose();
    super.dispose();
  }

  // void _loginUserByBiometric() async {
  //   final isAuth = await biometricHelper.authenticateUser();

  //   if (isAuth) {
  //     Navigator.pushReplacementNamed(
  //       context,
  //       AppRoute.homeScreen,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final arguments =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // bool biometricStatus = arguments?['isBiometric'] ?? false;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: BlocProvider(
        create: (_) => LoginFormBloc(),
        child: Builder(
          builder: (context) {
            formBloc = BlocProvider.of<LoginFormBloc>(context);
            return FormBlocListener<LoginFormBloc, String, String>(
              onSubmitting: (context, state) {
                LoadingDialog.show(context);
              },
              onSubmissionFailed: (context, state) =>
                  LoadingDialog.hide(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                Navigator.popAndPushNamed(
                  context,
                  AppRoute.homeScreen,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.successResponse!),
                  ),
                );
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.failureResponse!),
                  ),
                );
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Welcome back",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 28)),
                      Text(
                        "Enter your details below to sign in into you account.",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey.shade500),
                      ),
                      const SizedBox(height: 20),
                      const Text("Email",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      inputBloc(
                        formBloc.email,
                        hint: "Enter email address",
                        keyboard: TextInputType.emailAddress,
                        icon: Icons.email_outlined,
                      ),
                      const Text("Password",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      inputBloc(
                        formBloc.password,
                        hint: "Enter your password",
                        keyboard: TextInputType.visiblePassword,
                        obscure: true,
                        enablePasswordToggle: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoute.forgotPasswordScreen);
                            },
                            child: Text(
                              '${AppLocalizations.of(context)!.forgetPassword}?',
                              style: textStyleNormal(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 25.0),
                      // biometricStatus
                      //     ? GestureDetector(
                      //         onTap: () => _loginUserByBiometric(),
                      //         child: const Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Icon(
                      //               Icons.fingerprint,
                      //               color: kBlack,
                      //             ),
                      //             SizedBox(width: 10),
                      //             Text(
                      //               'Tap to login with biometric',
                      //               style: TextStyle(
                      //                 color: kBlack,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       )
                      //     : Container(),
                      const SizedBox(height: 20.0),
                      PrimaryButton(
                        buttonWidth: 0.9,
                        borderRadius: 10.0,
                        onPressed: () => formBloc.submit(),
                        label: Text(
                          AppLocalizations.of(context)!.login,
                          style: textStyleNormal(
                            color: kWhite,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      const Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("Or continue with"),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _socialButton(
                          icon: Icons.g_mobiledata,
                          text: "Sign in with Google"),
                      const SizedBox(height: 10),
                      _socialButton(
                          icon: Icons.apple, text: "Sign in with Apple"),
                      const SizedBox(height: 25),
                      spaceVertical(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.loginDesc}?",
                            style: textStyleNormal(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoute.signUpScreen);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.signUp,
                              style: textStyleNormal(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget inputBloc(
    TextFieldBloc bloc, {
    String? hint,
    TextInputType? keyboard,
    bool obscure = false,
    IconData? icon,
    bool enablePasswordToggle = false,
  }) {
    final ValueNotifier<bool> _obscureNotifier = ValueNotifier(obscure);

    return ValueListenableBuilder<bool>(
      valueListenable: _obscureNotifier,
      builder: (context, value, child) {
        return TextFieldBlocBuilder(
          textFieldBloc: bloc,
          obscureText: value,
          keyboardType: keyboard,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: icon != null ? Icon(icon) : null,
            suffixIcon: enablePasswordToggle
                ? GestureDetector(
                    onTap: () {
                      _obscureNotifier.value = !_obscureNotifier.value;
                    },
                    child: Icon(
                      value ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );
  }

  Widget _socialButton({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

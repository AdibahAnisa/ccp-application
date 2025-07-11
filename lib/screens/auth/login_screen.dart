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
import 'package:project/widget/widgets.dart';
import 'package:project/widget/background-image.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late bool showPassword;
  late ValueNotifier<bool> _showPasswordNotifier;
  LoginFormBloc? formBloc;
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

  void _loginUserByBiometric() async {
    final isAuth = await biometricHelper.authenticateUser();

    if (isAuth) {
      Navigator.pushReplacementNamed(
        context,
        AppRoute.homeScreen,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    bool biometricStatus = arguments?['isBiometric'] ?? false;

    return BackgroundImage(
      body: BlocProvider(
        create: (context) => LoginFormBloc(),
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
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: const BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 175.0,
                          height: 112.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: AssetImage(logo),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35.0),
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc!.email,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            label: Text(AppLocalizations.of(context)!.email),
                            hintText:
                                '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.email}',
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _showPasswordNotifier,
                          builder: (context, value, child) {
                            return TextFieldBlocBuilder(
                              textFieldBloc: formBloc!.password,
                              obscureText: value,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                label: Text(
                                    AppLocalizations.of(context)!.password),
                                hintText:
                                    '${AppLocalizations.of(context)!.enter} ${AppLocalizations.of(context)!.password}',
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _showPasswordNotifier.value =
                                        !_showPasswordNotifier.value;
                                  },
                                  child: Icon(
                                    value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: kGrey,
                                  ),
                                ),
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.8),
                              ),
                            );
                          },
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
                        const SizedBox(height: 25.0),
                        biometricStatus
                            ? GestureDetector(
                                onTap: () => _loginUserByBiometric(),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.fingerprint,
                                      color: kBlack,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Tap to login with biometric',
                                      style: TextStyle(
                                        color: kBlack,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 25.0),
                        PrimaryButton(
                          buttonWidth: 0.9,
                          borderRadius: 10.0,
                          onPressed: () => formBloc!.submit(),
                          label: Text(
                            AppLocalizations.of(context)!.login,
                            style: textStyleNormal(
                              color: kWhite,
                            ),
                          ),
                        ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}

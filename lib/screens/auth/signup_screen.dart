import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/constant.dart';
import 'package:project/form_bloc/form_bloc.dart';
import 'package:project/routes/route_manager.dart';
import 'package:project/screens/screens.dart';
// import 'package:project/src/localization/app_localizations.dart';
// import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:flutter/services.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/data/malaysia_cities.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late SignUpFormBloc formBloc;

  bool agreePolicy = false;
  bool agreeAutoDeduct = false;

  int step = 0;

  String? selectedState;
  String? selectedCity;

  // Future<void> _signInWithGoogle() async {
  //   try {
  //     final GoogleSignIn googleSignIn = GoogleSignIn();
  //     final user = await googleSignIn.signIn();

  //     if (user != null) {
  //       debugPrint('Google user: ${user.email}');
  //       // TODO: send user.id / email to backend
  //       // TODO: navigate to home page
  //     }
  //   } catch (e) {
  //     debugPrint('Google sign-in error: $e');
  //   }
  // }

  // Future<void> _signInWithApple() async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     debugPrint('Apple user: ${credential.userIdentifier}');
  //     // TODO: send credential.userIdentifier to backend
  //     // TODO: navigate to home page
  //   } catch (e) {
  //     debugPrint('Apple sign-in error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: BlocProvider(
        create: (_) => SignUpFormBloc(),
        child: Builder(
          builder: (context) {
            formBloc = BlocProvider.of<SignUpFormBloc>(context);

            return FormBlocListener<SignUpFormBloc, String, String>(
              onSubmitting: (context, state) => LoadingDialog.show(context),
              onSuccess: (context, state) {
                LoadingDialog.hide(context);
                if (state.successResponse == 'Account Created Successfully') {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoute.homeScreen, (_) => false);
                }
              },
              onFailure: (context, state) {
                LoadingDialog.hide(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(state.failureResponse ?? "Something went wrong"),
                  ),
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: step == 0 ? buildStepOne() : buildStepTwo(),
              ),
            );
          },
        ),
      ),
    );
  }

  /// ----------------- STEP 1 -----------------
  Widget buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildStepHeader(),
        const SizedBox(height: 25),
        const Text("First Name", style: TextStyle(fontWeight: FontWeight.w600)),
        inputBloc(formBloc.firstName, hint: "Enter your first name"),
        const SizedBox(height: 10),
        const Text("Last Name", style: TextStyle(fontWeight: FontWeight.w600)),
        inputBloc(formBloc.secondName, hint: "Enter your last name"),
        const SizedBox(height: 10),
        const Text("Email", style: TextStyle(fontWeight: FontWeight.w600)),
        inputBloc(formBloc.email,
            hint: "Enter email address",
            keyboard: TextInputType.emailAddress,
            icon: Icons.email_outlined),
        const SizedBox(height: 10),
        const Text("ID Number (Optional)",
            style: TextStyle(fontWeight: FontWeight.w600)),
        inputBloc(formBloc.idNumber, hint: "Enter your ID card number"),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
        const Text("Phone Number",
            style: TextStyle(fontWeight: FontWeight.w600)),
        IntlPhoneField(
          initialCountryCode: 'MY',
          disableLengthCheck: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: "e.g. 199901222",
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 153, 152, 152),
              fontSize: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          style: const TextStyle(fontSize: 16),
          dropdownIconPosition: IconPosition.trailing,
          dropdownTextStyle: const TextStyle(fontSize: 16),
          onChanged: (phone) {
            formBloc.phoneNumber.updateValue(phone.number);
            formBloc.phoneCode.updateValue('+${phone.countryCode}');
          },
          onCountryChanged: (country) {
            formBloc.phoneCode.updateValue('+${country.dialCode}');
          },
        ),
        const SizedBox(height: 10),
        const Text("Password", style: TextStyle(fontWeight: FontWeight.w600)),
        inputBloc(
          formBloc.password,
          hint: "Enter your password",
          keyboard: TextInputType.visiblePassword,
          obscure: true,
          enablePasswordToggle: true,
        ),
        const SizedBox(height: 10),
        const Text("Confirm Password",
            style: TextStyle(fontWeight: FontWeight.w600)),
        inputBloc(
          formBloc.confirmPassword,
          hint: "Enter confirm password",
          keyboard: TextInputType.visiblePassword,
          obscure: true,
          enablePasswordToggle: true,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Checkbox(
              value: agreePolicy,
              onChanged: (v) => setState(() => agreePolicy = v!),
            ),
            const Expanded(
              child: Text.rich(
                TextSpan(
                  text: "I agree with ",
                  children: [
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    TextSpan(text: " & "),
                    TextSpan(
                      text: "Terms and Conditions",
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          buttonWidth: 1.0,
          borderRadius: 8.0,
          onPressed: validateStepOneAndProceed,
          label: const Text("Next", style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 20),
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
        // const SizedBox(height: 20),
        // _socialButton(
        //   icon: Icons.g_mobiledata,
        //   text: "Sign in with Google",
        //   onTap: () {
        //     formBloc.signInWithGoogle();
        //   },
        // ),
        // const SizedBox(height: 10),
        // _socialButton(
        //   icon: Icons.apple,
        //   text: "Sign in with Apple",
        //   onTap: () {
        //     formBloc.signInWithApple();
        //   },
        // ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account? "),
            GestureDetector(
              onTap: () {
                // Navigate to Login Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text(
                "Login",
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ----------------- STEP 2 -----------------
  Widget buildStepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildStepHeader(),
        const SizedBox(height: 25),
        const Text("Address 1", style: TextStyle(fontWeight: FontWeight.w600)),
        inputBloc(formBloc.address1, hint: "Enter your address"),
        const SizedBox(height: 10),
        const Text("Address 2", style: TextStyle(fontWeight: FontWeight.w600)),
        inputBloc(formBloc.address2, hint: "Enter your address"),
        const SizedBox(height: 10),
        const Text("Address 3 (Optional)",
            style: TextStyle(fontWeight: FontWeight.w600)),
        inputBloc(formBloc.address3, hint: "Enter your address"),
        const SizedBox(height: 10),
        const Text("Postcode", style: TextStyle(fontWeight: FontWeight.w600)),
        inputBloc(formBloc.postcode,
            hint: "Enter your postcode", keyboard: TextInputType.number),
        const SizedBox(height: 10),
        const Text("State", style: TextStyle(fontWeight: FontWeight.w600)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedState,
              hint: const Text("Select state"),
              isExpanded: true,
              items: malaysiaCities.keys.map((state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedState = value;
                    selectedCity = null;
                    formBloc.stateField.updateValue(value);
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text("City", style: TextStyle(fontWeight: FontWeight.w600)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCity,
              hint: const Text("Select city"),
              isExpanded: true,
              items: selectedState == null
                  ? []
                  : malaysiaCities[selectedState]!
                      .map((city) => DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          ))
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCity = value;
                    formBloc.cityField.updateValue(value);
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text("Car Plate Number",
            style: TextStyle(fontWeight: FontWeight.w600)),
        inputBloc(
          formBloc.carPlateNumber,
          hint: "Enter your car plate number",
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
            UpperCaseTextFormatter(),
          ],
        ),
        const SizedBox(height: 30),
        PrimaryButton(
          buttonWidth: 1.0,
          borderRadius: 8.0,
          onPressed: validateStepTwoAndSubmit,
          label: const Text("Sign Up", style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  /// ----------------- VALIDATION HELPERS -----------------
  void validateStepOneAndProceed() {
    // 1. Manually update phone field value one last time if needed
    // 2. Trigger validation
    formBloc.firstName.validate();
    formBloc.secondName.validate();
    formBloc.email.validate();
    formBloc.phoneNumber.validate();
    formBloc.password.validate();
    formBloc.confirmPassword.validate();

    // 3. Check for errors
    bool hasErrors = formBloc.firstName.state.hasError ||
        formBloc.secondName.state.hasError ||
        formBloc.email.state.hasError ||
        formBloc.phoneNumber.state.hasError ||
        formBloc.password.state.hasError ||
        formBloc.confirmPassword.state.hasError;

    if (hasErrors) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields."),
        ),
      );
      return;
    }

    if (!agreePolicy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept all agreements."),
        ),
      );
      return;
    }

    setState(() => step = 1);
  }

  void validateStepTwoAndSubmit() {
    formBloc.address1.validate();
    formBloc.address2.validate();
    formBloc.postcode.validate();
    formBloc.carPlateNumber.validate();

    final isStateSelected = selectedState != null && selectedState!.isNotEmpty;
    final isCitySelected = selectedCity != null && selectedCity!.isNotEmpty;

    final isValid = formBloc.address1.state.isValid &&
        formBloc.address2.state.isValid &&
        formBloc.postcode.state.isValid &&
        formBloc.carPlateNumber.state.isValid &&
        isStateSelected &&
        isCitySelected;

    if (isValid) {
      formBloc.submit();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in all required fields.")));
    }
  }

  /// ----------------- WIDGET HELPERS -----------------
  Widget inputBloc(
    TextFieldBloc bloc, {
    String? hint,
    TextInputType? keyboard,
    bool obscure = false,
    IconData? icon,
    bool enablePasswordToggle = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final ValueNotifier<bool> _obscureNotifier = ValueNotifier(obscure);

    return ValueListenableBuilder<bool>(
      valueListenable: _obscureNotifier,
      builder: (context, value, child) {
        return TextFieldBlocBuilder(
          textFieldBloc: bloc,
          inputFormatters: inputFormatters,
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

  Widget buildStepHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: step >= 0
                      ? const Color.fromARGB(255, 13, 21, 177)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: step >= 1
                      ? const Color.fromARGB(255, 13, 21, 177)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Text(step == 0 ? "Account" : "Address",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          step == 0
              ? "This Section is for your account information"
              : "This Section is for your address information",
          style: const TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _socialButton(
      {required IconData icon, required String text, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:project/app/helpers/shared_preferences.dart';
import 'package:project/app/helpers/validators.dart';
import 'package:project/models/models.dart';
import 'package:project/resources/auth/auth_resources.dart';
import 'package:project/data/malaysia_cities.dart';

class SignUpFormBloc extends FormBloc<String, String> {
  final SignUpModel model = SignUpModel();
  final PlateNumberModel plateNumberModel = PlateNumberModel();

  // Step 0: Basic info
  final firstName = TextFieldBloc(validators: [InputValidator.required]);
  final secondName = TextFieldBloc(validators: [InputValidator.required]);
  final email = TextFieldBloc(
      validators: [InputValidator.required, InputValidator.emailChar]);
  final idNumber = TextFieldBloc();
  late final SelectFieldBloc<String, Object> countryField;
  final phoneCode = TextFieldBloc();
  final phoneNumber = TextFieldBloc(
    validators: [
      (value) {
        if (value.isEmpty) return 'Phone number is required';
        if (value.length < 9 || value.length > 10) {
          return 'Enter a valid 9 or 10 digit number';
        }
        return null;
      }
    ],
  );
  final Map<String, String> countryPhoneCodes = {};
  final password = TextFieldBloc(
      validators: [InputValidator.required, InputValidator.passwordChar]);
  final confirmPassword = TextFieldBloc();

  // Step 1: Address & Car Plate
  final address1 = TextFieldBloc(validators: [InputValidator.required]);
  final address2 = TextFieldBloc(validators: [InputValidator.required]);
  final address3 = TextFieldBloc(initialValue: '');
  final postcode = TextFieldBloc(validators: [InputValidator.required]);
  final stateField = SelectFieldBloc<String, Object>(
    items: malaysiaCities.keys.toList(),
  );

  final cityField = SelectFieldBloc<String, Object>();
  final carPlateNumber = TextFieldBloc(validators: [InputValidator.required]);

  SignUpFormBloc() {
    // Confirm password validator (reactive)
    confirmPassword.addValidators([
      InputValidator.required,
      (value) {
        if (value != password.value) return 'Passwords do not match';
        return null;
      }
    ]);

    // Revalidate confirmPassword when password changes
    password.onValueChanges(onData: (previous, current) async* {
      confirmPassword.updateValue(confirmPassword.value);
    });

    countryField = SelectFieldBloc<String, Object>(
      items: countryPhoneCodes.keys.toList(),
    );

    countryField.onValueChanges(onData: (prev, curr) async* {
      final selected = countryField.value;
      phoneCode.updateValue(countryPhoneCodes[selected] ?? "");
    });

    addFieldBlocs(step: 0, fieldBlocs: [
      firstName,
      secondName,
      email,
      idNumber,
      countryField,
      phoneCode,
      phoneNumber,
      password,
      confirmPassword
    ]);

    addFieldBlocs(step: 1, fieldBlocs: [
      address1,
      address2,
      address3,
      postcode,
      stateField,
      cityField,
      carPlateNumber
    ]);
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final account = await googleSignIn.signIn();
      if (account == null) {
        emitFailure(failureResponse: 'Google sign-in cancelled');
        return;
      }

      final auth = await account.authentication;

      final response = await http.post(
        Uri.parse('http://127.0.0.1:3000/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idToken': auth.idToken,
        }),
      );

      if (response.statusCode != 200) {
        emitFailure(failureResponse: 'Google authentication failed');
        return;
      }

      final data = jsonDecode(response.body);

      // Save JWT
      await SharedPreferencesHelper.saveToken(data['token']);

      emitSuccess(successResponse: 'Google login success');
    } catch (e) {
      emitFailure(failureResponse: 'Google sign-in error: $e');
    }
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final response = await http.post(
        Uri.parse('http://127.0.0.1:3000/auth/apple'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identityToken': credential.identityToken,
          'userIdentifier': credential.userIdentifier,
        }),
      );

      if (response.statusCode != 200) {
        emitFailure(failureResponse: 'Apple authentication failed');
        return;
      }

      final data = jsonDecode(response.body);

      // Save JWT
      await SharedPreferencesHelper.saveToken(data['token']);

      emitSuccess(successResponse: 'Apple login success');
    } catch (e) {
      emitFailure(failureResponse: 'Apple sign-in error: $e');
    }
  }

  @override
  FutureOr<void> onSubmitting() async {
    if (state.currentStep == 0) {
      if (password.value != confirmPassword.value) {
        confirmPassword.addFieldError('Passwords do not match');
        emitFailure(failureResponse: 'Passwords do not match');
        return;
      }

      model.firstName = firstName.value;
      model.secondName = secondName.value;
      model.email = email.value;
      model.idNumber = idNumber.value;
      model.country = countryField.value;
      model.phoneCode = phoneCode.value;
      model.phoneNumber = phoneNumber.value;
      model.password = password.value;

      emitSuccess();
      return;
    }

    model.address1 = address1.value;
    model.address2 = address2.value;
    model.address3 = address3.value;
    model.postcode = int.tryParse(postcode.value) ?? 0;
    model.city = cityField.value;
    model.state = stateField.value;

    plateNumberModel.isMain = true;
    plateNumberModel.plateNumber = carPlateNumber.value;

    try {
      // Create account
      final responseCreateAccount = await AuthResources.signUp(
        prefix: '/auth/signup',
        body: jsonEncode({
          'firstName': model.firstName,
          'secondName': model.secondName,
          'email': model.email,
          'idNumber': model.idNumber,
          'country': model.country,
          'phoneCode': model.phoneCode,
          'phoneNumber': model.phoneNumber,
          'password': model.password,
          'address1': model.address1,
          'address2': model.address2,
          'address3': model.address3,
          'postcode': model.postcode,
          'city': model.city,
          'state': model.state,
        }),
      );

      if (responseCreateAccount['error'] != null) {
        emitFailure(
          failureResponse: responseCreateAccount['error'].toString(),
        );
        return;
      }

      // Save token
      SharedPreferencesHelper.saveToken(responseCreateAccount['token']);
      print(responseCreateAccount);

      // Create car plate
      final responseCarPlate = await AuthResources.carPlate(
        prefix: '/carplatenumber/create',
        body: jsonEncode({
          'isMain': plateNumberModel.isMain,
          'plateNumber': plateNumberModel.plateNumber,
        }),
      );

      if (responseCarPlate['error'] != null) {
        emitFailure(failureResponse: responseCarPlate['error'].toString());
        print(responseCreateAccount);
        return;
      }

      emitSuccess(successResponse: 'Account Created Successfully');
      print(responseCreateAccount);
    } catch (e) {
      emitFailure(failureResponse: 'Something went wrong: $e');
    }
  }
}

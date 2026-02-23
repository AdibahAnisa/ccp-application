import 'package:flutter/material.dart';
import 'package:project/models/models.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/constant.dart';
import 'package:project/theme.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/resources/resources.dart';
import 'package:project/src/localization/app_localizations.dart';

class EditAboutMe extends StatefulWidget {
  final UserModel userModel;
  const EditAboutMe({super.key, required this.userModel});

  @override
  State<EditAboutMe> createState() => _EditAboutMeState();
}

class _EditAboutMeState extends State<EditAboutMe> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _idNumberController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _address3Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postcodeController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.userModel.firstName);
    _lastNameController =
        TextEditingController(text: widget.userModel.secondName);
    _idNumberController =
        TextEditingController(text: widget.userModel.idNumber ?? '');
    _phoneController =
        TextEditingController(text: widget.userModel.phoneNumber ?? '');
    _emailController =
        TextEditingController(text: widget.userModel.email ?? '');
    _address1Controller =
        TextEditingController(text: widget.userModel.address1 ?? '');
    _address2Controller =
        TextEditingController(text: widget.userModel.address2 ?? '');
    _address3Controller =
        TextEditingController(text: widget.userModel.address3 ?? '');
    _cityController = TextEditingController(text: widget.userModel.city ?? '');
    _stateController =
        TextEditingController(text: widget.userModel.state ?? '');
    _postcodeController = TextEditingController(
      text: widget.userModel.postcode?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idNumberController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _address3Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      LoadingDialog.show(context);

      final body = {
        "firstName": _firstNameController.text,
        "secondName": _lastNameController.text,
        "email": _emailController.text,
        "idNumber": _idNumberController.text,
        "phoneNumber": _phoneController.text,
        "address1": _address1Controller.text,
        "address2": _address2Controller.text,
        "address3": _address3Controller.text,
        "city": _cityController.text,
        "state": _stateController.text,
        "postcode": _postcodeController.text,
      };

      final response = await AuthResources.editProfile(
        prefix: '/auth/update',
        body: body,
      );

      LoadingDialog.hide(context);

      if (response['user'] != null) {
        final updatedUser = UserModel.fromJson(response['user']);

        Navigator.pop(context, updatedUser);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Update failed")),
        );
      }
    } catch (e) {
      LoadingDialog.hide(context);

      print("UPDATE ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.aboutMe,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabel("First Name"),
            buildInput(_firstNameController, hint: "Enter your first name"),
            const SizedBox(height: 12),
            buildLabel("Last Name"),
            buildInput(_lastNameController, hint: "Enter your last name"),
            const SizedBox(height: 12),
            buildLabel("Email"),
            buildInput(
              _emailController,
              hint: "Enter email address",
              keyboard: TextInputType.emailAddress,
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 12),
            buildLabel("ID Number"),
            buildInput(_idNumberController, hint: "Enter your ID number"),
            const SizedBox(height: 12),
            buildLabel("Phone Number"),
            buildInput(
              _phoneController,
              hint: "Enter phone number",
              keyboard: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            buildLabel("Address 1"),
            buildInput(_address1Controller, hint: "Enter your address"),
            const SizedBox(height: 12),
            buildLabel("Address 2"),
            buildInput(_address2Controller, hint: "Enter your address"),
            const SizedBox(height: 12),
            buildLabel("Address 3"),
            buildInput(_address3Controller, hint: "Enter your address"),
            const SizedBox(height: 12),
            const SizedBox(height: 12),
            buildLabel("Postcode"),
            buildInput(_postcodeController, hint: "Enter your postcode"),
            const SizedBox(height: 12),
            buildLabel("City"),
            buildInput(_cityController, hint: "Enter your city"),
            const SizedBox(height: 12),
            buildLabel("State"),
            buildInput(_stateController, hint: "Enter your state"),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: PrimaryButton(
            borderRadius: 10.0,
            buttonWidth: 1,
            color: kPrimaryColor,
            label: const Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: _saveChanges,
          ),
        ),
      ),
    );
  }
}

Widget buildLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
    ),
  );
}

Widget buildInput(
  TextEditingController controller, {
  String? hint,
  TextInputType? keyboard,
  IconData? icon,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboard,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kPrimaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
    ),
  );
}

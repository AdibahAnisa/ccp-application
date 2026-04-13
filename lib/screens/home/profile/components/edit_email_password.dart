import 'package:flutter/material.dart';
import 'package:project/models/models.dart';
import 'package:project/widget/primary_button.dart';
import 'package:project/constant.dart';
import 'package:project/widget/loading_dialog.dart';
import 'package:project/resources/resources.dart';
import 'package:project/src/localization/app_localizations.dart';

class EditEmailPassword extends StatefulWidget {
  final UserModel userModel;
  const EditEmailPassword({super.key, required this.userModel});

  @override
  State<EditEmailPassword> createState() => _EditAboutMeState();
}

class _EditAboutMeState extends State<EditEmailPassword> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController =
        TextEditingController(text: widget.userModel.email ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      LoadingDialog.show(context);

      final body = {
        "email": _emailController.text,
        if (_passwordController.text.isNotEmpty)
          "password": _passwordController.text,
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
          AppLocalizations.of(context)!.emailPassword,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabel("Email"),
            buildInput(
              _emailController,
              hint: "Enter email address",
              keyboard: TextInputType.emailAddress,
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),
            buildLabel("Password"),
            buildPasswordInput(
              _passwordController,
              hint: "Enter new password",
              icon: Icons.lock_outline,
              obscureText: _obscurePassword,
              toggleVisibility: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
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

Widget buildPasswordInput(
  TextEditingController controller, {
  String? hint,
  IconData? icon,
  required bool obscureText,
  required VoidCallback toggleVisibility,
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon) : null,
      suffixIcon: IconButton(
        icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: toggleVisibility,
      ),
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

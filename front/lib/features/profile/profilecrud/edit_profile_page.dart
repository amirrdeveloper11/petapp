import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/features/auth/user/provider/user_provider.dart';
import 'package:front/widgets/custom_button.dart';
import 'package:front/widgets/custom_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user!;
    nameCtrl = TextEditingController(text: user.fullName);
    emailCtrl = TextEditingController(text: user.email);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    await Provider.of<UserProvider>(context, listen: false).updateProfile(
      name: nameCtrl.text,
      email: emailCtrl.text,
      password: passwordCtrl.text.isEmpty ? null : passwordCtrl.text,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: nameCtrl,
                hintText: "Full Name",
                validator: (v) => v!.isEmpty ? "Enter your name" : null,
              ),
              CustomTextField(
                controller: emailCtrl,
                hintText: "Email",
                validator: (v) {
                  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$');
                  if (!emailRegex.hasMatch(v!)) return "Invalid email";
                  return null;
                },
              ),
              CustomTextField(
                controller: passwordCtrl,
                hintText: "Password",
                obscureText: true,
              ),
              const Spacer(),
              CustomButton(text: "Save", onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }
}

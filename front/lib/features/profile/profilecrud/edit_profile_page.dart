import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/core/theme.dart';
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

  bool _saving = false;

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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      await Provider.of<UserProvider>(context, listen: false).updateProfile(
        name: nameCtrl.text,
        email: emailCtrl.text,
        password: passwordCtrl.text.isEmpty ? null : passwordCtrl.text,
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.deepTeal),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: nameCtrl,
                hintText: 'Full Name',
                prefixIcon: Icons.person_outline_rounded,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Enter your name' : null,
              ),
              CustomTextField(
                controller: emailCtrl,
                hintText: 'Email',
                prefixIcon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$');
                  if (v == null || !emailRegex.hasMatch(v.trim())) {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: passwordCtrl,
                hintText: 'New password (optional)',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  return v.length < 6 ? 'Minimum 6 characters' : null;
                },
              ),
              const Spacer(),
              CustomButton(
                text: _saving ? 'Saving...' : 'Save',
                onPressed: _saving ? null : _save,
                isLoading: _saving,
                icon: Icons.check_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

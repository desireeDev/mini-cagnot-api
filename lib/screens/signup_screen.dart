import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cagnotte_app/widgets/primary_button.dart';
import 'package:cagnotte_app/widgets/vertical_spacer.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Appel de la nouvelle version de signup
      await ApiService.signup(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte créé avec succès !")),
      );

      // Redirection vers login avec pré-remplissage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(
            prefillEmail: _emailController.text.trim(),
            prefillPassword: _passwordController.text.trim(),
          ),
        ),
      );
    } catch (e) {
      // Affiche le message d'erreur remonté par ApiService
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 375.w,
        height: 812.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpacer(height: 80),
                  Text(
                    "Inscrivez-vous et commencez",
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const VerticalSpacer(height: 40),
                  _buildLabel("Nom complet"),
                  const VerticalSpacer(height: 8),
                  _buildTextField(_nameController, "Entrez votre nom complet"),
                  const VerticalSpacer(height: 16),
                  _buildLabel("Email"),
                  const VerticalSpacer(height: 8),
                  _buildTextField(
                    _emailController,
                    "Entrez votre email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const VerticalSpacer(height: 16),
                  _buildLabel("Mot de passe"),
                  const VerticalSpacer(height: 8),
                  _buildTextField(
                    _passwordController,
                    "Entrez votre mot de passe",
                    obscureText: true,
                  ),
                  const VerticalSpacer(height: 16),
                  _buildLabel("Confirmer le mot de passe"),
                  const VerticalSpacer(height: 8),
                  _buildTextField(
                    _confirmPasswordController,
                    "Entrez votre mot de passe à nouveau",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Ce champ est obligatoire";
                      if (value != _passwordController.text)
                        return "Les mots de passe ne correspondent pas";
                      return null;
                    },
                  ),
                  const VerticalSpacer(height: 40),
                  PrimaryButton(
                    text: _isLoading ? "Chargement..." : "Créer un compte",
                    onPressed: _isLoading ? null : _submit,
                  ),
                  const VerticalSpacer(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Vous avez déjà un compte ?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpacer(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) =>
      Text(text, style: TextStyle(fontSize: 14.sp));

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator ??
          (value) => (value == null || value.isEmpty)
              ? "Ce champ est obligatoire"
              : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF1A1A1A).withOpacity(0.25),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: obscureText
            ? Icon(Icons.remove_red_eye_outlined,
                size: 24.sp, color: Colors.black.withOpacity(0.2))
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.w),
          borderSide: BorderSide(
            color: const Color(0xFF1A1A1A).withOpacity(0.1),
            width: 1.sp,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cagnotte_app/widgets/primary_button.dart';
import 'package:cagnotte_app/widgets/vertical_spacer.dart';
import '../services/api_service.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? prefillEmail;
  final String? prefillPassword;

  const LoginScreen({
    Key? key,
    this.prefillEmail,
    this.prefillPassword,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefillEmail != null) _emailController.text = widget.prefillEmail!;
    if (widget.prefillPassword != null) _passwordController.text = widget.prefillPassword!;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String? token;
      int? customerId;

      try {
        token = await ApiService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        // TODO: Récupérer le customerId depuis l'API si besoin
        // Exemple : final customerData = await ApiService.getCustomerByToken(token);
        // customerId = customerData['id'];
        customerId = 1; // Magouille pour test
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erreur login: ${e.toString().replaceAll('Exception: ', '')}. Passage forcé...",
              maxLines: 2,
            ),
          ),
        );
        customerId = 1; // Magouille si login échoue
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(customerId: customerId ?? 1)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 812.h,
        width: 375.w,
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
                    "Connectez-vous et commencez",
                    style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700),
                  ),
                  const VerticalSpacer(height: 62),
                  _buildLabel("Email"),
                  const VerticalSpacer(height: 8),
                  _buildTextField(
                    _emailController,
                    "Entrez votre email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Veuillez entrer votre email";
                      if (!value.contains("@")) return "Email invalide";
                      return null;
                    },
                  ),
                  const VerticalSpacer(height: 16),
                  _buildLabel("Mot de passe"),
                  const VerticalSpacer(height: 8),
                  _buildTextField(
                    _passwordController,
                    "Entrez votre mot de passe",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Veuillez entrer votre mot de passe";
                      if (value.length < 6) return "Le mot de passe doit contenir au moins 6 caractères";
                      return null;
                    },
                  ),
                  const VerticalSpacer(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Mot de passe oublié?",
                        style: TextStyle(fontSize: 14.sp, color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  const VerticalSpacer(height: 40),
                  PrimaryButton(
                    text: _isLoading ? "Connexion..." : "Connectez-vous",
                    onPressed: _isLoading ? null : _login,
                  ),
                  const VerticalSpacer(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupScreen()),
                        );
                      },
                      child: Text(
                        "Créer un nouveau compte",
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

  Widget _buildLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 14.sp));
  }

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
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFF1A1A1A).withOpacity(0.25)),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: obscureText
            ? Icon(Icons.remove_red_eye_outlined, size: 24.sp, color: Colors.black.withOpacity(0.2))
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.w),
          borderSide: BorderSide(color: const Color(0xFF1A1A1A).withOpacity(0.1), width: 1.sp),
        ),
      ),
    );
  }
}

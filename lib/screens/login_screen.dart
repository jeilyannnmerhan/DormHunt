import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isStudent = true;
  bool _hidePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'At least 6 characters';
    return null;
  }

  void _signIn() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = scaleOf(context);
    final role = _isStudent ? 'Student' : 'Dorm Owner';

    // Web / large screens: brand panel on the left, form on the right.
    if (isWide(context)) {
      return Scaffold(
        body: Row(
          children: [
            Expanded(flex: 2, child: _brandPanel()),
            Expanded(
              flex: 3,
              child: SafeArea(child: _formArea(role, s, showLogo: false)),
            ),
          ],
        ),
      );
    }

    // Phones / small windows: single column like the high-fidelity design.
    return Scaffold(
      body: SafeArea(child: _formArea(role, s, showLogo: true)),
    );
  }

  Widget _formArea(String role, double s, {required bool showLogo}) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 28 * s, vertical: 24 * s),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showLogo) ...[
                      _logo(s),
                      SizedBox(height: 32 * s),
                    ] else ...[
                      Text('Welcome back',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 28 * s,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink)),
                      SizedBox(height: 6 * s),
                      Text('Sign in to find your dorm near campus.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14 * s, color: Colors.black54)),
                      SizedBox(height: 24 * s),
                    ],
                    _card(role, s),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Left side of the wide layout.
  Widget _brandPanel() {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.blue),
        Image.asset(
          'assets/images/dorm1.jpg',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
        ColoredBox(color: AppColors.blue.withValues(alpha: 0.93)),
        // House on top, DormHunt below, centered and sized to fill the panel.
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _logo(3.0, onDark: true),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _logo(double s, {bool onDark = false, bool left = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          left ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(Icons.home_rounded,
            size: 54 * s, color: onDark ? Colors.white : AppColors.slate),
        SizedBox(height: 2 * s),
        RichText(
          text: TextSpan(
            style: GoogleFonts.fredoka(
              fontSize: 64 * s,
              fontWeight: FontWeight.w700,
              height: 1.05,
              letterSpacing: -0.5,
            ),
            children: [
              TextSpan(
                  text: 'Dorm',
                  style: TextStyle(
                      color: onDark ? Colors.white : AppColors.blue)),
              const TextSpan(
                  text: 'Hunt', style: TextStyle(color: AppColors.yellow)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(String role, double s) {
    final radius = BorderRadius.circular(12 * s);
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
      // Border is painted on top of the tabs so the corners stay clean.
      foregroundDecoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(color: AppColors.darkBlue, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            _tab('Student', _isStudent,
                () => setState(() => _isStudent = true), s),
            Container(width: 1.5, height: 50 * s, color: AppColors.darkBlue),
            _tab('Dorm Owner', !_isStudent,
                () => setState(() => _isStudent = false), s),
          ]),
          Padding(
            padding: EdgeInsets.fromLTRB(16 * s, 16 * s, 16 * s, 28 * s),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _activeAccount(role, s),
                  SizedBox(height: 18 * s),
                  _label('Email', s),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    style: TextStyle(fontSize: 15 * s),
                    decoration: _fieldDecoration(s),
                  ),
                  SizedBox(height: 16 * s),
                  _label('Password', s),
                  TextFormField(
                    controller: _password,
                    obscureText: _hidePassword,
                    validator: _validatePassword,
                    onFieldSubmitted: (_) => _signIn(),
                    style: TextStyle(fontSize: 15 * s),
                    decoration: _fieldDecoration(s).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20 * s,
                        ),
                        onPressed: () =>
                            setState(() => _hidePassword = !_hidePassword),
                      ),
                    ),
                  ),
                  SizedBox(height: 28 * s),
                  SizedBox(
                    width: double.infinity,
                    height: 50 * s,
                    child: ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30 * s)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Sign in as $role',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16 * s)),
                          SizedBox(width: 10 * s),
                          Icon(Icons.arrow_forward, size: 20 * s),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String text, bool selected, VoidCallback onTap, double s) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 50 * s,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.yellow : AppColors.fieldFill,
            border: const Border(
                bottom: BorderSide(color: AppColors.darkBlue, width: 1.5)),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16 * s,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? AppColors.ink : AppColors.blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _activeAccount(String role, double s) {
    return Container(
      padding: EdgeInsets.fromLTRB(12 * s, 8 * s, 10 * s, 10 * s),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.darkBlue),
        borderRadius: BorderRadius.circular(8 * s),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Active Account',
                  style: TextStyle(fontSize: 12 * s, color: Colors.black54)),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 14 * s, vertical: 3 * s),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(12 * s),
                ),
                child: Text(role,
                    style: TextStyle(color: Colors.white, fontSize: 11 * s)),
              ),
            ],
          ),
          SizedBox(height: 2 * s),
          Text('Jeily Ann Merhan',
              style:
                  TextStyle(fontSize: 16 * s, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _label(String t, double s) => Padding(
        padding: EdgeInsets.only(bottom: 8 * s),
        child: Text(t,
            style: TextStyle(fontSize: 15 * s, fontWeight: FontWeight.w600)),
      );

  InputDecoration _fieldDecoration(double s) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10 * s),
          borderSide: BorderSide(color: c, width: w),
        );
    return InputDecoration(
      filled: true,
      fillColor: AppColors.fieldFill,
      isDense: true,
      contentPadding:
          EdgeInsets.symmetric(horizontal: 14 * s, vertical: 14 * s),
      border: border(AppColors.darkBlue),
      enabledBorder: border(AppColors.darkBlue),
      focusedBorder: border(AppColors.blue, 2),
      errorBorder: border(AppColors.red),
      focusedErrorBorder: border(AppColors.red, 2),
    );
  }
}

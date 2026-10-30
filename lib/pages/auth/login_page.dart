
import 'package:butter_crumb/pages/auth/role_selection_page.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart';
import 'register_page.dart';
import 'register_admin_page.dart';
import '../client/home_page.dart';
import '../admin/admin_main_page.dart';

class LoginPage extends StatefulWidget {
  final String role;

  const LoginPage({
    super.key,
    required this.role,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureCode = true;
  bool _isLoading = false;

  bool get isAdmin => widget.role.toLowerCase() == 'admin';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.chocolate,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (_isLoading) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    bool success;
    String? name;

    final email = _emailController.text.trim().toLowerCase();

    if (isAdmin) {
      success = AuthService.loginAdmin(
        email: email,
        password: _passwordController.text,
        code: _codeController.text.trim(),
      );

      name = AuthService.getAdminName(email);
    } else {
      success = AuthService.loginClient(
        email: email,
        password: _passwordController.text,
      );

      name = AuthService.getClientName(email);
    }

    if (!mounted) return;

    if (!success) {
      setState(() {
        _isLoading = false;
      });

      _showMessage(
        isAdmin
            ? 'Email, password, atau kode admin salah.'
            : 'Email atau password salah. Silakan coba lagi.',
      );

      return;
    }

    if (isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminMainPage(
            adminName: name ?? 'Admin',
            adminEmail: email,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            clientName: name ?? 'Sweet Friend',
            clientEmail: email,
          ),
        ),
      );
    }
  }

  Future<void> _openRegister() async {
    final registeredEmail = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => isAdmin
            ? const RegisterAdminPage()
            : const RegisterPage(),
      ),
    );

    if (!mounted) return;

    if (registeredEmail != null) {
      _emailController.text = registeredEmail;
      _showMessage('Akun berhasil dibuat. Silakan login.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const RoleSelectionPage(),
                ),
              );
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 82,
                      height: 82,
                      decoration: const BoxDecoration(
                        color: AppColors.softPink,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isAdmin
                            ? Icons.admin_panel_settings_rounded
                            : Icons.cake_rounded,
                        size: 43,
                        color: AppColors.chocolate,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    isAdmin ? 'Hello, Admin!' : 'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineLarge,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    isAdmin
                        ? 'Masuk untuk mengelola toko Butter & Crumb.'
                        : 'Masuk dan temukan camilan manis favoritmu.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 32),

                  _fieldLabel('Email Address'),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';

                      if (email.isEmpty) {
                        return 'Email wajib diisi.';
                      }

                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(email)) {
                        return 'Masukkan alamat email yang valid.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  _fieldLabel('Password'),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction:
                        isAdmin ? TextInputAction.next : TextInputAction.done,
                    onFieldSubmitted: (_) {
                      if (!isAdmin) _login();
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi.';
                      }

                      return null;
                    },
                  ),

                  if (isAdmin) ...[
                    const SizedBox(height: 20),

                    _fieldLabel('Admin Access Code'),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: _codeController,
                      obscureText: _obscureCode,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        hintText: 'Enter admin access code',
                        prefixIcon: const Icon(Icons.key_rounded),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureCode = !_obscureCode;
                            });
                          },
                          icon: Icon(
                            _obscureCode
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kode akses wajib diisi.';
                        }

                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 28),

                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              width: 23,
                              height: 23,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Login'),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward_rounded),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: _openRegister,
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:football_buddy/providers/auth_navigation_provider.dart';
import 'package:football_buddy/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final nav = Provider.of<AuthNavigationProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Rejestracja')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Utwórz konto',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Wprowadź email';
                    if (!value.contains('@')) return 'Niepoprawny email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Hasło',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6)
                      return 'Minimum 6 znaków';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _obscurePassword,
                  decoration: const InputDecoration(
                    labelText: 'Powtórz hasło',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != passwordController.text)
                      return 'Hasła nie są identyczne';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                      icon: const Icon(Icons.app_registration),
                      label: const Text('Zarejestruj się'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _loading = true);
                          try {
                            await auth.signUp(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Konto utworzone!'),
                              ),
                            );
                            nav.setCurrentScreen(AppScreen.login);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('❌ Błąd: $e')),
                            );
                          } finally {
                            setState(() => _loading = false);
                          }
                        }
                      },
                    ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => nav.setCurrentScreen(AppScreen.login),
                  child: const Text('Masz już konto? Zaloguj się'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

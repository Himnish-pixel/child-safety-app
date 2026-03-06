import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService();

  String role = "parent";

  bool loading = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            /// Email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            /// Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// Parent / Child selector
            DropdownButtonFormField<String>(
              initialValue: role,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Login as",
              ),
              items: const [

                DropdownMenuItem(
                  value: "parent",
                  child: Text("Parent"),
                ),

                DropdownMenuItem(
                  value: "child",
                  child: Text("Child"),
                ),

              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// Login Button
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {

                      setState(() {
                        loading = true;
                        errorMessage = "";
                      });

                      try {

                        await authService.login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );

                      } catch (e) {

                        setState(() {
                          errorMessage = "Login failed";
                        });

                      }

                      setState(() {
                        loading = false;
                      });

                    },

                    child: const Text("Login"),
                  ),

            const SizedBox(height: 10),

            /// Error message
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 20),

            /// Create account button
            TextButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );

              },

              child: const Text("Create Account"),
            )

          ],
        ),
      ),
    );
  }
}
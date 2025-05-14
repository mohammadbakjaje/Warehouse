import 'package:flutter/material.dart';
import 'package:warehouse/widget/text_field_coustume.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LogInScreen> {
  bool showBottomContainer = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (showBottomContainer) {
          setState(() {
            showBottomContainer = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.orangeAccent,
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              top: showBottomContainer ? 60 : 200,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 80,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      showBottomContainer
                          ? 'Rock Store'
                          : 'Welcome to\nWarehouse',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Center(
              child: AnimatedOpacity(
                opacity: showBottomContainer ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      showBottomContainer = true;
                    });
                  },
                  child: const Text("Log In"),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              bottom: showBottomContainer ? 0 : -450,
              left: 0,
              right: 0,
              height: 450,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email
                        const Text("Email"),
                        const SizedBox(height: 8),
                        TextFieldCoustume(
                            hintText: "Enter your email", icon: Icons.email),

                        const SizedBox(height: 16),

                        // Password
                        const Text("Password"),
                        const SizedBox(height: 8),
                        TextFieldCoustume(
                          hintText: "Password",
                          icon: Icons.key,
                          suffixIcon: Icons.remove_red_eye,
                          obscureText: true,
                        ),

                        const SizedBox(height: 8),

                        // Forget Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forget password",
                            style: TextStyle(
                              color: Colors.orange[700],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Sign Up
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Don’t have an account? ",
                              style: TextStyle(color: Colors.grey[700]),
                              children: [
                                TextSpan(
                                  text: "Sign up",
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

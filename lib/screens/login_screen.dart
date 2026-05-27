

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool isLoading = false;
  bool rememberMe = false;
  bool obscurePassword = true;

  /// Backend URL
  static const String baseUrl =
      "http://127.0.0.1:3000";

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter username and password",
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["status"] == "success") {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const DashboardScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["message"] ??
                  "Invalid credentials",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Server Error: ${e.toString()}",
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND IMAGE
          SizedBox.expand(
            child: Image.asset(
              "assets/train.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// DARK OVERLAY
          Container(
            color: Colors.black.withOpacity(0.35),
          ),

          /// LOGIN CARD
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 8,
                  sigmaY: 8,
                ),
                child: Container(
                  width: 340,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color:
                        Colors.black.withOpacity(0.22),
                    borderRadius:
                        BorderRadius.circular(28),

                    /// SOFT BORDER
                    border: Border.all(
                      color:
                          Colors.white.withOpacity(0.12),
                      width: 1,
                    ),

                    /// LIGHT SHADOW
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(
                                0.18),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// TOP ICON
                      Container(
                        padding:
                            const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                              .withOpacity(0.08),
                        ),
                        child: const Icon(
                          Icons.train,
                          color:
                              Colors.lightBlueAccent,
                          size: 34,
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// TITLE
                      // const Text(
                      //   "JANATICS",
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 32,
                      //     fontWeight:
                      //         FontWeight.bold,
                      //     letterSpacing: 1.5,
                      //     shadows: [
                      //       Shadow(
                      //         blurRadius: 6,
                      //         color: Colors.black45,
                      //         offset: Offset(0, 2),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      const SizedBox(height: 6),

                      /// SUBTITLE
                      const Text(
                        "Railway Service Portal",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// USERNAME FIELD
                      _glassTextField(
                        controller: emailController,
                        hint: "Enter your username",
                        icon: Icons.person,
                      ),

                      const SizedBox(height: 16),

                      /// PASSWORD FIELD
                      _glassTextField(
                        controller:
                            passwordController,
                        hint: "Enter your password",
                        icon: Icons.lock,
                        isPassword: true,
                      ),

                      const SizedBox(height: 14),

                      /// REMEMBER + FORGOT
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                activeColor:
                                    Colors.orange,
                                checkColor:
                                    Colors.white,
                                side: BorderSide(
                                  color: Colors.white
                                      .withOpacity(
                                          0.5),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe =
                                        value ??
                                            false;
                                  });
                                },
                              ),

                              const Text(
                                "Remember",
                                style: TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color:
                                    Colors.cyanAccent,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// LOGIN BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : login,
                          style: ElevatedButton
                              .styleFrom(
                            backgroundColor:
                                Colors.deepOrange,
                            foregroundColor:
                                Colors.white,
                            elevation: 5,
                            shadowColor:
                                Colors.black38,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      30),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// FOOTER
                      const Text(
                        "© Indian Railway Digital Services",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
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
    );
  }

  Widget _glassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText:
            isPassword ? obscurePassword : false,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.white70,
          ),

          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword =
                          !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white60,
                  ),
                )
              : null,

          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.white60,
            fontSize: 14,
          ),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),
            borderSide: BorderSide(
              color:
                  Colors.white.withOpacity(0.06),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.orangeAccent
                  .withOpacity(0.6),
              width: 1,
            ),
          ),

          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
        ),
      ),
    );
  }
}
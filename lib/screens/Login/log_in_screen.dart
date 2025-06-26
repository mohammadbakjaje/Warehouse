import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/Login/bloc/login_cubit.dart';
import 'package:warehouse/screens/Login/bloc/login_state.dart';
import 'package:warehouse/widget/text_field_coustume.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});
  static String id = "LoginPage";

  @override
  State<LogInScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LogInScreen> {
  bool showBottomContainer = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
        child: WillPopScope(
          onWillPop: () async {
            if (showBottomContainer) {
              setState(() {
                showBottomContainer = false;
              });
              return false; // لا تخرج من التطبيق
            } else {
              bool shouldExit = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("تأكيد الخروج"),
                  content: const Text("هل تريد الخروج من التطبيق؟"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("إلغاء"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("خروج"),
                    ),
                  ],
                ),
              );
              return shouldExit;
            }
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              if (showBottomContainer) {
                setState(() {
                  showBottomContainer = false;
                });
              }
            },
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Stack(
                  children: [
                    // خلفية بتدرج لوني
                    Container(
                      decoration: BoxDecoration(color: MyColors.orangeBasic),
                    ),

                    // الشعار والنص
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      top: showBottomContainer ? 60 : 160,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            height: 170,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            showBottomContainer ? 'RockStock' : 'أهلا بعودتك',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // زر Log In في الأسفل
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      bottom: showBottomContainer ? -100 : 40,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: showBottomContainer ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Center(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.white, width: 1.5),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                showBottomContainer = true;
                              });
                            },
                            child: const Text(
                              "تسجيل الدخول",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // نموذج تسجيل الدخول السفلي
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      bottom: showBottomContainer ? 0 : -500,
                      left: 0,
                      right: 0,
                      height: 460,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                            key: formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Text(
                                    "تسجيل الدخول",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Email
                                const Text("البريد الالكتروني"),
                                const SizedBox(height: 8),
                                CoustemTextFormFiled(
                                  controller: emailController,
                                  hintText: "ادخل بريدك الالكتروني",
                                  icon: Icons.email,
                                  validator: (value) {
                                    if ((value ?? '').isEmpty) {
                                      return 'رجاء ادخل  رقم هاتف او بريد الكتروني';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Password
                                const Text("كلمة المرور"),
                                const SizedBox(height: 8),
                                BlocConsumer<LoginCubit, LoginState>(
                                  builder: (context, state) {
                                    return TextFormField(
                                      obscureText:
                                          context.read<LoginCubit>().obscure,
                                      obscuringCharacter: '*',
                                      decoration: InputDecoration(
                                        hintText: "كلمة المرور",
                                        prefixIcon: Icon(Icons.key),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                              context.read<LoginCubit>().obscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                          onPressed: () {
                                            BlocProvider.of<LoginCubit>(context)
                                                .changePasswordState();
                                          },
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      validator: (value) {
                                        if ((value ?? '').isEmpty) {
                                          return 'رجاء ادخل كلمة المرور';
                                        } else if (value!.length < 8) {
                                          return 'كلمة المرور يجب ان تكون على الاقل 8 محارف';
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: passwordController,
                                    );
                                  },
                                  listener: (context, state) {},
                                ),
                                const SizedBox(height: 8),

                                // Forget Password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "هل نسيت كلمة المرور؟",
                                    style: TextStyle(
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // زر الدخول
                                BlocConsumer<LoginCubit, LoginState>(
                                  builder:
                                      (BuildContext context, LoginState state) {
                                    if (state is LoginLoadingState) {
                                      return CircularProgressIndicator(
                                        color: Colors.white,
                                      );
                                    } else {
                                      return SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                MyColors.orangeBasic,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                          ),
                                          onPressed: () {
                                            if (formkey.currentState!
                                                .validate()) {
                                              context
                                                  .read<LoginCubit>()
                                                  .loginBloc(
                                                      emailController.text,
                                                      passwordController.text,
                                                      "user");
                                            }
                                          },
                                          child: const Text(
                                            "تسجيل الدخول",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  listener:
                                      (BuildContext context, LoginState state) {
                                    if (state is LoginErrorState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(state.errorMsg),
                                      ));
                                    }
                                    if (state is LoginSuccessState) {
                                      // Navigator.of(context).pushReplacement(
                                      //   MaterialPageRoute(
                                      //     builder: (context) => LayoutScreen(),
                                      //   ),
                                      // );
                                      print("login");
                                    }
                                  },
                                ),

                                const SizedBox(height: 12),

                                // Sign Up
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "ليس لديك حساب؟ ",
                                      style: TextStyle(color: Colors.grey[700]),
                                      children: [
                                        TextSpan(
                                          text: "سجل الآن",
                                          style: TextStyle(
                                            color: Colors.orange[700],
                                            fontWeight: FontWeight.w500,
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
            ),
          ),
        ));
  }
}

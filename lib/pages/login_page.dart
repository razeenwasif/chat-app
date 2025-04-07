import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/button.dart';
import 'package:chat_app/components/textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // methods 
  void login(BuildContext context) async {
    // authentication service
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
        emailController.text, 
        passwordController.text
      );
    } catch (e) {
        if (!context.mounted) {
          // "Login failed, but widget was unmounted: $e");
          return;
        }
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Text(e.toString())
          )
        );
    }
  }
  // go to register page
  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          children: [
            // add some space
            const SizedBox(height: 250),

            // logo   
            Icon(
              Icons.message, 
              size: 60, 
              color: Theme.of(context).colorScheme.primary
            ),

            // add some space
            const SizedBox(height: 50),

            // welcome back text
            Text(
              'Welcome back!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            // add some space
            const SizedBox(height: 50),

            // email text field
            CustomTextField(
              hintText: "Email", 
              controller: emailController,
              focusNode: FocusNode(),
            ),
      
            
            // add some space
            const SizedBox(height: 10),

            // password text field
            CustomTextField(
              hintText: "Password",
              controller: passwordController,
              focusNode: FocusNode(),
            ),

            // add some space
            const SizedBox(height: 25),

            // login button
            CustomButton(
              buttonText: "Login",
              onTap: () => login(context),
            ),

            const SizedBox(height: 25),
            
            // register button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

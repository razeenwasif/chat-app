import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/button.dart';
import 'package:chat_app/components/textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // methods
  void register(BuildContext context) async {
    final auth = AuthService();

    // create user if passwords match
    if (passwordController.text == confirmPasswordController.text) {
      try {
        await auth.signUpWithEmailPassword(
          emailController.text, 
          passwordController.text
        );
      } catch (e) {
        if (!context.mounted) {return;}
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Text(e.toString())
          )
        );
      }
    } else { // passwords dont match
      showDialog(
          context: context, 
          builder: (context) => const AlertDialog(
            title: Text("Passwords don't match")
          )
        );
    }
  }
  // go to login page
  final void Function()? onTap;

  RegisterPage({
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
              'Create an account',
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

            const SizedBox(height: 10),

            // confirm password text field
            CustomTextField(
              hintText: "Confirm Password", 
              controller: confirmPasswordController,
              focusNode: FocusNode(),
            ),

            // add some space
            const SizedBox(height: 25),

            // login button
            CustomButton(
              buttonText: "Register",
              onTap: () => register(context),
            ),

            const SizedBox(height: 25),
            
            // register button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login now",
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

import 'package:chat_app/components/textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
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
            CustomTextField(hintText: "Email"),
            
            // add some space
            const SizedBox(height: 10),

            // password text field
            CustomTextField(hintText: "Password"),

            // login button
            
            // register button
          ],
        ),
      ),
    );
  }
}

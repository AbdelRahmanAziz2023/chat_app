import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../userImage/user_Image.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email,String password, String username, File? image, bool isLogin, BuildContext ctx) submitFn;
  final bool isLoading;

  const AuthForm({
    Key? key,
    required this.submitFn,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final formKey = GlobalKey<FormState>();
  bool isLogin = true;
  String email = '';
  String password = '';
  String username = '';
  File? userImageFile;

  void pickedImage(File pickedImg) {
    setState(() {
      userImageFile = pickedImg;
    });
  }

  void switchAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void submit() {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isLogin) {
      if (userImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select an image.'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }
    }
    if (isValid) {
      formKey.currentState!.save();
      widget.submitFn(
        email.trim(),
        password.trim(),
        username.trim(),
        userImageFile,
        isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  if (!isLogin)
                    UserImage(imagePicker: pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText:true,
                    validator: (value) {

                      if (value!.length < 8) {
                        return 'Invalid password. It must be 8 char';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (!isLogin && (value == null || value.isEmpty)) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        username = value!;
                      },
                    ),
                  const SizedBox(height: 20),
                  if (widget.isLoading)
                    const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        primary: Theme.of(context).primaryColor,
                        textStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      child: Text(
                        isLogin ? 'LOGIN' : 'SIGN UP',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: switchAuthMode,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 4),
                        textStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(isLogin
                          ? 'Create account'
                          : 'I already have an account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'dart:io';

import 'package:chatapp/widgets/auth/authForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> submitAuthForm(
      String email,String password, String username, File? userImage, bool isLogin,BuildContext ctx) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email:email, password: password);
      } else {
        UserCredential userCredential =await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImage')
            .child('${userCredential.user!.uid}.jpg');
        await ref.putFile(userImage!);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({'username': username, 'image_url': url});
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage = 'Authentication failed';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is weak';
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitFn: submitAuthForm,
        isLoading: isLoading,
      ),
    );
  }
}
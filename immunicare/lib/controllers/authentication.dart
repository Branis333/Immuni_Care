import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Create instances at file level for reuse
final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

// Email sign-in function to be called from any page
Future<UserCredential?> signInWithEmailAndPassword(
    String email, String password, BuildContext context) async {
  try {
    final userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("Signed in: ${userCredential.user?.uid}");
    return userCredential;
  } on FirebaseAuthException catch (e) {
    print("Error: ${e.message}");
    // You could show a SnackBar or dialog here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? "Authentication failed")),
    );
    return null;
  }
}

// Email sign-up function
Future<UserCredential?> signUpWithEmailAndPassword(
    String email, String password, BuildContext context) async {
  try {
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("Signed up: ${userCredential.user?.uid}");
    return userCredential;
  } on FirebaseAuthException catch (e) {
    print("Error: ${e.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? "Signup failed")),
    );
    return null;
  }
}

// Google sign-in function that can be called from any page
Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  try {
    // You can keep the clientId if needed for specific platforms
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: "1005232117970-mca4hfgkj512nt13oa154i382rhpj26j.apps.googleusercontent.com",
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      print("User cancelled Google Sign-In");
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await auth.signInWithCredential(credential);

    print("Google Signed in: ${userCredential.user?.uid}");
    return userCredential;
  } catch (e) {
    print("Google Sign-In Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Google sign in failed: $e")),
    );
    return null;
  }
}

// Sign out function
Future<bool> signOutUser() async {
  try {
    final User? user = auth.currentUser;
    
    if (user == null) {
      return true;
    }
    
    // Check if user signed in with Google
    final bool isGoogleUser = user.providerData
        .any((userInfo) => userInfo.providerId == 'google.com');
        
    if (isGoogleUser) {
      await googleSignIn.disconnect();
    }
    
    await auth.signOut();
    return true;
  } catch (e) {
    print("Sign out error: $e");
    return false;
  }
}

// Check if user is currently signed in
User? getCurrentUser() {
  return auth.currentUser;
}

// Listen to auth state changes
Stream<User?> authStateChanges() {
  return auth.authStateChanges();
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;

class AuthService {

  
  static Future<UserCredential?> signInWithGoogle() async {
  try {
    await Firebase.initializeApp();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      print('Google sign-in canceled by user');
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on FirebaseAuthException catch (e) {
    print('FirebaseAuthException: ${e.message}');
    rethrow;
  } on PlatformException catch (e) {
    print('PlatformException: ${e.message}');
    rethrow;
  } catch (e) {
    print('Unexpected error: $e');
    rethrow;
  }
}





  // static Future<UserCredential?> signInWithApple() async {
  //   try {
  //     // Initialize Firebase if not already initialized
  //     await Firebase.initializeApp();

  //     // Perform Apple Sign In
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     // Create an OAuthCredential from the Apple Sign In result
  //     final oAuthCredential = OAuthProvider('apple.com').credential(
  //       idToken: appleCredential.identityToken,
  //       accessToken: appleCredential.authorizationCode,
  //     );

  //     // Sign in to Firebase with the Apple credential
  //     return await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
  //   } on SignInWithAppleException catch (e) {
  //     print('SignInWithAppleException: ${e}');
  //     rethrow;
  //   } on FirebaseAuthException catch (e) {
  //     print('FirebaseAuthException: ${e.message}');
  //     rethrow;
  //   } on PlatformException catch (e) {
  //     print('PlatformException: ${e.message}');
  //     rethrow;
  //   } catch (e) {
  //     print('Unexpected error: $e');
  //     rethrow;
  //   }
  // }

  static Future<UserCredential?> signInWithApple() async {
  try {
    // Initialize Firebase if not already initialized
    await Firebase.initializeApp();

    // Check the current platform
    final isAndroid = Platform.isAndroid;

    // Perform Apple Sign In with platform-specific configuration
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      // Add webAuthenticationOptions for Android
      webAuthenticationOptions: isAndroid
          ? WebAuthenticationOptions(
              clientId: 'YOUR_FIREBASE_CLIENT_ID', // Replace with your Firebase web client ID
              redirectUri: Uri.parse('https://your-app-domain.com/callback'), // Replace with your app's callback URL
            )
          : null,
    );

    // Create an OAuthCredential from the Apple Sign In result
    final oAuthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    // Sign in to Firebase with the Apple credential
    return await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
  } on SignInWithAppleException catch (e) {
    print('SignInWithAppleException: ${e}');
    rethrow;
  } on FirebaseAuthException catch (e) {
    print('FirebaseAuthException: ${e.message}');
    rethrow;
  } on PlatformException catch (e) {
    print('PlatformException: ${e.message}');
    rethrow;
  } catch (e) {
    print('Unexpected error: $e');
    rethrow;
  }
}
}
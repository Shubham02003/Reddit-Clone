import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    firebaseAuth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignProvider),
    firebaseFirestore: ref.read(firestoreProvider)));

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firebaseFirestore;
  
  AuthRepository(
      {required FirebaseAuth firebaseAuth,
      required GoogleSignIn googleSignIn,
      required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore,
        _googleSignIn = googleSignIn,
        _firebaseAuth = firebaseAuth;

    

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      UserModel userModel = UserModel(
        name: userCredential.user!.displayName?? 'No name',
        uid: userCredential.user!.uid,
        isAuthenticate: true,
        banner: Constants.bannerDefault,
        profilePic: userCredential.user!.photoURL?? Constants.avatarDefault,
        karma: 0,
        awards: [],
      );
      print(userCredential.user?.email);
    } catch (e) {
      print(e);
    }
  }
}

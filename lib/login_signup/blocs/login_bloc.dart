import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_mart/providers/firestore_provider.dart';

class LoginBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();
  Future<UserCredential> login(String email, String password) =>
      _firestoreProvider.loginUser(
        email,
        password,
      );
}

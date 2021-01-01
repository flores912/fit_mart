import 'package:fit_mart/providers/firestore_provider.dart';

class SignUpBloc {
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Future signUp(String email, String password) =>
      _firestoreProvider.registerUser(email, password);

  Future<void> addUserDetails(String name) =>
      _firestoreProvider.addUserDetails(name);
}

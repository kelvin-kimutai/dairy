import 'package:Collector/constants/authStatus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  // ignore: missing_return
  Future<Map<dynamic, dynamic>> loginUser(String phoneNumber) async {
    var response = new Map();
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      codeSent: (String verificationId, [int forceResendingToken]) {
        response['AuthStatus'] = AuthStatus.codeSent;
        response['verificationId'] = verificationId;
        return response;
      },
      verificationCompleted: (AuthCredential credential) {
        response['AuthStatus'] = AuthStatus.verificationCompleted;
        response['AuthCredential'] = credential;
        return response;
      },
      verificationFailed: (Exception exception) {
        response['AuthStatus'] = AuthStatus.verificationFailed;
        response['Exception'] = exception;
        return response;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        response['AuthStatus'] = AuthStatus.codeAutoRetrievalTimeout;
        response['verificationId'] = verificationId;
        return response;
      },
    );
  }
}

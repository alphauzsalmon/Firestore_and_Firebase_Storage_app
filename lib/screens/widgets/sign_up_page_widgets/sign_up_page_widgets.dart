import 'package:app_with_firebase/constants/constants.dart';
import 'package:app_with_firebase/screens/pages/HomePage/home_page.dart';
import 'package:app_with_firebase/screens/pages/sign_up_page/sign_up_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneTextField extends StatelessWidget {
  const PhoneTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: SignUpPage.phoneNumber,
      textInputAction: TextInputAction.send,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: "Phone Number",
      ),
      onFieldSubmitted: (a) async {
        await Verify().phoneVerify(context);
      },
      validator: (text) {
        if (text!.isEmpty) {
          return "You must enter your phone number";
        }
      },
    );
  }
}

class SendButton extends StatelessWidget {
  const SendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("Send"),
      onPressed: () async {
        await Verify().phoneVerify(context);
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );
  }
}

class Verify {

  phoneVerify(context) async {
    if (SignUpPage.formKey.currentState!.validate()) {
      await _authVerify(context);
    }
  }

  _authVerify(context) {
    return authUser.verifyPhoneNumber(
      phoneNumber: SignUpPage.phoneNumber.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException credential) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 3),
            content: Text("Check your sms and try again!"),
          ),
        );
      },
      codeSent: (String verificationId, int? forceResendingToken) async {
        //show dialog to take input from the user
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Enter SMS Code"),
            content: Form(
              key: SignUpPage.formKey2,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                controller: SignUpPage.smsCode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: "Sms Code",
                ),
                onFieldSubmitted: (a) async {
                  await _verifySmsCode(context, verificationId);
                },
                validator: (text) {
                  if (text!.isEmpty) {
                    return "You must enter sms code";
                  }
                },
              ),
            ),
            actions: [
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () async {
                  await _verifySmsCode(context, verificationId);
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
              ),
            ],
          ),
        );
      },
      codeAutoRetrievalTimeout: (a) {},
    );
  }

  _verifySmsCode(context, verificationId) async {
    if (SignUpPage.formKey2.currentState!.validate()) {
      try {
        var _credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: SignUpPage.smsCode.text);
        await authUser.signInWithCredential(_credential);
        final CollectionReference users = fireStore.collection('users');
        users.doc(authUser.currentUser!.uid).set(
          {
            'phoneNumber': authUser.currentUser!.phoneNumber,
          },
        );
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
              (Route<dynamic> route) => false,
        );
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.toString()),
          ),
        );
      }
    }
  }
}
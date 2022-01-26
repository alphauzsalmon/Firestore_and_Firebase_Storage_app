import 'package:app_with_firebase/screens/widgets/sign_up_page_widgets/sign_up_page_widgets.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static final formKey = GlobalKey<FormState>();
  static final formKey2 = GlobalKey<FormState>();
  static TextEditingController phoneNumber = TextEditingController();
  static TextEditingController smsCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.all(50.0),
                  child: PhoneTextField(),
                ),
                SendButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

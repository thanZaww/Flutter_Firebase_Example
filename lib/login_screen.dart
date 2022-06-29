import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _codeSend = false;
  bool _loading = false;
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Login Screen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (_codeSend)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.phone,
                    controller: _otpController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 30),
                      labelText: 'Enter OTP',
                      hintText: 'Enter OTP',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (_otpController.text.length > 4) {
                          setState(() {
                            _loading = true;
                          });
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: _verificationId!,
                                  smsCode: _otpController.text);
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          setState(() {
                            _loading = false;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(10),
                              content: const Text(
                                  '             Please enter your OTP number.'),
                            ),
                          );
                        }
                      },
                      child: const Text('Verify OTP'),
                    ),
                  ),
                  (_loading)
                      ? const Center(child: CircularProgressIndicator())
                      : Container(),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 30),
                      labelText: 'Phone Number',
                      hintText: 'Phone Number',
                      prefix: Text('010'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (_phoneController.text.length > 5) {
                          setState(() {
                            _loading = true;
                          });
                          FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '+8210${_phoneController.text}',
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent:
                                (String verificationId, int? resentToken) {
                              _verificationId = verificationId;
                              setState(() {
                                _codeSend = true;
                                _loading = false;
                              });
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(10),
                              content: const Text(
                                  '             Please enter your phone number.'),
                            ),
                          );
                        }
                      },
                      child: const Text('Get OTP'),
                    ),
                  ),
                  (_loading)
                      ? const Center(child: CircularProgressIndicator())
                      : Container(),
                ],
              ),
      ),
    );
  }
}

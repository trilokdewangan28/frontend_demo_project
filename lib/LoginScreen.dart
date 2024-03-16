import 'package:demo_project/Screen/ProfilePage.dart';
import 'package:demo_project/config/StaticMethod.dart';
import 'package:demo_project/config/apis.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  String token = '';

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  _loginUser(context) async {
    var loginData = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };
    var url = Uri.parse(loginUser);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.loginUser(loginData, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
         print(res);
         String token = res['result'];
        StaticMethod.showDialogBar(res['message'], Colors.green);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(token: token,)));
      } else {
        print(res);
        StaticMethod.showDialogBar(res['message'], Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login screen'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _textField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        label: 'email',
                        validator: (value) {
                          if (value!.isEmpty ||
                              !value.contains("@gmail.com")) {
                            return "please enter valid email";
                          }
                          return null;
                        },
                        inputType: TextInputType.text),
                    SizedBox(height: 10,),
                    _textField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        label: "password",
                        validator: (value) {
                          if (value!.isEmpty || value.length<8) {
                            return "please enter valid password";
                          }
                          return null;
                        },
                        inputType: TextInputType.text),


                    SizedBox(height: 10,),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _loginUser(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10))),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color:Colors.white,
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _textField(
      {required TextEditingController? controller,
      required FocusNode? focusNode,
      required String? label,
      required validator,
      required TextInputType? inputType}) {
    return TextFormField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.blue),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        validator: validator);
  }
}

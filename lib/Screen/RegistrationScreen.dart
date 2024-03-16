import 'package:demo_project/config/StaticMethod.dart';
import 'package:demo_project/config/apis.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  _signupUser(context) async {
    var signupData = {
      "uname": _usernameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
    };
    var url = Uri.parse(signupUser);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final res = await StaticMethod.userSignup(signupData, url);
    if (res.isNotEmpty) {
      Navigator.pop(context);
      if (res['success'] == true) {
        StaticMethod.showDialogBar(res['message'], Colors.green); 
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
        title: Text('Registration Screen'),
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
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        label: 'User Name',
                        validator: (value){
                          if(value.isEmpty){
                            return 'please enter valid input';
                          }
                          return null;
                        },
                        inputType: TextInputType.text),
                    SizedBox(height: 10,),
                    _textField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        label: "Email",
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
                            _signupUser(context);
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

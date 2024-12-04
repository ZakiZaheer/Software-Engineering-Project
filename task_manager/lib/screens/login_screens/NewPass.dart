import 'package:flutter/material.dart';

import '../../customWidgets/footer.dart';



class ResetPass extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      home: ResetPassword(),
    );

  }

}

class ResetPassword extends StatefulWidget{
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _rnewPass = TextEditingController();


  bool _obsText1=true;
  bool _obsText2=true;
  void togglePass1(){
    setState(() {
      _obsText1=!_obsText1;
    });
  }

  void togglePass2(){
    setState(() {
      _obsText2=!_obsText2;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051A33),

      appBar: AppBar(
        backgroundColor: Color(0xFF091F40),
        title: Text(''),
      ),
      body: Container(
        color: Color(0xFF091F40),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text("Reset Password", style: TextStyle(
                    fontSize: 40
                ),),
                SizedBox(height: 16),
                Text("New Password"),
                _passWord("New Password",_newPass,togglePass1,_obsText1),
                Text("Re-enter New Password"),
                _passWord("Re-enter New Password",_rnewPass,togglePass2,_obsText2),


                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Colors.white, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    border: Border.all(width: 0.8, color: Colors.transparent),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Colors.transparent),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate() && _newPass.text==_rnewPass.text) {
                          // Process data
                          print('Password Changed.');
                          print(_newPass.text);
                          print(_rnewPass.text);

                        }
                      },
                      child: Text('Continue'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MainFooter(index: 2),

    );
  }


}

Widget _passWord(String hintText, TextEditingController _cont,void fn(),bool _obsText) {

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1, color: Colors.transparent),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(width: 0.8, color: Colors.transparent),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF091F40),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: fn,
                  icon: Icon(_obsText?Icons.visibility:Icons.visibility_off)
              ),
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
            ),
            controller: _cont,
            obscureText: _obsText,
            obscuringCharacter: '*',
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ),
      ),
    ),
  );
}


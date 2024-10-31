import 'package:flutter/material.dart';
import 'OTP.dart';

void main(){
  runApp(forgotPass());
}

class forgotPass extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      home: ForgotPassword(),
    );

  }

}

class ForgotPassword extends StatefulWidget{
  @override
  _forgotPassState createState() => _forgotPassState();
}

class _forgotPassState extends State<ForgotPassword>{
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();




  @override
  Widget build(BuildContext context){
    return Scaffold(
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
                Text("Forgot Password",style: TextStyle(
                  fontSize: 40
                ),),
                SizedBox(height: 16),
                Text("Email"),
                _email(),
                Text("You may recieve one time code on your regitered email from us for security and login purposes."
                ,style: TextStyle(
                    color: Colors.grey
                  ),),


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
                        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process data
                          print('OTP step ahead');
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> otpPage()),
                          );
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
    );
  }




  Widget _email() {

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
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: '@gmail.com',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || !value.contains('@')) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }



}
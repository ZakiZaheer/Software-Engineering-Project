import 'package:flutter/material.dart';
import 'package:task_manager/screens/login_screens/SignUpScreen.dart';
import '../../customWidgets/footer.dart';
import'forgot_pass.dart';

void main(){
  runApp(loginApp());
}

class loginApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      home: loginPage(),
    );

  }

}

class loginPage extends StatefulWidget{
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage>{
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _loginemailController = TextEditingController();
  final TextEditingController _loginpasswordController = TextEditingController();


  bool _obsText=true;
  void togglePass(){
    setState(() {
      _obsText=!_obsText;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFF051A33),

      appBar: AppBar(
        backgroundColor: Color(0xFF091F40),
        title: Text('Login',style: const TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Color(0xFF091F40),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text("Email"),
                _email(),
                SizedBox(height: 16),
                Text("Password"),
                _passWord("Password"),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> ForgotPassword()),
                      );
                    },
                    child: Text('Forgot Password'),
                  ),
                ),
                SizedBox(height: 16),
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
                          print('Login Successful');
                        }
                      },
                      child: Text('Login'),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> SignUpPage()),
                    );
                  },
                  child: Text('Dont have an account? Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MainFooter(index: 2),

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
              controller: _loginemailController,
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

  Widget _passWord(String hintText, {bool isDropdown = false}) {

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
                    onPressed: togglePass,
                    icon: Icon(_obsText?Icons.visibility:Icons.visibility_off)
                ),
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
              ),
              controller: _loginpasswordController,
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

}
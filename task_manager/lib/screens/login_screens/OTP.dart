import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../customWidgets/footer.dart';
import 'NewPass.dart';


class otpPage extends StatefulWidget{
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<otpPage> {
  final _formKey = GlobalKey<FormState>();

  List<TextEditingController> controllersList=[];

  void initState(){
    super.initState();
    for (int i=0;i<6;i++){
      controllersList.add(TextEditingController());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051A33),

      appBar: AppBar(
        backgroundColor: Color(0xFF091F40),
        title: const Text(''),
      ),
      body: Container(
        color: const Color(0xFF091F40),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text("Enter OTP", style: TextStyle(
                    fontSize: 40
                ),),
                const SizedBox(height: 16),
                _otp(controllersList),

                const SizedBox(height: 20),
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
                        backgroundColor: const WidgetStatePropertyAll(
                            Colors.transparent),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process data
                          print(controllersList[0].text);
                          print(controllersList[1].text);
                          print(controllersList[2].text);
                          print(controllersList[3].text);
                          print(controllersList[4].text);
                          print(controllersList[5].text);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=> ResetPassword()),
                          );

                        }
                      },
                      child: Text('Continue'),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                    onPressed: () {

                    },
                    child: Text("Did'nt receive code? Resend"),
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

Widget _otp(List _conts){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(width: 1, color: Colors.transparent),
    ),
    child: Container(
      child: Padding(
          padding: const EdgeInsets.all(1.0),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF091F40),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              sCont(_conts[0]),
              sCont(_conts[1]),
              sCont(_conts[2]),
              sCont(_conts[3]),
              sCont(_conts[4]),
              sCont(_conts[5])
            ],
          ),
        ),
      ),
    ),
  );
}

Widget sCont(TextEditingController _cont){
  return Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        colors: [Colors.white, Colors.transparent],
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(width: 1.5, color: Colors.transparent),
    ),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF091F40)
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: TextFormField(
          controller: _cont,
          obscureText: true,
          obscuringCharacter: '*',
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly
          ],
          style: const TextStyle(
              color: Colors.white
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    ),
  );
}
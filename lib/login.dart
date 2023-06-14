import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email  = TextEditingController(text: "");
  TextEditingController password  = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Card(
      child: Container(width: 450,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text("Login form",style: TextStyle(fontSize: 20),),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(controller: email,decoration: InputDecoration(label: Text("Email")),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(controller: password,decoration: InputDecoration(label: Text("Password")),),
              ),
              InkWell( onTap: (){
                try{
                  print(email.text);
                  print(password.text);
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
                }catch(e){

                }
              },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8,right: 4,left: 4),
                  child: Card(color: Colors.blue,child: Center(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Login",style: TextStyle(color: Colors.white),),
                  ),),),
                ),
              ),
            if(false)  Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(onPressed: (){
                  Navigator.pushNamed(context, "/signup");
                }, child: Center(child: Text("Signup & Create directory"),)),
              )
            ],
          ),
        ),
      ),
    ),),);
  }
}

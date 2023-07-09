import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email  = TextEditingController(text: "");
  TextEditingController password  = TextEditingController(text: "");
  bool busy = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: true?Center(
      child: Container(width: 500,decoration: BoxDecoration(border: Border.all(width: 0.2,color: Colors.blue),borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Wrap(children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Text("Login",style: TextStyle(fontSize: 40),),

                TextButton(onPressed: (){
                  context.go("/student-registration");
                 // context.push("/signup");
                }, child: Text("Student registration")),
              ],),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller: email,decoration: InputDecoration(hintText: "Email",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller: password,obscureText: true,decoration: InputDecoration(hintText: "Password",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
            ),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              TextButton(onPressed: (){
                context.go("/signup");
                // context.push("/signup");
              }, child: Text("Sign up as Tutor")),
              TextButton(onPressed: (){
               // GoRouter.of(context).push("/forgot-password");
                // context.push("forgot-password");
                //forgot-password

              }, child: Text("Forgot password?",style: TextStyle(color: Colors.redAccent),)),
            ],),
            busy?Center(child: CircularProgressIndicator(),): InkWell( onTap: () async {
              setState(() {
                busy = true;
              });

              try {


                final credential = await   FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email.text,
                    password: password.text
                );
                print("logged in");
                context.go("/home");
                setState(() {
                  busy = false;
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('No user found for that email.');
                  setState(() {
                    busy = false;
                  });
                } else if (e.code == 'wrong-password') {
                  print('Wrong password provided for that user.');
                  setState(() {
                    busy = false;
                  });
                }
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

          ],),
        ),
      ),
    ): Center(child: Card(
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'RestApi.dart';
class TeacherSignup extends StatefulWidget {
  const TeacherSignup({Key? key}) : super(key: key);

  @override
  State<TeacherSignup> createState() => _TeacherSignupState();
}

class _TeacherSignupState extends State<TeacherSignup> {
  TextEditingController email = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool busy = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child: Container(width: 500,decoration: BoxDecoration(border: Border.all(width: 0.2,color: Colors.blue),borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Wrap(children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Text("Signup",style: TextStyle(fontSize: 40),),
                TextButton(onPressed: (){
                  context.go("/login");
                }, child: Text("Back to login")),
              ],),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller: email,decoration: InputDecoration(hintText: "Email",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller: fname,decoration: InputDecoration(hintText: "First name",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller: lname,decoration: InputDecoration(hintText: "Last name",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller: address,decoration: InputDecoration(hintText: "Address",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller: phone,decoration: InputDecoration(hintText: "Phone",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(controller: password,obscureText: true,decoration: InputDecoration(hintText: "Password",contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0)),),
            ),

            Row(mainAxisAlignment: MainAxisAlignment.end,children: [
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


                final credential = await   FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email.text,
                    password: password.text
                );
                Data().saveTeacher(data: {"id":credential.user!.uid,"LastName":lname.text,"FirstName":fname.text,"Address":address.text,"Email":email.text,"Phone":phone.text,}).then((value) {
                  context.go("/home");

                });
                credential.user!.updateDisplayName(fname.text+" "+lname.text);
                print("logged in");
                setState(() {
                  busy = false;
                });
              } catch(e){
                setState(() {
                  busy = false;
                });
              }

            },
              child: Padding(
                padding: const EdgeInsets.only(top: 8,right: 4,left: 4),
                child: Card(color: Colors.blue,child: Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Create account",style: TextStyle(color: Colors.white),),
                ),),),
              ),
            ),

          ],),
        ),
      ),
    ),);
  }
}


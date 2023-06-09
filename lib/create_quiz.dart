import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './utils.dart';
import 'enums.dart';


class Create_quiz_activity extends StatefulWidget {
  const Create_quiz_activity({Key? key}) : super(key: key);

  @override
  State<Create_quiz_activity> createState() => _Create_quiz_activityState();
}

class _Create_quiz_activityState extends State<Create_quiz_activity> {
  List Options = [];
  int correctOption = 0;
  List<TextEditingController> allController = [];
  questionType qt = questionType.singleChoice;
  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Card(margin: EdgeInsets.zero,shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(0.0),
           ),
             child: Container(height: 130,width: double.infinity,child: Padding(
               padding: const EdgeInsets.only(left: 35),
               child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                 children: [

                   InkWell(onTap: (){
                     Navigator.pop(context);
                   },child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       children: [
                         Icon(Icons.navigate_before_rounded,color: Colors.blue,),
                         Text("Back",style: TextStyle(color: Colors.blue),),
                       ],
                     ),
                   ),),
                   Text("Create a Question",style: TextStyle(fontSize: 35),),


                 ],
               ),
             )),
           ),

          Padding(
            padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
            child: TextField(controller: c1,decoration: InputDecoration(label: Text("Question title")),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
            child: TextField(controller: c2,decoration: InputDecoration(label: Text("Question body")),),
          ),
         if(false) Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8),
            child: ClipRRect(borderRadius: BorderRadius.circular(5),child: Row(
              children: [
                Expanded(child: InkWell( onTap: (){
                  setState(() {
                    qt = (qt == questionType.singleChoice)?questionType.multipleChoice:questionType.singleChoice;
                  });
                  print(qt);
                },
                  child: Container(color: qt == questionType.singleChoice?Colors.blue:Colors.white,
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Single choice",style: TextStyle(color: qt == questionType.multipleChoice?Colors.blue:Colors.white ),),
                    ),),),
                )),
                Expanded(child: InkWell(onTap: (){
                  setState(() {
                    qt = (qt == questionType.singleChoice)?questionType.multipleChoice:questionType.singleChoice;
                  });
                  print(qt);
                },
                  child: Container(color: qt == questionType.multipleChoice?Colors.blue:Colors.white,
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Multiple choice",style: TextStyle(color: qt == questionType.singleChoice?Colors.blue:Colors.white ),),
                    ),),),
                )),
              ],
            ),),
          ),
          Container(
            margin: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 5),
          //  height: double.infinity,
           // width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2)),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                  bottomRight: Radius.circular(2)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),child:Wrap(
              children: [
                 Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Options:", ),
                        ),
                ListView.builder(shrinkWrap: true,
                          itemCount: Options.length,

                          itemBuilder: (context, index) {
                            TextEditingController c = TextEditingController(text: Options[index]);
                            allController.add(c);
                            return ListTile(trailing: IconButton(onPressed: (){
                              allController.removeAt(index);
                              Options.removeAt(index);

                              setState(() {
                              });

                            },icon: Icon(Icons.delete),),leading: Checkbox(value: index==correctOption,onChanged: (bool? b){
                              if(b == true){

                                correctOption = index;
                                setState(() {
                                });
                              }

                            },),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(onChanged: (String s){
                                  Options[index] = s ;
                                },controller: c,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),label: Text("Option "+(index+1).toString())),),
                              ),
                            );
                          },
                        ),
              ],
            ) ,),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell( onTap: (){

                  setState(() {
                    Options.add("");
                  });

                },
                  child: Card(color: Colors.blue,child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                    child: Text("Add Options",style: TextStyle(color: Colors.white),),
                  ),),
                ),
              ],
            ),
          ),

          Center(
            child: InkWell( onTap: (){

              FirebaseFirestore.instance.collection("questions").add({"created_at":DateTime.now().microsecondsSinceEpoch,"score":1,"correctOption":correctOption,"ans":Options[correctOption],"choice":Options,"title":c1.text,"q":c2.text,"quize_type":"SC"});



              // Provider.of<AddedProvider>(context, listen: false).add({"score":1,"correctOption":correctOption,"ans":Options[correctOption],"choice":Options,"title":c1.text,"q":c2.text,"quize_type":"SC"});
              // setState(() {
              // });
              Navigator.pop(context);

            },
              child: Card(color: Colors.blue,child: Container(width: MediaQuery.of(context).size.width * 0.5,
                child: Center(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 18),
                    child: Text("Save",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),),
            ),
          ),

        ],
      ),
    );
  }
}

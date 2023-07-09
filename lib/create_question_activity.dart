import 'package:admin/students_activity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';
import 'RestApi.dart';

class Create_question extends StatefulWidget {
  const Create_question({Key? key}) : super(key: key);

  @override
  State<Create_question> createState() => _Create_questionState();
}

class _Create_questionState extends State<Create_question> {
  List Options = [];
  int correctOption = 0;
  List<TextEditingController> allController = [];

  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  TextEditingController c3 = TextEditingController();
  String selectedClassId = "";
  String selectedSubjectID = "";
  String selectedchapterID = "";

  @override
  Widget build(BuildContext context) {
    return Container(width: 800,height: MediaQuery.of(context).size.height,child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(onTap: (){
          Navigator.pop(context);
        },child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(Icons.close,color: Colors.blue,),
              Text("Close",style: TextStyle(color: Colors.blue),),
            ],
          ),
        ),),
        Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 400,
              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClassSelectDropdown(onSelected: (String id){
                      print("class selested "+id);

                      selectedClassId = id;
                    },),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SubjectSelectDropdown(onSelected: (String id){

                      selectedSubjectID = id;
                    },),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChapterSelectDropdown(onSelected: (String id){
                      print("selected chapter");
                      print(id);

                      selectedchapterID = id;
                    },),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(controller: c1,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),label: Text("Question title")),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(controller: c2,minLines: 1,maxLines: 4,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),label: Text("Question body")),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(controller: c3,minLines: 1,maxLines: 4,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),label: Text("Explanation")),),
                  ),



                ],
              ),
            ),
            Container(width: 400,child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Options:", ),
                    ElevatedButton(onPressed: (){

                      setState(() {
                        Options.add("");
                      });



                    }, child: Text("Add Options")),
                  ],
                ),
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

            ],),),
          ],
        ),
        Center(
          child: InkWell( onTap: (){
            Map re = {"subject_id":selectedSubjectID,"class_id":selectedClassId,"chapter_id":selectedchapterID,"created_by":FirebaseAuth.instance.currentUser!.uid,"explanation":c3.text,"score":1,"correctOption":correctOption,"ans":Options[correctOption],"options":Options,"title":c1.text,"q":c2.text,"type":"SC"};
            print(re);

            Data().savequestion(data:re ).then((value) {

              Data().questionsbyid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
                Provider.of<Questionsprovider>(context, listen: false).items = value;
                Navigator.pop(context);
              });

            });

            // Data().questions().then((value) {
            //   Provider.of<Questionsprovider>(context, listen: false).items = value;
            // });

            //Provider.of<AddedProvider>(context, listen: false).add({"explanation":c3.text,"score":1,"correctOption":correctOption,"ans":Options[correctOption],"options":Options,"title":c1.text,"q":c2.text,"type":"SC"});
            //Provider.of<AddedProviderOnlyNew>(context, listen: false).add({"explanation":c3.text,"score":1,"correctOption":correctOption,"ans":Options[correctOption],"options":Options,"title":c1.text,"q":c2.text,"type":"SC"});



            //   Navigator.pop(context);

          },
            child: Card(color: Colors.blue,child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text("Save",style: TextStyle(color: Colors.white),),
            ),),
          ),
        ),
      ],
    ),);
  }
}

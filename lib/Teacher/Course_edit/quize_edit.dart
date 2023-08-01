import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../AppProviders/DrawerProvider.dart';
import '../../RestApi.dart';
import '../../students_activity.dart';
import '../../styles.dart';

class EditCourseActivity extends StatefulWidget {
  Map<String,dynamic>data;
  EditCourseActivity({required this.data});
  @override
  State<EditCourseActivity> createState() => _CreateCourseActivityState();
}

class _CreateCourseActivityState extends State<EditCourseActivity> {
  TextEditingController c = TextEditingController();
  TextEditingController c_description = TextEditingController();
  TextEditingController c_price = TextEditingController();
  int? class_id;
  int? subject_id;
  List lectures = [];
  List Quizes = [];
  String className = "";
  String subjectName = "";

  @override
  Widget build(BuildContext context) {
    //return Text(widget.data.toString());
    class_id =  widget.data["class_id"];
    subject_id =  widget.data["subject_id"];
    c = TextEditingController(text: widget.data["name"]);
    c_price = TextEditingController(text: widget.data["price"].toString());
    c_description = TextEditingController(text: widget.data["description"]);
    return    Container(
      decoration: boxShadow,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Wrap(
            children: [
            //  Text(widget.data.toString()),
              //lectures

              Container(margin: EdgeInsets.symmetric(horizontal: 8,vertical: 6),decoration: boxShadow,child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Course information"),
                  ],
                ),
              )),
              Row(
                children: [
                  Expanded(flex: 4 ,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(controller:c ,decoration: InputDecoration(label: Text("Course name"),hintText: "Course name"),),
                    ),
                  ),
                  Expanded(flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(controller:c_price ,decoration: InputDecoration(label: Text("Price"),hintText: "Price"),),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(controller:c_description ,decoration: InputDecoration(label: Text("Description"),hintText: "Description"),),
              ),
              // PickPhotoBox(onPhotoPicked: (dynamic data){
              //
              // },),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: FutureBuilder<List>(
                            future: Data().classes(),
                            builder: (context, AsyncSnapshot<List> snap) {
                              if(snap.hasData){
                                List<String> dropdownItems = [];
                                for(int i = 0 ; i < snap.data!.length ;i++){
                                  dropdownItems.add(snap.data![i]["name"]);
                                }
                                if(class_id==null){
                                }else{
                                  for(int j = 0 ; j < snap.data!.length ;j++){
                                    if(class_id==snap.data![j]["id"]){
                                      className = snap.data![j]["name"];
                                      break;
                                    }

                                  }
                                }
                                return  DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSelectedItems: true,
                                  ),
                                  items:dropdownItems,
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal:8),
                                      labelText: "Class",
                                      hintText: "Class",
                                    ),
                                  ),
                                  onChanged: (String? s){

                                    setState(() {
                                      try{
                                        for(int j = 0 ; j < snap.data!.length ;j++){
                                          if(snap.data![j]["name"] == s!){
                                            class_id = snap.data![j]["id"];
                                            break;
                                          }
                                        }
                                      }catch(e){
                                        print(e);
                                      }



                                      className = s!;
                                    });

                                  },
                                  selectedItem:className,
                                );



                              }else{
                                return Text("Geting Data");
                                return Container(height: 0,width: 0,);
                              }

                            }),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child:  Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: FutureBuilder<List>(

                            future: Data().subjects(),
                            builder: (context, AsyncSnapshot<List> snap) {
                              if(snap.hasData){
                                List<String> dropdownItems = [];
                                for(int i = 0 ; i < snap.data!.length ;i++){
                                  dropdownItems.add(snap.data![i]["sName"]);
                                }
                                if(subject_id==null){
                                }else{
                                  for(int j = 0 ; j < snap.data!.length ;j++){
                                    if(subject_id==snap.data![j]["sid"]){
                                      subjectName = snap.data![j]["sName"];
                                      break;
                                    }

                                  }
                                }
                                return  DropdownSearch<String>(
                                  popupProps: PopupProps.menu(
                                    showSelectedItems: true,
                                  ),
                                  items:dropdownItems,
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal:8),
                                      labelText: "Subjects",
                                      hintText: "Select subject",
                                    ),
                                  ),
                                  onChanged: (String? s){
                                    setState(() {
                                      for(int j = 0 ; j < snap.data!.length ;j++){
                                        if(snap.data![j]["sName"] == s!){
                                          subject_id = snap.data![j]["sid"];
                                          break;
                                        }
                                      }
                                      subjectName = s!;
                                    });


                                  },
                                  selectedItem:subjectName,
                                );



                              }else{
                                return Container(height: 0,width: 0,);
                              }

                            }),
                      ),
                    ),
                  )
                ],
              ),

              Container(margin: EdgeInsets.symmetric(horizontal: 8,vertical: 6),decoration: boxShadow,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Text("Lectures"),
                 if(false)   ElevatedButton(onPressed: (){
                      TextEditingController lecturename = TextEditingController();

                      showDialog(
                          context: context,
                          builder: (_) =>StatefulBuilder(
                              builder: (context,setS) {
                                return AlertDialog(content: Container(width: 500,
                                  child: Wrap(children: [
                                    Container(margin: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5),decoration: boxShadow,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text("Lecture name"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(controller:lecturename ,decoration: InputDecoration(),),
                                          ),




                                        ],
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Text("Lecture contents"),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: lectureContents.length==0?Center(child: Text("No contents added",style: TextStyle(color: Colors.grey),),): ListView.builder(shrinkWrap: true,
                                    //     itemCount: lectureContents.length,
                                    //
                                    //     itemBuilder: (context, index) {
                                    //       return Row(
                                    //         children: [
                                    //
                                    //           Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),width: 60,child: Center(child: Text((index+1).toString(),style: TextStyle(color: Colors.grey),))),
                                    //           Expanded(
                                    //             child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                                    //               child: Padding(
                                    //                 padding: const EdgeInsets.symmetric(horizontal: 5),
                                    //                 child: Text(lectureContents[index]),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ],
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          if(false) ElevatedButton(onPressed: (){


                                          }, child: Text("Add lecture content")),
                                        if(false)  ElevatedButton(onPressed: (){
                                            setState(() {
                                              lectures.add({"name":lecturename.text,"contents":[],"quizes":[]});
                                              Navigator.pop(context);
                                            });
                                          }, child: Text("Finish")),
                                        ],
                                      ),
                                    ),

                                  ],),
                                ),title: Text("Add Lecture"),);
                              }
                          ));
                    }, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Add lecture"),

                      ],
                    )),
                  ],),
                ),
              ),


              FutureBuilder<dynamic>(
                  future: Data().lectures(id:widget.data["id"].toString()), // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                           return TeacherLecturedViewEdit(data:snapshot.data![index]);
                            return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.blue.shade200)),margin: EdgeInsets.all(5),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                //  ListTile(trailing: TextButton(onPressed: (){},child: Text("Edit"),),title: Text(snapshot.data![index]["name"],style: TextStyle(color: Colors.blue),),),

                                  // Row(
                                  //   children: [
                                  //     Padding(
                                  //       padding: const EdgeInsets.all(8.0),
                                  //       child: Text("# "+(index+1).toString()),
                                  //     ),
                                  //     Text(snapshot.data![index]["name"]),
                                  //
                                  //   ],
                                  //
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15,top: 15,bottom: 4),
                                    child: Text(snapshot.data![index]["name"],style: TextStyle(color: Colors.blue),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child:  Center(child: Text("Contens",style: TextStyle(color: Colors.black),)), ),
                                        Expanded(child: Center(child: Text("Quizes",style: TextStyle(color: Colors.black),)),),
                                      ],
                                    ),
                                  ),
                                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child:  ListView.builder(shrinkWrap: true,
                                          itemCount: snapshot.data![index]["contents"].length,
                                          itemBuilder: (context, index2) {
                                            return  Container(decoration: BoxDecoration(color: index2.isOdd?Colors.transparent:Colors.blue.shade50,border: Border.all(color: Colors.blue.shade50)),
                                             child: Row(
                                               children: [
                                                 Padding(
                                                   padding: const EdgeInsets.symmetric(horizontal: 8),
                                                   child: Text("# "+(index2+1).toString()),
                                                 ),
                                                 Text(snapshot.data![index]["contents"][index2]["title"].toString()),
                                               ],
                                             ),
                                           );
                                            return ListTile(title: Text(snapshot.data![index]["contents"][index2]["title"].toString()),subtitle: Text(snapshot.data![index]["contents"][index2]["data"].toString()),);
                                            return Text(snapshot.data![index]["contents"][index2]["title"].toString());
                                          }), ),
                                      Expanded(child:  ListView.builder(shrinkWrap: true,
                                          itemCount: snapshot.data![index]["quize"].length,
                                          itemBuilder: (context, index2) {
                                            return  Container(decoration: BoxDecoration(color: index2.isOdd?Colors.transparent:Colors.blue.shade50,border: Border.all(color: Colors.blue.shade50)),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    child: Text("# "+(index2+1).toString()),
                                                  ),
                                                  Text(snapshot.data![index]["quize"][index2]["q_details"]["title"].toString()),
                                                ],
                                              ),
                                            );
                                            return ListTile(title: Text(snapshot.data![index]["quize"][index2]["q_details"]["title"].toString()),);
                                            return Text(snapshot.data![index]["contents"][index2]["title"].toString());
                                          }),),
                                    ],
                                  ),



                                ],
                              ),
                            );
                          });
                      return Text(snapshot.data!.toString());
                    }else{
                      return Text("Please wait");
                    }}),

             if(false) lectures.length==0?Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("No lectures added",style:  TextStyle(color: Colors.grey),),
              ),): ListView.builder(shrinkWrap: true,padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                itemCount: lectures.length,

                itemBuilder: (context, index) {
                  return Container(decoration: boxShadow,margin:EdgeInsets.symmetric(horizontal: 0,vertical: 2) ,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4,bottom: 4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("# "+(1+index).toString(),style: TextStyle(color: Colors.grey),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(lectures[index]["name"]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(lectures[index]["contents"].length.toString()+" contents "+lectures[index]["quizes"].length.toString()+" quizes",style: TextStyle(color: Colors.grey),),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ElevatedButton(onPressed: (){
                                  showDialog(
                                      context: context,
                                      builder: (_) =>StatefulBuilder(
                                          builder: (context,setS) {
                                            return AlertDialog(content: true?Container(height: 500,width: 600,
                                              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  FutureBuilder<List>(
                                                      future: Data().quizesHandelerid(id: FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
                                                      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                                                        if(snapshot.hasData){

                                                          return  ListView.builder(shrinkWrap: true,
                                                            itemCount: snapshot.data!.length,

                                                            itemBuilder: (context, index2) {

                                                              return Opacity( opacity:lectures[index]["quizes"]==null?1: lectures[index]["quizes"].length>0?( lectures[index]["quizes"].contains(snapshot.data![index2]["id"])?0.5:1):1,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(snapshot.data![index2]["title"]),
                                                                      ElevatedButton(onPressed: (){

                                                                        if(lectures[index]["quizes"].contains(snapshot.data![index2]["id"])){
                                                                          try{
                                                                            lectures[index]["quizes"].remove(snapshot.data![index2]["id"]);
                                                                          }catch(e){
                                                                            print(e);
                                                                          }
                                                                          setState(() {

                                                                          });
                                                                          setS(() {

                                                                          });
                                                                        }else{
                                                                          print("add");
                                                                          try{
                                                                            lectures[index]["quizes"].add(snapshot.data![index2]["id"]);
                                                                          }catch(e){
                                                                            print(e);
                                                                          }
                                                                          setState(() {

                                                                          });
                                                                          setS(() {

                                                                          });
                                                                        }

                                                                        Navigator.of(context);
                                                                      }, child: Text(lectures[index]["quizes"].contains(snapshot.data![index2]["id"])?"Remove": "Select"))
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }else{
                                                          return Center(child: CircularProgressIndicator(),);
                                                        }
                                                      }),
                                                  Center(
                                                    child: ElevatedButton(onPressed: (){
                                                      Navigator.pop(context);
                                                    }, child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                                      child: Text("Close"),
                                                    )),
                                                  )
                                                ],
                                              ),
                                            ): Wrap(children: [

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: ElevatedButton(onPressed: (){
                                                  lectures[index]["quizes"].add("1");
                                                  setState(() {

                                                  });
                                                  Navigator.pop(context);

                                                }, child: Text("Add")),
                                              ),
                                            ],),);
                                          }
                                      ));
                                }, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Add Quize"),


                                  ],
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ElevatedButton(onPressed: (){
                                  TextEditingController lecturecontent = TextEditingController();
                                  TextEditingController lecturecontenttitle = TextEditingController();
                                  //List lectureContents = [];
                                  showDialog(
                                      context: context,
                                      builder: (_) =>AlertDialog(content: Wrap(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Title"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(controller:lecturecontenttitle ,decoration: InputDecoration(),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Content Link"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(controller:lecturecontent ,decoration: InputDecoration(),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(onPressed: (){
                                            lectures[index]["contents"].add({"title":lecturecontenttitle.text,"body":lecturecontent.text});
                                            setState(() {

                                            });
                                            Navigator.pop(context);

                                          }, child: Text("Add")),
                                        ),
                                      ],),));


                                }, child: Text("Add Course content"),),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  );
                },
                //   separatorBuilder: (BuildContext context, int index) { return Divider();},
              ),

              Center(
                child: ElevatedButton(child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 6),
                  child: Text("Close"),
                ),onPressed: (){
                  Navigator.pop(context);

                  /*

                  Data().saveBatches(data: {"lectures":lectures,"price":c_price.text,"class_id":class_id,"subject_id":subject_id,"description":c_description.text,"name":c.text,
                    "created_by":FirebaseAuth.instance.currentUser!.uid}).then((value) {

                    Data().batchesid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
                      Provider.of<Batchprovider>(context, listen: false).items = value;
                      Provider.of<DrawerSelectionSub>(context, listen: false).selection = 2;
                      Provider.of<DrawerSelectionSub>(context, listen: false).selectionsub = 1;
                    });
                  });

                   */


                }),
              ),

            ],
          ),
        ),
      ),
    );

  }
}

class TeacherLecturedViewEdit extends StatefulWidget {
  Map<String,dynamic>data;
  TeacherLecturedViewEdit({required this.data});

  @override
  State<TeacherLecturedViewEdit> createState() => _TeacherLecturedViewEditState();
}

class _TeacherLecturedViewEditState extends State<TeacherLecturedViewEdit> {

  bool expandedContents = false;
  bool expandedQuizes = false;
  @override
  Widget build(BuildContext context) {
    return Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),border: Border.all(color: Colors.blue.shade200)),margin: EdgeInsets.all(10),
      child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Padding(
            padding: const EdgeInsets.only(left: 15,top: 15,bottom: 4),
            child: Text(widget.data["name"],style: TextStyle(color: Colors.blue),),
          ),

          ListTile(onTap: (){
            setState(() {
              expandedContents = !expandedContents;
            });
          },leading:expandedContents?Icon(Icons.keyboard_arrow_up_outlined):Icon(Icons.keyboard_arrow_down_outlined) ,title: Text("Contents") ,),

          if(expandedContents)ListView.builder(shrinkWrap: true,
              itemCount: widget.data["contents"].length,
              itemBuilder: (context, index2) {
                return  Container(decoration: BoxDecoration(color: index2.isOdd?Colors.transparent:Colors.blue.shade50,border: Border.all(color: Colors.blue.shade50)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text("# "+(index2+1).toString()),
                        ),
                        Text(widget.data["contents"][index2]["title"].toString()),
                      ],
                    ),
                  ),
                );
                return ListTile(title: Text(widget.data["contents"][index2]["title"].toString()),subtitle: Text(widget.data["contents"][index2]["data"].toString()),);
                return Text(widget.data["contents"][index2]["title"].toString());
              }),
          ListTile(onTap: (){
            setState(() {
              expandedQuizes = !expandedQuizes;
            });
          },leading:expandedQuizes?Icon(Icons.keyboard_arrow_up_outlined):Icon(Icons.keyboard_arrow_down_outlined) ,title: Text("Quize") ,),
          if(expandedQuizes)ListView.builder(shrinkWrap: true,
              itemCount:widget.data["quize"].length,
              itemBuilder: (context, index2) {
                return  Container(decoration: BoxDecoration(color: index2.isOdd?Colors.transparent:Colors.blue.shade50,border: Border.all(color: Colors.blue.shade50)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text("# "+(index2+1).toString()),
                        ),
                        Text(widget.data["quize"][index2]["q_details"]["title"].toString()),
                      ],
                    ),
                  ),
                );
                return ListTile(title: Text(widget.data["quize"][index2]["q_details"]["title"].toString()),);
                return Text(widget.data["contents"][index2]["title"].toString());
              })




        ],
      ),
    );
  }
}

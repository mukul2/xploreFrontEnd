import 'dart:html';

import 'package:admin/styles.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../RestApi.dart';



class CoursesMarketPlace extends StatefulWidget {
  String id;
  CoursesMarketPlace({required this.id});
  @override
  State<CoursesMarketPlace> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CoursesMarketPlace> {

  @override
  Widget build(BuildContext context) {
    double width = 700;
    int columnsCount = 6;

    return FutureBuilder<dynamic>(
        future: Data().subject(id:widget.id.toString()), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            List courses =  snapshot.data["courses"];
            List morecourses =  snapshot.data["courses_similar_class"];
            List all_subjects =  snapshot.data["all_subjects"];
            return Scaffold(appBar: PreferredSize(preferredSize: Size(0,100),child: Card(margin: EdgeInsets.zero,),),body: SingleChildScrollView(child: Padding(
              padding:  EdgeInsets.symmetric(vertical: 25,horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(children: [
                      Text(snapshot.data["Name"],style: TextStyle(color: Colors.black,fontSize: 25),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text("Courses",style: TextStyle(color: Colors.black,fontSize: 25),),
                      ),

                    ],),
                  ),
                  GridView.builder(shrinkWrap: true,
                  // Set padding and spacing between cards.
                  padding: const EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // Set the number of columns based on the device's screen size.
                  crossAxisCount: columnsCount,
                  // Set the aspect ratio of each card.
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  ),
                  // Set the number of items in the grid view.
                  itemCount: courses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(onTap: (){
                      context.push('/course-details/'+courses[index]["id"].toString());
                    },
                      child: Container(decoration: boxShadow2,margin: EdgeInsets.all(5),child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(color: Colors.blue.shade50,height: 120,width: 300,child: Stack(
                            children: [

                            ],
                          ),),
                          Padding(
                            padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                            child: Text(courses[index]["name"]??"--",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3,bottom: 3,left: 8,right: 8),
                            child: Text(courses[index]["description"],style: TextStyle(fontSize: 12),)),

                          Padding(
                            padding: const EdgeInsets.only(top: 3,bottom: 3,left: 8,right: 8),
                            child: Text("৳ "+courses[index]["price"].toString()??"--" ,style: TextStyle(color: Colors.blue),),
                          ),





                        ],
                      )),
                    );
                  }),
                  // Wrap(children:courses.map((e) => InkWell( onTap: (){
                  //   context.push('/course-details/'+e["id"].toString());
                  //   // GoRouter.of(context).push('course-details/'+e["id"].toString());
                  // },
                  //   child: Container(decoration: boxShadow2,width: 300,margin: EdgeInsets.all(5),child: Text(e.toString()),),
                  // )).toList(),),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(children: [
                      Text("More courses on ",style: TextStyle(color: Colors.black,fontSize: 25),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text( snapshot.data["class"]["name"],style: TextStyle(color: Colors.black,fontSize: 25),),
                      ),

                    ],),
                  ),
                  GridView.builder(shrinkWrap: true,
                      // Set padding and spacing between cards.
                      padding: const EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // Set the number of columns based on the device's screen size.
                        crossAxisCount: columnsCount,
                        // Set the aspect ratio of each card.
                        childAspectRatio: 0.9,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      // Set the number of items in the grid view.
                      itemCount: morecourses.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(onTap: (){
                          context.push('/course-details/'+morecourses[index]["id"].toString());
                        },
                          child: Container(decoration: boxShadow2,margin: EdgeInsets.all(5),child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(color: Colors.blue.shade50,height: 120,width: 300,child: Stack(
                                children: [

                                ],
                              ),),
                              Padding(
                                padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                                child: Text(morecourses[index]["name"]??"--",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 3,bottom: 3,left: 8,right: 8),
                                  child: Text(morecourses[index]["description"],style: TextStyle(fontSize: 12),)),

                              Padding(
                                padding: const EdgeInsets.only(top: 3,bottom: 3,left: 8,right: 8),
                                child: Text("৳ "+morecourses[index]["price"].toString()??"--" ,style: TextStyle(color: Colors.blue),),
                              ),





                            ],
                          )),
                        );
                      }),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15,left: 15),
                      child: Text("Subjects you may be intested in",style: TextStyle(color: Colors.black,fontSize: 25),),
                    ),

                  ],),
                  GridView.builder(shrinkWrap: true,
                      // Set padding and spacing between cards.
                      padding: const EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // Set the number of columns based on the device's screen size.
                        crossAxisCount: columnsCount,
                        // Set the aspect ratio of each card.
                        childAspectRatio: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      // Set the number of items in the grid view.
                      itemCount: all_subjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(onTap: (){
                          context.push('/courses/'+all_subjects[index]["id"].toString());
                        },
                          child: Container(decoration: boxShadow2,margin: EdgeInsets.all(5),child: Padding(
                            padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                            child: Center(child: Text(all_subjects[index]["Name"]??"--",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
                          )),
                        );
                      }),


                ],
              ),
            ),),);

            return Scaffold(body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: MediaQuery.of(context).size.width,height: width/3,color: Color.fromARGB(255, 39, 55, 70),child: Center(
                    child: Container(margin: EdgeInsets.all(15), width: width,child:
                    Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(snapshot.data["class_name"],style: TextStyle(color: Colors.yellow),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.navigate_next,color: Colors.yellow),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(snapshot.data["subject_name"],style: TextStyle(color: Colors.yellow),),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Icon(Icons.navigate_next,color: Colors.yellow),
                            // ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(snapshot.data["name"],style: TextStyle(color: Colors.white,fontSize: 25),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8,left: 8),
                          child: Text(snapshot.data["description"],style: TextStyle(color: Colors.grey,fontSize: 18),),
                        ),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text("Created by",style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: TextButton(onPressed: (){},child: Text(snapshot.data["teacher"]["LastName"]+" "+snapshot.data["teacher"]["FirstName"],)),
                          ),
                        ],),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text("Last updated",style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(snapshot.data["updated_at"],style: TextStyle(color: Colors.white),),
                          ),
                        ],),

                      ],
                    ),),
                  ),),
                  Container(width: width,
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
                      // Container(width: width,margin: EdgeInsets.all(10),decoration: boxShadow3,child: Padding(
                      //   padding: const EdgeInsets.all(20.0),
                      //   child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text("What you will learn",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                      //
                      //
                      //     ],
                      //   ),
                      // ),),
                      SelectableText("Course content",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                      //SelectableText(snapshot.data!.toString()),
                      Container(margin: EdgeInsets.only(top: 15),decoration: boxShadow3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!["lecture"].length,
                              itemBuilder: (BuildContext context, int index) {
                                return  ExpandbleWidget(name:snapshot.data!["lecture"][index]["name"],list: snapshot.data!["lecture"][index]["contents"],nofq:snapshot.data!["lecture"][index]["quizes"].length);

                                try{
                                  return Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //  ExpandbleWidget(name:snapshot.data!["lecture"][index]["name"],list: snapshot.data!["lecture"][index]["contents"],),
                                      //     SelectableText( snapshot.data!["lecture"][index]["name"]),
                                      if(false)   ExpandablePanel(
                                        header: Text("Contents"),
                                        collapsed: Text("Contents 1", softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                        expanded: ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                                            itemCount: snapshot.data!["lecture"][index]["contents"].length,
                                            itemBuilder: (BuildContext context, int index2) {

                                              try{
                                                return SelectableText( snapshot.data!["lecture"][index]["contents"][index2]["data"].toString());
                                              }catch(e){
                                                return Text(e.toString());
                                              }
                                            }),

                                      ),
                                      if(false)   ExpandablePanel(
                                        header: Text("quizes"),
                                        collapsed: Text("quizes 1", softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                        expanded: ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                                            itemCount: snapshot.data!["lecture"][index]["quizes"].length,
                                            itemBuilder: (BuildContext context, int index2) {
                                              try{
                                                return SelectableText( snapshot.data!["lecture"][index]["quizes"][index2].toString());
                                              }catch(e){
                                                return Text(e.toString());

                                              }

                                            }),

                                      ),

                                      // Row(
                                      //   children: [
                                      //     Text("Content: "+ snapshot.data!["lecture"][index]["content_count"].toString()+" Quize: "+ snapshot.data!["lecture"][index]["quize_count"].toString(),style: TextStyle(color: Colors.grey),),
                                      //   ],
                                      // ),
                                    ],
                                  );
                                }catch(e){
                                  return Container(height: 0,width: 0,);

                                }

                              }),
                        ),
                      ),

                    ],),
                  ),

                ],
              ),
            ),);
          }else{
            return Center(child: CupertinoActivityIndicator(),);
          }

        });

    return Scaffold(appBar: PreferredSize(preferredSize: Size(0,60),child: Container(child: Column(
      children: [

      ],
    ),),),body: Center(child: Text(widget.id.toString()),),);
  }
}
class ExpandbleWidget extends StatefulWidget {
  String name;
  List list ;
  int nofq;

  ExpandbleWidget({required this.name,required this.list,required this.nofq});

  @override
  State<ExpandbleWidget> createState() => _ExpandbleWidgetState();
}

class _ExpandbleWidgetState extends State<ExpandbleWidget> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(color: Colors.grey.shade300,
        child: InkWell(onTap: (){
          setState(() {
            expanded = !expanded;
          });
        },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        expanded?Icon(Icons.keyboard_arrow_up_outlined):Icon(Icons.keyboard_arrow_down_outlined),
                        Text(widget.name),
                      ],
                    ),
                  ),
                  Text(widget.nofq.toString()+" quizes"),
                ],
              ),
            ),
          ),
        ),
      ),
      if(expanded) ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
          itemCount: widget.list.length,
          itemBuilder: (BuildContext context, int index2) {

            try{
              return Padding(
                padding:  EdgeInsets.symmetric(vertical: 4,horizontal: 34),
                child: Text( widget.list[index2]["data"].toString()),
              );
            }catch(e){
              return Text(e.toString());
            }
          })
    ],);
  }
}
import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:admin/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'AppProviders/DrawerProvider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:pdf/widgets.dart' as pw;

import 'create_quiz.dart';
import 'enums.dart';


class HoverButtons extends StatefulWidget {
  Function(String) onCl;
  QueryDocumentSnapshot data;
  HoverButtons({required this.onCl,required this.data});

  @override
  State<HoverButtons> createState() => _HoverButtonsState();
}

class _HoverButtonsState extends State<HoverButtons> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
   // return Text("OK");
    return  Consumer<QuestionsSelectedProvider>(
        builder: (_, bar, __) => InkWell(onTap: (){},child: Row(children: [
          Checkbox(value: bar.selectedQuestions.contains(widget.data.id),onChanged: (val){
            if(val!){
              bar.add(widget.data.id,widget.data);
              //Provider.of<QuestionsSelectedProvider>(context, listen: false).

            }else{
              bar.remove(widget.data.id);
            }

          },),
      Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
          Text(widget.data["title"]),
          HtmlWidget(widget.data["q"]),
        ],),
      ),



      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        AnimatedContainer( width: hovered ? 100.0 : 100.0,
          height: hovered ? 25 : 20.0,duration: Duration(milliseconds: 200),child: InkWell( onTap: (){
            Map<String,dynamic> json = widget.data.data() as Map<String,dynamic>;
            showBottomSheet(
                context: context,
                builder: (context) => Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.arrow_back_rounded)),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Question")),onChanged: (String d){
                          json["q"] = d;
                        },initialValue:json["q"] ,),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),onChanged: (String d){
                          json["title"] = d;
                        },initialValue:json["title"] ,),
                      ),

                      ListView.builder(shrinkWrap: true,
                          itemCount: json["choice"].length,
                          itemBuilder: (context, index2) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Option "+(index2+1).toString())),onChanged: (String d){
                                json["choice"][index2] = d;
                              },initialValue:json["choice"][index2]),
                            );
                          }),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Correct ans")),onChanged: (String d){
                          json["ans"] = d;
                        },initialValue:json["ans"] ,),
                      ),

                      TextButton(onPressed: (){

                        widget.data.reference.update(json);

                        Navigator.pop(context);
                      }, child: Text("Update")),

                      if(false)   InkWell(onTap: (){
                        FirebaseFirestore.instance.collection("questions").add(json);
                        FirebaseFirestore.instance.collection("questions").add(json);
                        Navigator.pop(context);


                      },),



                    ],
                  ),
                ),
                ));

          },
            child: Container(
      width: 100,
      decoration: BoxDecoration(border: Border.all(color:hovered? Colors.blue:Colors.transparent,width: 0.5),borderRadius: BorderRadius.circular(2)),
      margin: EdgeInsets.all(0),
      child: Visibility(
        visible: hovered,
        child: Center(

            child: Text("Edit",),
        ),
      ),
    ),
          ) ,),
    AnimatedContainer(width: hovered ? 100.0 : 100.0,
      height: hovered ? 25 : 20.0,duration: Duration(milliseconds: 200),child: InkWell( onTap: (){
        Map<String,dynamic> json = widget.data.data() as Map<String,dynamic>;
        showBottomSheet(
            context:context,
            builder: (context) => Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.pop(context);
                              }, icon: Icon(Icons.arrow_back_rounded)),
                            ],
                          ),
                          //bar.selectedQuestionsBody[index].get("choice")

                          // Row(
                          //   children: [
                          //     Text("TYPE :"),
                          //     Text(json["quize_type"]=="SC"?"Single choice":"Multiple choice"),
                          //   ],
                          // ),


                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Question")),onChanged: (String d){
                              json["q"] = d;
                            },initialValue:json["q"] ,),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),onChanged: (String d){
                              json["title"] = d;
                            },initialValue:json["title"] ,),
                          ),
                          ListView.builder(shrinkWrap: true,
                              itemCount: json["choice"].length,
                              itemBuilder: (context, index2) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Option "+(index2+1).toString())),onChanged: (String d){
                                    json["choice"][index2] = d;
                                  },initialValue:json["choice"][index2]),
                                );
                              }),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Correct ans")),onChanged: (String d){
                              json["ans"] = d;
                            },initialValue:json["ans"] ,),
                          ),

                          InkWell(onTap: (){
                            FirebaseFirestore.instance.collection("questions").add(json);
                            FirebaseFirestore.instance.collection("questions").add(json);
                            Navigator.pop(context);


                          },
                            child: Card(color: Colors.blue,child: Center(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Save",style: TextStyle(color: Colors.white),),
                            ),),),
                          ),
                          // Wrap(children:bar.selectedQuestionsBody[index].get("choice").map((e) => Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(3) ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Text(e),
                          //   ),
                          // )).toList() ,),


                        ],
                      ),
                    ),

                  ],
                ))));

      },
        child: Container(
        width: 100,
        decoration: BoxDecoration(border: Border.all(color:hovered? Colors.blue:Colors.transparent,width: 0.5),borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Visibility(
          visible: hovered,
          child: Center(
            child: Text("Duplicate"),
          ),
        ),
    ),
      ),),

      ],),
          Container(width: 100,child: Center(child: Text(widget.data["score"].toString()))),

    ],),onHover: (bool b){
      setState(() {
        hovered = b;
      });
    },));

  }
}

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ListItemsSelectQues extends StatefulWidget {

  QueryDocumentSnapshot data;
  ListItemsSelectQues({required this.data});

  @override
  State<ListItemsSelectQues> createState() => _ListItemsSelectQuesState();
}

class _ListItemsSelectQuesState extends State<ListItemsSelectQues> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    // return Text("OK");
    return  Consumer<QuestionsSelectedProvider>(
        builder: (_, bar, __) => InkWell(onTap: (){},child: Row(children: [
          Checkbox(value: bar.selectedQuestions.contains(widget.data.id),onChanged: (val){
            if(val!){
              bar.add(widget.data.id,widget.data);
              //Provider.of<QuestionsSelectedProvider>(context, listen: false).

            }else{
              bar.remove(widget.data.id);
            }

          },),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text(widget.data["title"]),
              HtmlWidget(widget.data["q"]),
            ],),
          ),



          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
            AnimatedContainer( width: hovered ? 100.0 : 100.0,
              height: hovered ? 25 : 20.0,duration: Duration(milliseconds: 200),child: InkWell( onTap: (){
                Map<String,dynamic> json = widget.data.data() as Map<String,dynamic>;
                showBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.pop(context);
                              }, icon: Icon(Icons.arrow_back_rounded)),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Question")),onChanged: (String d){
                              json["q"] = d;
                            },initialValue:json["q"] ,),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),onChanged: (String d){
                              json["title"] = d;
                            },initialValue:json["title"] ,),
                          ),

                          ListView.builder(shrinkWrap: true,
                              itemCount: json["choice"].length,
                              itemBuilder: (context, index2) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Option "+(index2+1).toString())),onChanged: (String d){
                                    json["choice"][index2] = d;
                                  },initialValue:json["choice"][index2]),
                                );
                              }),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Correct ans")),onChanged: (String d){
                              json["ans"] = d;
                            },initialValue:json["ans"] ,),
                          ),

                          TextButton(onPressed: (){

                            widget.data.reference.update(json);

                            Navigator.pop(context);
                          }, child: Text("Update")),

                          if(false)   InkWell(onTap: (){
                            FirebaseFirestore.instance.collection("questions").add(json);
                            FirebaseFirestore.instance.collection("questions").add(json);
                            Navigator.pop(context);


                          },),



                        ],
                      ),
                    ),
                    ));

              },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(border: Border.all(color:hovered? Colors.blue:Colors.transparent,width: 0.5),borderRadius: BorderRadius.circular(2)),
                  margin: EdgeInsets.all(0),
                  child: Visibility(
                    visible: hovered,
                    child: Center(

                      child: Text("Edit",),
                    ),
                  ),
                ),
              ) ,),
            AnimatedContainer(width: hovered ? 100.0 : 100.0,
              height: hovered ? 25 : 20.0,duration: Duration(milliseconds: 200),child: InkWell( onTap: (){
                Map<String,dynamic> json = widget.data.data() as Map<String,dynamic>;
                showBottomSheet(
                    context:context,
                    builder: (context) => Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height,child: SingleChildScrollView(
                        child: Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, icon: Icon(Icons.arrow_back_rounded)),
                                    ],
                                  ),
                                  //bar.selectedQuestionsBody[index].get("choice")

                                  // Row(
                                  //   children: [
                                  //     Text("TYPE :"),
                                  //     Text(json["quize_type"]=="SC"?"Single choice":"Multiple choice"),
                                  //   ],
                                  // ),


                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Question")),onChanged: (String d){
                                      json["q"] = d;
                                    },initialValue:json["q"] ,),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),onChanged: (String d){
                                      json["title"] = d;
                                    },initialValue:json["title"] ,),
                                  ),
                                  ListView.builder(shrinkWrap: true,
                                      itemCount: json["choice"].length,
                                      itemBuilder: (context, index2) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child:  TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Option "+(index2+1).toString())),onChanged: (String d){
                                            json["choice"][index2] = d;
                                          },initialValue:json["choice"][index2]),
                                        );
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Correct ans")),onChanged: (String d){
                                      json["ans"] = d;
                                    },initialValue:json["ans"] ,),
                                  ),

                                  InkWell(onTap: (){
                                    FirebaseFirestore.instance.collection("questions").add(json);
                                    FirebaseFirestore.instance.collection("questions").add(json);
                                    Navigator.pop(context);


                                  },
                                    child: Card(color: Colors.blue,child: Center(child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Save",style: TextStyle(color: Colors.white),),
                                    ),),),
                                  ),
                                  // Wrap(children:bar.selectedQuestionsBody[index].get("choice").map((e) => Container(margin: EdgeInsets.all(4), decoration: BoxDecoration(border: Border.all(color: Colors.blue),borderRadius: BorderRadius.circular(3) ),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(8.0),
                                  //     child: Text(e),
                                  //   ),
                                  // )).toList() ,),


                                ],
                              ),
                            ),

                          ],
                        ))));

              },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(border: Border.all(color:hovered? Colors.blue:Colors.transparent,width: 0.5),borderRadius: BorderRadius.circular(4)),
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Visibility(
                    visible: hovered,
                    child: Center(
                      child: Text("Duplicate"),
                    ),
                  ),
                ),
              ),),

          ],),
          Container(width: 100,child: Center(child: Text(widget.data["score"].toString()))),

        ],),onHover: (bool b){
          setState(() {
            hovered = b;
          });
        },));

  }
}
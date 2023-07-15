import 'dart:html';

import 'package:admin/styles.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RestApi.dart';

class CourseDetails extends StatefulWidget {
  int id;
  CourseDetails({required this.id});
  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {

  @override
  Widget build(BuildContext context) {
    double width = 700;
    return FutureBuilder<dynamic>(
        future: Data().coursedetails(id:widget.id.toString()), // a previously-obtained Future<String> or null
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
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

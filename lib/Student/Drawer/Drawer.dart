import 'package:admin/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../AppProviders/DrawerProvider.dart';
import '../../Create_Quize/create_quize.dart';
import '../../RestApi.dart';
import '../../course_table.dart';
import '../../create_question_activity.dart';
import '../../students_activity.dart';
import 'data.dart';


class StudentDrawer extends StatefulWidget {
  const StudentDrawer({super.key});

  @override
  State<StudentDrawer> createState() => _TeacherDrawerState();
}
class MyDataPurchasedQuizes extends DataTableSource {
  MyDataPurchasedQuizes(this._data);
  final List<dynamic> _data;

  List selected_quiz = [];
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {


    return DataRow(cells: [
      DataCell(Text(_data[index]['quize']??"-")),

      DataCell(ElevatedButton(onPressed: (){},child: Text("Start Exam"),)),


      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}
class MyQuizesTable2 extends DataTableSource {
  BuildContext context;
  MyQuizesTable2(this._data,this.context);
  final List<dynamic> _data;

  List selected_quiz = [];
  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {


    return DataRow(cells: [
      DataCell(Text(_data[index]['class']??"--")),
      DataCell(Text(_data[index]['subject']??"--")),
      DataCell(Text(_data[index]['chapter']??"--")),
      DataCell(Text(_data[index]['title']??"--")),
      DataCell(Text(_data[index]['section_details']??"--")),
      DataCell(Text(_data[index]['price'].toString()??"--")),

      //   DataCell(Text(_data[index]['title'].toString()??"--")),
      //  DataCell(Text(DateFormat('yyyy-MM-dd hh:mm').format( DateTime.fromMillisecondsSinceEpoch(_data[index]['exam_start']*1000)))),
      //  DataCell(Text(DateFormat('yyyy-MM-dd hh:mm').format( DateTime.fromMillisecondsSinceEpoch(_data[index]['exam_end']*1000)))),
      DataCell(ElevatedButton(onPressed: (){

        showDialog(
            context: context,
            builder: (_) =>AlertDialog(actions: [
              ElevatedButton(onPressed: (){
                Navigator.pop(context);

              }, child: Text("Cancel")),
              ElevatedButton(onPressed: (){
                Map data = {"quize_id":_data[index]['id'],"price":_data[index]['price'],"teacher_id":_data[index]["created_by"],"student_id":FirebaseAuth.instance.currentUser!.uid};
                Data().buycuize(data:data ).then((value) {
                  Navigator.pop(context);

                });




              }, child: Text("Confirm")),
            ],content: Text("Pay "+_data[index]['price'].toString()??"--"+"?"),title: Text("Buy Course",style: TextStyle(fontSize: 15,color: Colors.black),),));

      },child: Text("Buy"),)),



      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}
class _TeacherDrawerState extends State<StudentDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 250,height: MediaQuery.of(context).size.height,decoration: BoxDecoration(color: Colors.white),child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Text("Project name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ),
            ListView.builder(
              itemCount: drawerDataStudent.length,shrinkWrap: true,

              itemBuilder: (context, index) {
                return true?SingleMenu(data: drawerDataStudent[index],position: index,): Column(children: [
                  InkWell(onHover: (bool b){

                  },child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(drawerDataStudent[index]["name"]),
                  ),),
                ],);
              },
            ),
          ],
        ),),
        Container(height: MediaQuery.of(context).size.height,width: 1,color: Colors.grey.shade300,),
        Expanded(child: Consumer<DrawerSelectionSub>(
            builder: (_, bar, __) {

              if(bar.selection == 1 && bar.selectionsub == 1) return  FutureBuilder<List>(
                  future: Data().batches(), // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if(snapshot.hasData){
                      return SingleChildScrollView(
                        child: Center(
                          child: Wrap(children: snapshot.data!.map((e) => InkWell( onTap: (){
                            context.push('/course-details/'+e["id"].toString());
                            // GoRouter.of(context).push('course-details/'+e["id"].toString());
                          },
                            child: Container(decoration: boxShadow2,width: 300,margin: EdgeInsets.all(5),child: Padding(
                              padding:  const EdgeInsets.all(8.0),
                              child: false?Text(e.toString()):
                              Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(color: Colors.blue.shade50,height: 120,width: 300,child: Stack(
                                    children: [

                                    ],
                                  ),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(e["name"]??"--",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3,bottom: 3),
                                    child: Text(e["teacher"]==null?"--":( e["teacher"]["LastName"]+" "+ e["teacher"]["FirstName"]),style: TextStyle(fontSize: 12),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3,bottom: 3),
                                    child: Text("৳ "+e["price"].toString()??"--" ,style: TextStyle(color: Colors.blue),),
                                  ),

                                  // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(e["name"]??"--"),
                                  //     Text("Fee "+e["price"].toString()??"--",style: TextStyle(color: Colors.blue),),
                                  //   ],
                                  // ),
                                  if(false)   Text(e["description"]??"--",style: TextStyle(color: Colors.black54),),
                                  // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                  //   Text("Instructor"),
                                  //   Text(e["teacher"]==null?"--":( e["teacher"]["LastName"]+" "+ e["teacher"]["FirstName"]))
                                  // ],),
                                  if(false)   Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Class"),
                                      Text(e["class_name"]??"--"),
                                    ],
                                  ),
                                  if(false)   e["subject_name"]==null?Container(height: 0,width: 0,): Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Subject"),
                                      Text(e["subject_name"]??"--"),
                                    ],
                                  ),
                                  if(false)   Text("Lectures",style: TextStyle(color: Colors.blue),),
                                  if(false)   Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: ListView.builder(shrinkWrap: true,
                                        itemCount: e["lecture"].length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(e["lecture"][index]["name"]),
                                              Row(
                                                children: [
                                                  Text("Content: "+e["lecture"][index]["content_count"].toString()+" Quize: "+e["lecture"][index]["quize_count"].toString(),style: TextStyle(color: Colors.grey),),
                                                ],
                                              ),
                                            ],
                                          );
                                        }),
                                  ),
                                  // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text("No of lectures"),
                                  //     Text(e["lecture"].length.toString()),
                                  //   ],
                                  // ),



                                  if(false)  Row(mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if(false)    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 3),
                                        child: ElevatedButton(onPressed: (){}, child: Text("See details")),
                                      ),
                                      ElevatedButton(onPressed: (){

                                        showDialog(
                                            context: context,
                                            builder: (_) =>AlertDialog(actions: [
                                              ElevatedButton(onPressed: (){
                                                Navigator.pop(context);

                                              }, child: Text("Cancel")),
                                              ElevatedButton(onPressed: (){
                                                Map data = {"course_id":e["id"],"student_id":FirebaseAuth.instance.currentUser!.uid};
                                                Data().buycourse(data:data ).then((value) {
                                                  Navigator.pop(context);

                                                });




                                              }, child: Text("Confirm")),
                                            ],content: Text("Pay "+e["price"].toString()??"--"+"?"),title: Text("Buy Course",style: TextStyle(fontSize: 15,color: Colors.black),),));

                                      }, child: Text("Buy now")),
                                    ],
                                  ),
                                ],
                              ),
                            ),),
                          )).toList(),),
                        ),
                      );

                    }else{
                      return Center(child: CircularProgressIndicator(),);
                    }
                  });
              if(bar.selection == 1 && bar.selectionsub == 0) return   FutureBuilder<List>(
                  future: Data().getcourse(id: FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

                    if(snapshot.hasData && snapshot.data!.length>0){
                      int columnsCount = ( MediaQuery.of(context).size.shortestSide /200).toInt();
                      return  GridView.builder(shrinkWrap: true,
                          // Set padding and spacing between cards.
                          padding: const EdgeInsets.all(10),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            // Set the number of columns based on the device's screen size.
                            crossAxisCount: columnsCount,
                            // Set the aspect ratio of each card.
                            childAspectRatio:MediaQuery.of(context).size.aspectRatio,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          // Set the number of items in the grid view.
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(onTap: (){
                              context.push('/lectures/'+snapshot.data![index]["course_id"].toString());
                            },
                              child: Container(decoration: boxShadow2,margin: EdgeInsets.all(5),child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(color: Colors.blue.shade50,height: MediaQuery.of(context).size.shortestSide * 0.08,child: Stack(
                                    children: [

                                    ],
                                  ),),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                                    child: Text(snapshot.data![index]["course_name"]??"--",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 3,bottom: 0,left: 8,right: 8),
                                      child: Text(snapshot.data![index]["description"]??"--",style: TextStyle(fontSize: 12),)),
                                  snapshot.data![index]["teacher"]==null?Container(width: 0,height: 0,): Padding(
                                      padding: const EdgeInsets.only(top: 0,bottom: 3,left: 8,right: 8),
                                      child: Text(snapshot.data![index]["teacher"]["LastName"]+" "+snapshot.data![index]["teacher"]["LastName"],style: TextStyle(fontSize: 12,color: Colors.grey),)),






                                ],
                              )),
                            );
                          });

                    }else{
                      return Center(child: Text("No data"),);
                    }

                  });
              if(bar.selection == 0 && bar.selectionsub == 1) return  FutureBuilder<List>(
                  future: Data().quizesX(), // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if(snapshot.hasData && snapshot.data!.length>0){

                      int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
                      final DataTableSource _allUsers = MyQuizesTable2(snapshot.data!,context);
                      return   Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: PaginatedDataTable(
                            // columnSpacing: 10,
                            horizontalMargin: 5,

                            header:null,
                            rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

                            columns: const [
                              DataColumn(label: Text('Title',style: TextStyle(color: Colors.blue),)),
                              DataColumn(label: Text('Details',style: TextStyle(color: Colors.blue),)),
                              DataColumn(label: Text('Price',style: TextStyle(color: Colors.blue),)),
                              DataColumn(label: Text('Class',style: TextStyle(color: Colors.blue),)),
                              DataColumn(label: Text('Subject',style: TextStyle(color: Colors.blue),)),
                              DataColumn(label: Text('Chapter',style: TextStyle(color: Colors.blue),)),
                              DataColumn(label: Text('Action',style: TextStyle(color: Colors.blue),)),

                              // DataColumn(label: Text('Id')),
                              // DataColumn(label: Text('Phone'))
                            ],
                            source: _allUsers,
                          ),
                        ),
                      );
                    }else{
                      return Center(child: Text("No data"),);
                    }

                  });
              if(bar.selection == 0 && bar.selectionsub == 0) return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                child: FutureBuilder<List>(
                    future: Data().mypurchasedquizes(id: FirebaseAuth.instance.currentUser!.uid), // a previously-obtained Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                      if(snapshot.hasData && snapshot.data!.length>0){
                        // return Text(snapshot.data!.toString());
                        int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
                        final DataTableSource _allUsers = MyDataPurchasedQuizes(snapshot.data!);
                        return   Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: PaginatedDataTable(
                            // columnSpacing: 10,
                            horizontalMargin: 5,

                            header:null,
                            rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

                            columns: const [
                              DataColumn(label: Text('Quize title',style: TextStyle(color: Colors.blue),)),

                              DataColumn(label: Text('Actions',style: TextStyle(color: Colors.blue),)),

                              // DataColumn(label: Text('Id')),
                              // DataColumn(label: Text('Phone'))
                            ],
                            source: _allUsers,
                          ),
                        );
                      }else{
                        return Center(child: Text("No data"),);
                      }

                    }),
              );
              return Text(drawerDataStudent[bar.selection]["sub"][bar.selectionsub]);
            })),
      ],
    ),);
  }
}
class SingleMenu extends StatefulWidget {
  Map<String,dynamic>data;
  int position;
  SingleMenu({required this.data,required this.position});
  @override
  State<SingleMenu> createState() => _SingleMenuState();
}

class _SingleMenuState extends State<SingleMenu> {
  bool onHover = false;
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    //DrawerSelection

    return  Consumer<DrawerSelection>(
        builder: (_, bar, __) =>Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [

          InkWell(onTap: (){
            if(widget.position == drawerDataStudent.length - 1)FirebaseAuth.instance.signOut().then((value) {
              GoRouter.of(context).go("/");
            });


            bar.selection = widget.position;
            Provider.of<DrawerSelectionSub>(context, listen: false).selection = widget.position;
            Provider.of<DrawerSelectionSub>(context, listen: false).selectionsub = 0;

            if( bar.selection == widget.position){
              expanded = true;
            }else{
              expanded = false;
            }

          },onHover: (bool b){
            setState(() {
              onHover = b;
            });

          },child: Container(margin: EdgeInsets.symmetric(horizontal: 8,vertical: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color:onHover?Colors.blue.shade50:Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(widget.data["icon"]  ,color:  bar.selection == widget.position?Colors.blue:( Colors.black54)),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          children: [
                            Text(widget.data["name"],style: TextStyle(color:  bar.selection == widget.position?Colors.blue:( Colors.black54)),),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Icon(  bar.selection == widget.position?Icons.keyboard_arrow_down_outlined:Icons.keyboard_arrow_up_outlined,color: onHover?Colors.blue:Colors.black87),
                ],
              ),
            ),
          ),),
          if( bar.selection == widget.position) ListView.builder(padding: EdgeInsets.only(left: 15),
            itemCount: widget.data["sub"].length,shrinkWrap: true,

            itemBuilder: (context, index) {
              return true?SingleMenuSub(data:  widget.data["sub"][index],position: widget.position, positionsub: index,): Column(children: [
                InkWell(onHover: (bool b){

                },child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(drawerDataStudent[index]["name"]),
                ),),
              ],);
            },
          )
        ],));
  }
}



class SingleMenuSub extends StatefulWidget {
  String data;
  int position;
  int positionsub;
  SingleMenuSub({required this.data,required this.position,required this.positionsub});
  @override
  State<SingleMenuSub> createState() => _SingleMenuSubState();
}

class _SingleMenuSubState extends State<SingleMenuSub> {
  bool onHover = false;
  // bool expanded = false;
  @override
  Widget build(BuildContext context) {
    //DrawerSelection

    return  Consumer<DrawerSelectionSub>(
        builder: (_, bar, __) =>Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,children: [

          InkWell(onTap: (){
            bar.selectionsub = widget.positionsub;


            // if( bar.selectionsub == widget.position){
            //   expanded = true;
            // }else{
            //   expanded = false;
            // }

          },onHover: (bool b){
            setState(() {
              onHover = b;
            });

          },child: Container(margin: EdgeInsets.symmetric(horizontal: 8,vertical: 5),decoration: BoxDecoration(borderRadius: BorderRadius.circular(4),color:(bar.selection == widget.position &&  bar.selectionsub == widget.positionsub )?Colors.blue.shade50 :( onHover?Colors.blue.shade50:Colors.transparent)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("-",style: TextStyle(color: (bar.selection == widget.position &&  bar.selectionsub == widget.positionsub ) ?Colors.blue:( Colors.black54))),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(widget.data,style: TextStyle(color: (bar.selection == widget.position &&  bar.selectionsub == widget.positionsub ) ?Colors.blue:( Colors.black54)),),
                      ),
                    ],
                  ),

                  // Icon( expanded?Icons.keyboard_arrow_down_outlined:Icons.keyboard_arrow_up_outlined,color: onHover?Colors.blue:Colors.black87),
                ],
              ),
            ),
          ),),

        ],));
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../RestApi.dart';
import '../../styles.dart';
class CoursesStudent extends StatefulWidget {
  const CoursesStudent({Key? key}) : super(key: key);

  @override
  State<CoursesStudent> createState() => _CoursesStudentState();
}

class _CoursesStudentState extends State<CoursesStudent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar:PreferredSize(preferredSize: Size(0,50),child: Center(
            child: TabBar(isScrollable: true,
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("My Learnings",style: TextStyle(color: Colors.black),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Marketplace",style: TextStyle(color: Colors.black),),
                ),

              ],
            ),
          ),),
          body:  Padding(
            padding: const EdgeInsets.all(30.0),
            child: TabBarView(
              children: [

                FutureBuilder<List>(
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

                        int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
                        final DataTableSource _allUsers = MyDataPurchasedCourses(snapshot.data!);
                        return   PaginatedDataTable(columnSpacing: 10,horizontalMargin: 5,

                          header:null,
                          rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

                          columns: const [
                            DataColumn(label: Text('Course Name',style: TextStyle(color: Colors.blue),)),
                            DataColumn(label: Text('Description',style: TextStyle(color: Colors.blue),)),
                            DataColumn(label: Text('Instructor',style: TextStyle(color: Colors.blue),)),
                            DataColumn(label: Text('Price',style: TextStyle(color: Colors.blue),)),

                            // DataColumn(label: Text('Id')),
                            // DataColumn(label: Text('Phone'))
                          ],
                          source: _allUsers,
                        );
                      }else{
                        return Center(child: Text("No data"),);
                      }

                    }),
                //batches
                FutureBuilder<List>(
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
                    }),

              ],
            ),
          ),
        ));


  }
}
class MyDataPurchasedCourses extends DataTableSource {
  MyDataPurchasedCourses(this._data);
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
      DataCell(Text(_data[index]['course_name']??"--")),
      DataCell(Text(_data[index]['description']??"--")),

      DataCell(Text(_data[index]['teacher']==null?"--":( _data[index]['teacher']["LastName"]+" "+_data[index]['teacher']["FirstName"])??"--")),
      DataCell(Text(_data[index]['price'].toString()??"--")),


      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}
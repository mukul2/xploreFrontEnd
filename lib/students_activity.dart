import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';

import 'AppProviders/DrawerProvider.dart';
import 'RestApi.dart';
import 'edit_question_activity.dart';

class StudentActivitySql extends StatefulWidget {
  // GlobalKey<ScaffoldState> scaffoldKey;
  //CourseTable({required this.scaffoldKey});
  StudentActivitySql();
  @override
  State<StudentActivitySql> createState() => _StudentsState();
}
// The "soruce" of the table
class MyData extends DataTableSource {
  MyData(this._data);
  // GlobalKey<ScaffoldState> key;
  final List<dynamic> _data;


  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {


    return DataRow(cells: [
      DataCell(Text(_data[index]['FirstName']??"--")),
      DataCell(Text(_data[index]['LastName']??"--")),
      DataCell(Text(_data[index]['Email']??"--")),
      DataCell(Text(_data[index]['Phone']??"--")),
      DataCell(Text(_data[index]['created_at']??"--")),



      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}


class _StudentsState extends State<StudentActivitySql> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Data().students().then((value) {
      Provider.of<Studentsprovider>(context, listen: false).items = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget actions = Row(children: [
      TextButton(onPressed: (){}, child: Text("Create Batch"))
    ],);
//Batchprovider
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size(0,50),child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          ElevatedButton(onPressed: (){
            TextEditingController lastname = TextEditingController();
            TextEditingController firstname = TextEditingController();
            TextEditingController address = TextEditingController();
            TextEditingController email = TextEditingController();
            TextEditingController phone = TextEditingController();
            String batch = "";



            showDialog(
                context: context,
                builder: (_) =>StatefulBuilder(
                    builder: (context,set) {
                      return AlertDialog(title: Text("Create Student"),actions: [
                        ElevatedButton(onPressed: () async {
                          saveDb(String id){
                            Data().saveStudents(data: {"id":id,"LastName":lastname.text,"FirstName":firstname.text,"Address":address.text,"Email":email.text,"Phone":phone.text,
                              "class_id":batch,"created_by":FirebaseAuth.instance.currentUser!.uid}).then((value) {
                              Data().students().then((value) {
                                Provider.of<Studentsprovider>(context, listen: false).items = value;
                              });


                            });
                          }
                          try{
                            FirebaseApp app =await Firebase.initializeApp(
                                name:"Default",
                                options: FirebaseOptions(
                                    apiKey: "AIzaSyD5-B3z8MSRQYCFRhtEzqR1fKkcE2Ie5mk",
                                    authDomain: "xplore-education.firebaseapp.com",
                                    projectId: "xplore-education",
                                    storageBucket: "xplore-education.appspot.com",
                                    messagingSenderId: "236257928052",
                                    appId: "1:236257928052:web:f508b9f8a90f3969970221"
                                )
                            );
                            FirebaseAuth firebaseAuth = FirebaseAuth.instanceFor(app: app);
                            FirebaseAuth auth = firebaseAuth;
                            auth.createUserWithEmailAndPassword(email: email.text, password: "123456").then((value) {
                              // value.user!.sendEmailVerification();
                              auth.currentUser!.updateDisplayName(firstname.text+" "+lastname.text);
                              auth.sendPasswordResetEmail(email: email.text);
                              saveDb(value.user!.uid);

                            });
                          }catch(e){
                            FirebaseAuth firebaseAuth= FirebaseAuth.instanceFor(app:  Firebase.app("Default"));
                            FirebaseAuth auth = firebaseAuth;
                            auth.createUserWithEmailAndPassword(email: email.text, password: "123456").then((value) {
                              auth.sendPasswordResetEmail(email: email.text);
                              auth.currentUser!.updateDisplayName(firstname.text+" "+lastname.text);

                              saveDb(value.user!.uid);
                            });

                          }









                          Navigator.pop(context);

                        }, child: Text("Create Student")),
                      ],content: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(width: 400,
                          child: Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(controller:lastname ,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8),hintText: "Last Name"),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(controller:firstname ,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8),hintText: "First Name"),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(controller:address ,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8),hintText: "Address"),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(controller:email ,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8),hintText: "Email"),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(controller:phone ,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8),hintText: "Phone"),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClassSelectDropdown(onSelected: (String id){
                                  print("Seleected id"+id);
                                  batch = id;
                                },),
                              ),
                            ],
                          ),
                        ),
                      ),);
                    }
                ));

          }, child: Text("Create Student"))
        ],),
      ),),
      body: true? Consumer<Studentsprovider>(
        builder: (_, bar, __) {

          if(bar.items.isEmpty)return Center(child: Text("No data"),);
        //  return Text(bar.items.toString());

          int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
          final DataTableSource _allUsers = MyData(bar.items);
          return SingleChildScrollView(
            child: PaginatedDataTable(

              header:null,
              rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

              columns: const [
                DataColumn(label: Text('First name')),
                DataColumn(label: Text('Last name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Created at')),

                // DataColumn(label: Text('Id')),
                // DataColumn(label: Text('Phone'))
              ],
              source: _allUsers,
            ),
          );

        },
      ): FutureBuilder(

          future:Data().batches(),
          builder: (context, AsyncSnapshot<List> snap) {
            if(snap.hasData && snap.data!.length>0){

              int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
              final DataTableSource _allUsers = MyData(snap.data!);
              return SingleChildScrollView(
                child: PaginatedDataTable(

                  header:null,
                  rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

                  columns: const [
                    DataColumn(label: Text('Name')),

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

    return  Scaffold(
      body: StreamBuilder(

          stream:FirebaseFirestore.instance.collection('courses').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snap) {


            if(snap.hasData){
              final DataTableSource _allUsers = MyData(snap.data!.docs);
              int n =( ( MediaQuery.of(context).size.height - 100 ) / 55 ).toInt() ;
              return SingleChildScrollView(
                child: PaginatedDataTable(
                  header: null,
                  rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,
                  columns: const [
                    DataColumn(label: Text('Batch name')),
                    DataColumn(label: Text('Number of students')),
                    DataColumn(label: Text('Total apply')),

                    // DataColumn(label: Text('Id')),
                    // DataColumn(label: Text('Phone'))
                  ],
                  source: _allUsers,
                ),
              );
            }
            else{
              return new Text('No data...');
            }
          }),
    );



  }
}

class BatchSelectDropdown extends StatefulWidget {
  Function(String)onSelected;
  BatchSelectDropdown({required this.onSelected});

  @override
  State<BatchSelectDropdown> createState() => _BatchSelectDropdownState();
}

class _BatchSelectDropdownState extends State<BatchSelectDropdown> {
  String selected = "";
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 0),
      child: FutureBuilder<List>(

          future:Data().batches(),
          builder: (context, AsyncSnapshot<List> snap) {
            if(snap.hasData){
              List<String> dropdownItems = [];

              for(int i = 0 ; i < snap.data!.length ;i++){
               try{
                 dropdownItems.add(snap.data![i]["name"]);
               }catch(e){

               }
              }
              return  DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  // disabledItemFn: (String s) => s.startsWith('I'),
                ),
                items:dropdownItems,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal:8),
                    labelText: "Batch/Course",
                    hintText: "Batch/Course",
                  ),
                ),
                onChanged: (String? s){
                  setState(() {
                    for(int j = 0 ; j < snap.data!.length ;j++){
                      if(snap.data![j]["name"] == s!){
                        widget.onSelected(snap.data![j]["id"].toString());
                        break;
                      }
                    }


                    selected = s!;
                  });
                },
                selectedItem:selected,
              );
              return  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),border: Border.all(color: Colors.grey)),
                  child: DropdownButton<String>(
                    //value: dropDownString,
                    items:dropdownItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(width: 352,child: Text(value)),
                      );
                    }).toList(),
                    onChanged: (String? s) {
                      setState(() {

                      });
                    },
                  ),
                ),
              );


            }else{
              return Container(height: 0,width: 0,);
            }

          }),
    );
  }
}





class ClassSelectDropdown extends StatefulWidget {
  Function(String)onSelected;
  ClassSelectDropdown({required this.onSelected});

  @override
  State<ClassSelectDropdown> createState() => _ClassSelectDropdownState();
}

class _ClassSelectDropdownState extends State<ClassSelectDropdown> {
  String selected = "";
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<List>(

          future:Data().classes(),
          builder: (context, AsyncSnapshot<List> snap) {
            if(snap.hasData){
              List<String> dropdownItems = [];

              for(int i = 0 ; i < snap.data!.length ;i++){
                dropdownItems.add(snap.data![i]["name"]);
              }
            return  DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                 // disabledItemFn: (String s) => s.startsWith('I'),
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
                    for(int j = 0 ; j < snap.data!.length ;j++){
                      if(snap.data![j]["name"] == s!){
                        widget.onSelected(snap.data![j]["id"].toString());
                        break;
                      }
                    }


                    selected = s!;
                  });
                },
                selectedItem:selected,
              );
              return  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(3),border: Border.all(color: Colors.grey)),
                  child: DropdownButton<String>(
                    //value: dropDownString,
                    items:dropdownItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(width: 352,child: Text(value)),
                      );
                    }).toList(),
                    onChanged: (String? s) {
                      setState(() {

                      });
                    },
                  ),
                ),
              );


            }else{
              return Container(height: 0,width: 0,);
            }

          }),
    );
  }
}

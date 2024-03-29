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
      DataCell(Text(_data[index]['course']??"--")),
      DataCell(Text(_data[index]['student']??"--")),
     // DataCell(Text(_data[index]['paid'].toString()??"--")),




      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}

class MyDataWallet2 extends DataTableSource {
  MyDataWallet2(this._data);
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
      DataCell(Text(_data[index]['course']??"--")),
      DataCell(Text(_data[index]['student']??"--")),
      DataCell(Text(_data[index]['paid'].toString()??"--")),




      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}
class _StudentsState extends State<StudentActivitySql> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Data().mystudents(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
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
         if(false) ElevatedButton(onPressed: (){
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
                              Data().studentsid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
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
          return Padding(
            padding: const EdgeInsets.only(left:10,right: 10,bottom: 20,top: 0),
            child: PaginatedDataTable(

              header:Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Container(width: 300,height: 40,child: TextFormField(decoration: InputDecoration(hintText: "Search here"),),),

                  ],
                ),
              ),
              rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,

              columns: const [
                DataColumn(label: Text('Course')),
                DataColumn(label: Text('Student')),
              //  DataColumn(label: Text('Paid')),


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


class Wallet extends StatefulWidget {
  // GlobalKey<ScaffoldState> scaffoldKey;
  //CourseTable({required this.scaffoldKey});
  Wallet();
  @override
  State<Wallet> createState() => _WalletState();
}
// The "soruce" of the table
class MyDataWallet extends DataTableSource {
  MyDataWallet(this._data);
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
      DataCell(Text(_data[index]['course']??"--")),
      DataCell(Text(_data[index]['student']??"--")),
      DataCell(Text(_data[index]['paid'].toString()??"--")),




      // DataCell(Text(_data[index].data()["phone"])),
    ]);
  }
}


class _WalletState extends State<Wallet> {
  double earning = 0.0;
  List paidStudents = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Data().myearning(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
      setState(() {
        earning = value["total_earning"];
        paidStudents = value["list"];
      });
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
          if(false) ElevatedButton(onPressed: (){
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
                              Data().studentsid(id: FirebaseAuth.instance.currentUser!.uid).then((value) {
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
      body: true?  Consumer<Studentsprovider>(
        builder: (_, barX, __) {

          if(paidStudents.length==0)return Center(child: Text("No data"),);

          //  return Text(bar.items.toString());

          int n =( ( MediaQuery.of(context).size.height - 140 ) / 55 ).toInt() ;
          final DataTableSource _allUsers = MyDataWallet(paidStudents);

          return SingleChildScrollView(
            child: PaginatedDataTable(

              header:Text("Total Earning "+earning.toString()),
             rowsPerPage: _allUsers.rowCount>n?n:_allUsers.rowCount,
             // rowsPerPage: 10,

              columns:  [
                DataColumn(label: Text('Course')),
                DataColumn(label: Text('Student')),
                DataColumn(label: Text('Paid')),


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



//Wallet

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

          future:Data().batchesid(id: FirebaseAuth.instance.currentUser!.uid),
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
  String? uid;
  ClassSelectDropdown({required this.onSelected});

  @override
  State<ClassSelectDropdown> createState() => _ClassSelectDropdownState();
}

class _ClassSelectDropdownState extends State<ClassSelectDropdown> {
  String selected = "";
  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionSortsprovider>(
        builder: (_, bar, __) {
      if(bar.class_id==null){
        selected = "";
      }
      return  Padding(
        padding: const EdgeInsets.only(top: 8),
        child: FutureBuilder<List>(

            future:widget.uid==null?Data().classes(): Data().classes(),
            builder: (context, AsyncSnapshot<List> snap) {
              if(snap.hasData){
                Text(snap.data!.toString());
                List<String> dropdownItems = [];

                for(int i = 0 ; i < snap.data!.length ;i++){
                  dropdownItems.add(snap.data![i]["name"]);
                }

                if(Provider.of<QuestionSortsprovider>(context, listen: false).class_id==null){
                }else{
                  for(int j = 0 ; j < snap.data!.length ;j++){
                    if(Provider.of<QuestionSortsprovider>(context, listen: false).class_id==snap.data![j]["id"]){
                      selected = snap.data![j]["name"];
                      break;
                    }

                  }
                }

                // selected = snap.data![3]["name"];

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


                    if(s == "All"){
                      widget.onSelected("0");
                    }else{
                      setState(() {
                        try{
                          for(int j = 0 ; j < snap.data!.length ;j++){
                            if(snap.data![j]["name"] == s!){
                              widget.onSelected(snap.data![j]["id"].toString());
                              Provider.of<QuestionSortsprovider>(context, listen: false).class_id = snap.data![j]["id"];
                              break;
                            }
                          }
                        }catch(e){
                          print(e);
                          widget.onSelected("0");
                        }



                        selected = s!;
                      });
                    }

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
                return Text("Geting Data");
                return Container(height: 0,width: 0,);
              }

            }),
      );
        });

  }
}


class SubjectSelectDropdown extends StatefulWidget {
  Function(String)onSelected;
  SubjectSelectDropdown({required this.onSelected});

  @override
  State<SubjectSelectDropdown> createState() => _SubjectSelectDropdownState();
}

class _SubjectSelectDropdownState extends State<SubjectSelectDropdown> {
  String selected = "";
  @override
  Widget build(BuildContext context) {
    //QuestionSortsprovider

  return  Consumer<QuestionSortsprovider>(
        builder: (_, bar, __) {
          if(bar.subject_id==null){
            selected = "";
          }
        return  Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FutureBuilder<List>(

                future: bar.class_id==null?Data().subjects(): Data().subjectsinclass(bar.class_id.toString()),
                builder: (context, AsyncSnapshot<List> snap) {

                  if(snap.hasData){
                    // return Text(snap.data!.toString());
                    List<String> dropdownItems = [];
                    for(int i = 0 ; i < snap.data!.length ;i++){
                      dropdownItems.add(snap.data![i]["sName"]);
                    }
                    if(Provider.of<QuestionSortsprovider>(context, listen: false).subject_id==null){
                    }else{
                      for(int j = 0 ; j < snap.data!.length ;j++){
                        if(Provider.of<QuestionSortsprovider>(context, listen: false).subject_id==snap.data![j]["sid"]){
                          selected = snap.data![j]["sName"];
                          break;
                        }

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
                          labelText: "Subjects",
                          hintText: "Select subject",
                        ),
                      ),
                      onChanged: (String? s){

                        if(s == "All"){
                          // Provider.of<QuestionSortsprovider>(context, listen: false).subject_id = 0;
                          widget.onSelected("0");
                        }else{
                          setState(() {
                            for(int j = 0 ; j < snap.data!.length ;j++){
                              if(snap.data![j]["sName"] == s!){
                                widget.onSelected(snap.data![j]["sid"].toString());
                                Provider.of<QuestionSortsprovider>(context, listen: false).subject_id = snap.data![j]["sid"];
                                break;
                              }
                            }


                            selected = s!;
                          });
                        }


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
        });
        return  Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<List>(

          future:Data().subjects(),
          builder: (context, AsyncSnapshot<List> snap) {

            if(snap.hasData){
             // return Text(snap.data!.toString());
              List<String> dropdownItems = [];
              for(int i = 0 ; i < snap.data!.length ;i++){
                dropdownItems.add(snap.data![i]["sName"]);
              }
              return  DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  // disabledItemFn: (String s) => s.startsWith('I'),
                ),
                items:dropdownItems,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal:8),
                    labelText: "Subjects",
                    hintText: "Select subject",
                  ),
                ),
                onChanged: (String? s){

    if(s == "All"){
     // Provider.of<QuestionSortsprovider>(context, listen: false).subject_id = 0;
      widget.onSelected("0");
    }else{
      setState(() {
        for(int j = 0 ; j < snap.data!.length ;j++){
          if(snap.data![j]["sName"] == s!){
            widget.onSelected(snap.data![j]["sid"].toString());
           // Provider.of<QuestionSortsprovider>(context, listen: false).subject_id = snap.data![j]["sid"];
            break;
          }
        }


        selected = s!;
      });
    }


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


class ChapterSelectDropdown extends StatefulWidget {
  Function(String)onSelected;
  ChapterSelectDropdown({required this.onSelected});

  @override
  State<ChapterSelectDropdown> createState() => _ChapterSelectDropdownState();
}

class _ChapterSelectDropdownState extends State<ChapterSelectDropdown> {
  String selected = "";
  @override
  Widget build(BuildContext context) {
    return  Consumer<QuestionSortsprovider>(
        builder: (_, bar, __) {
          if(bar.chapter_id==null){
            selected = "";
          }
         return Padding(
           padding: const EdgeInsets.only(top: 8),
           child: FutureBuilder<List>(

               future: bar.subject_id==null?Data().chapters():Data().chaptersonsubject(bar.subject_id.toString()),
               builder: (context, AsyncSnapshot<List> snap) {

                 if(snap.hasData){
                   //  return Text(snap.data!.toString());
                   List<String> dropdownItems = [];

                   for(int i = 0 ; i < snap.data!.length ;i++){
                     dropdownItems.add(snap.data![i]["cname"]);
                   }
                   if(Provider.of<QuestionSortsprovider>(context, listen: false).chapter_id==null){
                   }else{
                     for(int j = 0 ; j < snap.data!.length ;j++){
                       if(Provider.of<QuestionSortsprovider>(context, listen: false).chapter_id==snap.data![j]["cId"]){
                         selected = snap.data![j]["cname"];
                         break;
                       }

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
                         labelText: "Chapter",
                         hintText: "Select chapter",
                       ),
                     ),
                     onChanged: (String? s){
                       if(s == "All"){
                         widget.onSelected("0");
                         //  Provider.of<QuestionSortsprovider>(context, listen: false).chapter_id = 0;
                       }else{
                         setState(() {
                           for(int j = 0 ; j < snap.data!.length ;j++){
                             if(snap.data![j]["cname"] == s!){
                               widget.onSelected(snap.data![j]["cId"].toString());
                               // Provider.of<QuestionSortsprovider>(context, listen: false).chapter_id = snap.data![j]["cId"];
                               break;
                             }
                           }


                           selected = s!;
                         });
                       }

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
        });
      Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<List>(

          future:Data().chapters(),
          builder: (context, AsyncSnapshot<List> snap) {

            if(snap.hasData){
            //  return Text(snap.data!.toString());
              List<String> dropdownItems = [];

              for(int i = 0 ; i < snap.data!.length ;i++){
                dropdownItems.add(snap.data![i]["cname"]);
              }
              return  DropdownSearch<String>(
                popupProps: PopupProps.menu(
                  showSelectedItems: true,
                  // disabledItemFn: (String s) => s.startsWith('I'),
                ),
                items:dropdownItems,
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal:8),
                    labelText: "Chapter",
                    hintText: "Select chapter",
                  ),
                ),
                onChanged: (String? s){
    if(s == "All"){
    widget.onSelected("0");
  //  Provider.of<QuestionSortsprovider>(context, listen: false).chapter_id = 0;
    }else{
      setState(() {
        for(int j = 0 ; j < snap.data!.length ;j++){
          if(snap.data![j]["cname"] == s!){
            widget.onSelected(snap.data![j]["cId"].toString());
           // Provider.of<QuestionSortsprovider>(context, listen: false).chapter_id = snap.data![j]["cId"];
            break;
          }
        }


        selected = s!;
      });
    }

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
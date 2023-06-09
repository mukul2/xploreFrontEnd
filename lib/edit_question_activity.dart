import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'enums.dart';

class Edit_quiz_activity extends StatefulWidget {
  QueryDocumentSnapshot ref;
  Edit_quiz_activity({required this.ref});

  @override
  State<Edit_quiz_activity> createState() => _Edit_quiz_activityState();
}

class _Edit_quiz_activityState extends State<Edit_quiz_activity> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller1.text = widget.ref.get("title");
    controller2.text = widget.ref.get("num_retakes");
    controller3.text = widget.ref.get("course_id");
    controller4.text = widget.ref.get("exam_time");
    controller5.text = widget.ref.get("total_point");
    controller6.text = widget.ref.get("pass_mark");
    controller7.text = widget.ref.get("exam_start");
    controller8.text = widget.ref.get("exam_end");
    controller9.text = widget.ref.get("status");
    controller10.text = widget.ref.get("section_details");
    setState(() {

    });
  }
  questionType qt = questionType.singleChoice;
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  TextEditingController controller7 = TextEditingController();
  TextEditingController controller8 = TextEditingController();
  TextEditingController controller9 = TextEditingController();
  TextEditingController controller10 = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(child: Column(
      children: [
        Row(
          children: [
            Expanded(flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: controller1,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Title")),),
              ),
            ),
            Expanded(flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: controller2,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Number of quiz takes")),),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:true?FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection("courses").orderBy("course_title").get(), // a previously-obtained Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.hasData){
                        List<String>all = [];
                        List<String>allId = [];
                        for(int  i = 0; i < snapshot.data!.docs.length ; i++){
                          all.add(snapshot.data!.docs[i].get("course_title"));
                          allId.add(snapshot.data!.docs[i].id);
                        }

                        return DropdownSearch<String>(selectedItem: widget.ref.get("course_id"), onChanged: (String? s){
                          controller3.text =allId[all.indexOf(s!)];
                        },
                          items: all,
                        );
                      }else{
                        return CupertinoActivityIndicator();
                      }
                    }): TextField(controller: controller3,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Course")),),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(textAlign: TextAlign.end,onTap: () async {
                  var duration = await showDurationPicker(
                    context: context,
                    initialTime: Duration(minutes: 30),
                  );
                  setState(() {
                    String twoDigits(int n) => n.toString().padLeft(2, "0");
                    String twoDigitMinutes = twoDigits(duration!.inMinutes.remainder(60));
                    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

                    controller4.text = "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
                  });

                },controller: controller4,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Eaxm Duration Time(H:M:S)")),),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: controller5,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Total Exam Marks")),),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(controller: controller6,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Pass Mark")),),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding:  EdgeInsets.all(8.0),
                child: true? Wrap(
                  children: [
                    Text("Exam start time"),
                    DateTimeField(controller:controller7 ,
                      format: DateFormat("yyyy-MM-dd HH:mm"),
                      onShowPicker: (context, currentValue) async {
                        return await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        ).then((DateTime? date) async {
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        });
                      },
                    ),
                  ],
                ): TextField(onTap: () async {


                  // dt. DatePicker.showDateTimePicker(context,
                  //     showTitleActions: true,
                  //     minTime: DateTime(2020, 5, 5, 20, 50),
                  //     maxTime: DateTime(2020, 6, 7, 05, 09), onChanged: (date) {
                  //       print('change $date in time zone ' +
                  //           date.timeZoneOffset.inHours.toString());
                  //     }, onConfirm: (date) {
                  //       print('confirm $date');
                  //     }, locale: dt.LocaleType.en);
                  // DatePicker.showDatePicker(
                  //   context,
                  //   dateFormat: 'dd MMMM yyyy HH:mm',
                  //   initialDateTime: DateTime.now(),
                  //   minDateTime: DateTime(2000),
                  //   maxDateTime: DateTime(3000),
                  //   onMonthChangeStartWithFirstDate: true,
                  //   onConfirm: (dateTime, List<int> index) {
                  //     DateTime selectdate = dateTime;
                  //     final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
                  //     print(selIOS);
                  //   },
                  // );
                  // DateTime? pickedDate = await showDatePicker(
                  //     context: context,
                  //     initialDate: DateTime.now(),
                  //     firstDate: DateTime(1950),
                  //     //DateTime.now() - not to allow to choose before today.
                  //     lastDate: DateTime(2100));
                  //
                  // if (pickedDate != null) {
                  //   print(
                  //       pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  //   String formattedDate =
                  //   DateFormat('yyyy-MM-dd HH:mm').format(pickedDate);
                  //   print(
                  //       formattedDate); //formatted date output using intl package =>  2021-03-16
                  //   setState(() {
                  //     controller7.text = formattedDate; //set output date to TextField value.
                  //   });
                  // } else {}



                },controller: controller7,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Exam Start Date")),),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Wrap(
                  children: [
                    Text("Exam start time"),
                    DateTimeField(controller:controller8 ,
                      format:  DateFormat("yyyy-MM-dd HH:mm"),
                      onShowPicker: (context, currentValue) async {
                        return await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                        ).then((DateTime? date) async {
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: true?Wrap(
                  children: [
                    Text("Published"),
                    DropdownSearch<String>(
                      items: ["Yes","No"],onChanged: (String? s){
                      controller9.text = s!;
                    },
                    ),
                  ],
                ): TextField(controller: controller9,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Published")),),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child: TextField(decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 10),label: Text("Pass Mark")),),
              ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(controller: controller10,minLines: 7,maxLines: 10,decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),label: Text("Quiz Content")),),
        ),
      ],
    ),);
  }
}

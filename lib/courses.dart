import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CourseTab extends StatefulWidget {
  const CourseTab({Key? key}) : super(key: key);

  @override
  State<CourseTab> createState() => _CourseTabState();
}

class _CourseTabState extends State<CourseTab> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(body: Row(
      children: [
        Expanded(
          child: DropdownSearch<int>(
            items: [1, 2, 3, 4, 5, 6, 7],
          ),
        ),
        Padding(padding: EdgeInsets.all(4)),
        Expanded(
          child: DropdownSearch<int>.multiSelection(
            clearButtonProps: ClearButtonProps(isVisible: true),
            items: [1, 2, 3, 4, 5, 6, 7],
          ),
        )
      ],
    ),);
  }
}

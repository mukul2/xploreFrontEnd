import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

class Quizes_All extends StatefulWidget {
  const Quizes_All({Key? key}) : super(key: key);

  @override
  State<Quizes_All> createState() => _Questions_AllState();
}

class _Questions_AllState extends State<Quizes_All> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FirestoreQueryBuilder(
      query: FirebaseFirestore.instance.collection("questions"),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }

        return ListView.builder(shrinkWrap: true,
          itemCount: snapshot.docs.length,
          itemBuilder: (context, index) {
            // if we reached the end of the currently obtained items, we try to
            // obtain more items
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }

            final movie = snapshot.docs[index];
            return Text(movie.get("title") );
          },
        );
      },
    ),);
  }
}

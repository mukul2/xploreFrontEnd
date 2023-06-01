import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

class QuizFromFirebase extends StatefulWidget {
  const QuizFromFirebase({Key? key}) : super(key: key);

  @override
  State<QuizFromFirebase> createState() => _QuizFromFirebaseState();
}

class _QuizFromFirebaseState extends State<QuizFromFirebase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: FirestoreQueryBuilder(
      query: FirebaseFirestore.instance.collection("quizz2"),
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
            return ListTile(trailing: IconButton(onPressed: (){movie.reference.delete();},icon: Icon(Icons.delete),),title:Text(movie.get("title")) ,subtitle: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(movie.get("questions").length.toString()+" questions"),
                ),
                Text(movie.get("totalMarks").toString()+" marks")
              ],
            ),);
            return Text(movie.get("title") );
          },
        );
      },
    ),);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../RestApi.dart';
import '../../Video_player/player.dart';
import '../../Video_player/utube_player.dart';
import '../../course_details.dart';
import '../../styles.dart';

class Lectures extends StatefulWidget {
  int id;
  Lectures({required this.id});
  @override
  State<Lectures> createState() => _LecturesState();
}

class _LecturesState extends State<Lectures> {
  @override
  void dispose() {
    // TODO: implement dispose
    controller = null;
    Linkcontroller!.dispose();

    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  Map<String,dynamic>? selectedContent;
  Map<String,dynamic>? selectedQuize;
  int selected = 0;
  Widget? videoWid;
  YoutubePlayerController? controller;
   VideoPlayerController? Linkcontroller;
  @override
  Widget build(BuildContext context) {
    double width = 900;
    return FutureBuilder<dynamic>(
        future: Data().coursedetails(id:widget.id.toString()), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            List lectures = snapshot.data!["lecture"];

            return   Scaffold(
              appBar: PreferredSize(preferredSize: Size(0,100),child: Card(color: Color.fromARGB(255, 39, 55, 70),
                child: true?ListTile(subtitle:Text(snapshot.data["description"],style: TextStyle(color: Colors.grey,),) ,title: Text(snapshot.data["name"],style: TextStyle(color: Colors.white,),) ,): Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: width,child:  Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      if(false)  Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text(snapshot.data["class_name"],style: TextStyle(color: Colors.yellow),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.navigate_next,color: Colors.yellow),
                            ),
                            InkWell( onTap: (){
                              context.push('/courses/'+snapshot.data["subject_id"].toString());
                            },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(snapshot.data["subject_name"],style: TextStyle(color: Colors.yellow),),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Icon(Icons.navigate_next,color: Colors.yellow),
                            // ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 4,bottom: 2),
                          child: Text(snapshot.data["name"],style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3,left: 0),
                          child: Text(snapshot.data["description"],style: TextStyle(color: Colors.grey,fontSize: 18),),
                        ),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text("Created by",style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: TextButton(onPressed: (){},child: Text(snapshot.data["teacher"]["LastName"]+" "+snapshot.data["teacher"]["FirstName"],)),
                          ),
                        ],),
                        if(false)  Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text("Last updated",style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(snapshot.data["updated_at"],style: TextStyle(color: Colors.white),),
                          ),
                        ],),
                      ],
                    ),),

                    // TabBar(isScrollable: true,tabs: lectures.map((e) => TextButton(onPressed: (){}, child: Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(e["name"]),
                    // ))).toList()),
                  ],
                ),
              ),),
              body: true?Row(children: [
                Expanded(child: selectedContent==null?Center(child: Text("Select a content or quize")):Container(height: MediaQuery.of(context).size.height *0.8,child: videoWid)),
                Container(decoration: boxShadow3,width: 300,child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Padding(
                      padding: const EdgeInsets.only(top: 12,bottom: 10,left: 8),
                      child: SelectableText("Lectures",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                    ),
                    Expanded(
                      child: Container(color: Colors.grey.shade100,
                        child: ListView(shrinkWrap: true,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            //SelectableText(snapshot.data!.toString()),
                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!["lecture"].length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return  ExpandbleWidget(selectedQuize: (Map<String,dynamic> data){
                                      setState(() {
                                        selectedQuize = data;
                                      });



                                    } ,quizes:snapshot.data!["lecture"][index]["quizes"],selectedContent: (Map<String,dynamic> data){
                                      setState(() {
                                        print("vid wid reset");
                                        selectedContent = data;
                                        videoWid = Container(child: CupertinoActivityIndicator(),);
                                      });
                                      setState(() {


                                        if( selectedContent!["data"].toString().contains("youtube")){
                                          String id =  selectedContent!["data"].toString().split("watch?v=").last;


                                          if(controller!=null){

                                            controller = null;
                                            setState(() {

                                            });


                                          }else{
                                            controller  = YoutubePlayerController.fromVideoId(
                                              videoId:id,
                                              autoPlay: false,
                                              params: const YoutubePlayerParams(showFullscreenButton: true),
                                            );
                                            videoWid = YoutubePlayer(
                                              controller:  YoutubePlayerController.fromVideoId(
                                                videoId:id,
                                                autoPlay: false,
                                                params: const YoutubePlayerParams(showFullscreenButton: true),
                                              )!,
                                              aspectRatio: 16 / 9,
                                            );
                                          }



                                        }else{
                                          Linkcontroller = VideoPlayerController.networkUrl(
                                            Uri.parse(selectedContent!["data"]),
                                            //   closedCaptionFile: _loadCaptions(),
                                            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
                                          );
                                          Linkcontroller!.initialize().then((value) {
                                            Linkcontroller!.play();
                                            videoWid = true?Stack(
                                              children: [
                                                VideoPlayer(Linkcontroller!),
                                                VideoProgressIndicator(Linkcontroller!, allowScrubbing: true),
                                                ControlsOverlay( controller: Linkcontroller!,),
                                              ],
                                            ): AspectRatio(
                                              aspectRatio: Linkcontroller!.value.aspectRatio,
                                              child: Stack(
                                                alignment: Alignment.bottomCenter,
                                                children: <Widget>[
                                                  VideoPlayer(Linkcontroller!),
                                                  VideoProgressIndicator(Linkcontroller!, allowScrubbing: true),
                                                  ControlsOverlay( controller: Linkcontroller!,),
                                                ],
                                              ),
                                            );
                                          });
                                       //   videoWid  = BumbleBeeRemoteVideo(link :selectedContent!["data"]);
                                        }

                                      //videoWid = selectedContent!["data"].toString().contains("youtube")?UtubePlayer(id: ((false?"https://www.youtube.com/watch?v=xptJmP6QVA8": selectedContent!["data"].toString()).split("watch?v=")).last,): BumbleBeeRemoteVideo(link :selectedContent!["data"]);

                                      });



                                    },purchased: true,name:snapshot.data!["lecture"][index]["name"],list: snapshot.data!["lecture"][index]["contents"],nofq:snapshot.data!["lecture"][index]["quizes"].length);



                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),),
              ],):  TabBarView(children: lectures.map((e) => TextButton(onPressed: (){}, child: Text(e["name"]))).toList(),),
            );

            return Scaffold(body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: MediaQuery.of(context).size.width,height: 180,color: Color.fromARGB(255, 39, 55, 70),child: Center(
                    child: Container(margin: EdgeInsets.all(5), width: width,child:
                    Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text(snapshot.data["class_name"],style: TextStyle(color: Colors.yellow),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.navigate_next,color: Colors.yellow),
                            ),
                            InkWell( onTap: (){
                              context.push('/courses/'+snapshot.data["subject_id"].toString());
                            },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(snapshot.data["subject_name"],style: TextStyle(color: Colors.yellow),),
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Icon(Icons.navigate_next,color: Colors.yellow),
                            // ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4,bottom: 2),
                          child: Text(snapshot.data["name"],style: TextStyle(color: Colors.white,fontSize: 25),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3,left: 0),
                          child: Text(snapshot.data["description"],style: TextStyle(color: Colors.grey,fontSize: 18),),
                        ),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text("Created by",style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: TextButton(onPressed: (){},child: Text(snapshot.data["teacher"]["LastName"]+" "+snapshot.data["teacher"]["FirstName"],)),
                          ),
                        ],),
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
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
                  DefaultTabController(length: lectures.length,child: Column(
                    children: [
                      Container(height: 50,width: MediaQuery.of(context).size.width,color: Colors.grey.shade100,child:TabBar(tabs: lectures.map((e) => TextButton(onPressed: (){}, child: Text(e["name"]))).toList()) ,),
                      Container(height: 0.5,width: MediaQuery.of(context).size.width,color: Colors.grey.shade500,),
                      TabBarView(children: lectures.map((e) => TextButton(onPressed: (){}, child: Text(e["name"]))).toList(),),

                    ],
                  ),),

                 if(false) Container(width: width,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
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
                            Padding(
                              padding: const EdgeInsets.only(top: 25,bottom: 10),
                              child: SelectableText("Course content",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                            ),
                            //SelectableText(snapshot.data!.toString()),
                            Container(margin: EdgeInsets.only(top: 15),decoration: boxShadow3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!["lecture"].length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return  ExpandbleWidget(purchased: true,name:snapshot.data!["lecture"][index]["name"],list: snapshot.data!["lecture"][index]["contents"],nofq:snapshot.data!["lecture"][index]["quizes"].length);



                                    }),
                              ),
                            ),

                          ],),
                        ),
                        Container(margin: EdgeInsets.only(top:80,left: 10),width: 300,child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8,bottom: 8),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                    Text("Course fee ",style: TextStyle(fontSize: 20),),
                                    Text("৳ "+snapshot.data["price"].toString(),style: TextStyle(fontSize: 20),),
                                  ],),
                                ),
                                InkWell( onTap: (){
                                  showDialog(
                                      context: context,
                                      builder: (_) =>AlertDialog(actions: [
                                        ElevatedButton(onPressed: (){
                                          Navigator.pop(context);

                                        }, child: Text("Cancel")),
                                        ElevatedButton(onPressed: (){
                                          Map data = {"course_id":snapshot.data["id"],"student_id":FirebaseAuth.instance.currentUser!.uid};
                                          print(data);
                                          Data().buycourse(data:data ).then((value) {
                                            Navigator.pop(context);

                                          });




                                        }, child: Text("Confirm")),
                                      ],content: Text("Pay "+snapshot.data["price"].toString()??"--"+"?"),title: Text("Buy Course",style: TextStyle(fontSize: 15,color: Colors.black),),));
                                },
                                  child: Card(color: Colors.blue,child: Container(width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Center(child: Text("Buy this course",style: TextStyle(color: Colors.white),)),
                                    ),
                                  ),),
                                )
                              ],
                            ),
                          ),
                        ),),
                      ],
                    ),
                  ),

                ],
              ),
            ),);
          }else{
            return Center(child: CupertinoActivityIndicator(),);
          }

        });
  }
}
class ControlsOverlay extends StatelessWidget {
  const ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
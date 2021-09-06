import 'package:flutter/material.dart';
import 'package:slide_video/database.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class SlidVideoPage extends StatefulWidget {
  // SlidVideoPage({Key? key}) : super(key: key);

  @override
  _SlidVideoPageState createState() => _SlidVideoPageState();
}

class _SlidVideoPageState extends State<SlidVideoPage> {
  // void @override
  List<VideoBlock> videoContent = [];
  var dataBlock;
  @override
  void initState() {
    super.initState();
    callmeFirst();
  }

  void callmeFirst() async {
    await getData().then((val) {
      setState(() {
        dataBlock = val;
      });
    });
    List<VideoBlock> temp = [];
    for (int i = 0; i < dataBlock.docs.length; i++) {
      // print(dataBlock.docs[i].data());
      temp.add(VideoBlock(
        path: dataBlock.docs[i].data()['videoLink'],
        hrefLink: dataBlock.docs[i].data()['href'],
      ));
    }
    setState(() {
      videoContent = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    double _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: videoContent == null
          ? Center(
              child: LinearProgressIndicator(),
            )
          : PageView(
              scrollDirection: Axis.vertical,
              children: videoContent,
            ),
    );
  }
}

class VideoBlock extends StatefulWidget {
  String hrefLink;
  String path;
  VideoBlock({this.hrefLink, this.path});

  @override
  _VideoBlockState createState() =>
      _VideoBlockState(hrefLink: hrefLink, path: path);
}

class _VideoBlockState extends State<VideoBlock> {
  String path;
  String hrefLink;
  VideoPlayerController _controller;

  _VideoBlockState({this.path, this.hrefLink});
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(path);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.play();
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          height: deviceHeight,
          width: deviceWidth,
          child: _controller == null
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : Stack(alignment: Alignment.bottomCenter, children: [
                  VideoPlayer(_controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ]),
          color: Colors.black,
        ),
        Align(
          alignment: Alignment(0, 0.95),
          child: TextButton(
              onPressed: () async {
                await canLaunch(hrefLink)
                    ? await launch(hrefLink)
                    : throw 'Could not launch $hrefLink';
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.white, width: 2.0)))),
              child: Container(
                padding:
                    EdgeInsets.only(top: 3, bottom: 3, right: 20, left: 20),
                child: Text(
                  'View Product',
                  style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )),
        )
      ],
    );
  }
}

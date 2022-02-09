// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoWidget extends StatefulWidget {
//   const VideoWidget({Key? key}) : super(key: key);

//   @override
//   _VideoWidgetState createState() => _VideoWidgetState();
// }

// class _VideoWidgetState extends State<VideoWidget> {
//   VideoPlayerController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset('assets/video/sv.mp4')
//       ..initialize().then((_) {
//         _controller!.setVolume(0.0);
//         _controller!.setLooping(false);
//         _controller!.play();
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height/4.5,
//       child: Center(
//         child: _controller!.value.isInitialized
//             ? LayoutBuilder(
//                 builder: (context, constraints) {
//                   return SizedBox.expand(
//                     child: FittedBox(
//                       fit: BoxFit.contain,
//                       child: SizedBox(
//                         width:
//                             constraints.maxWidth * _controller!.value.aspectRatio,
//                         height: constraints.maxHeight,
//                         child: VideoPlayer(_controller!),
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : Container(),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller!.dispose();
//   }
// }

import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:labs/uikit/uikit.dart';

class AutoassociativeScreen extends StatefulWidget {
  const AutoassociativeScreen({Key? key}) : super(key: key);

  @override
  State<AutoassociativeScreen> createState() => _AutoassociativeScreenState();
}

class _AutoassociativeScreenState extends State<AutoassociativeScreen> {
  //
  // void onFinish(PictureDetails picture, BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) {
  //       return Center(
  //         child: Material(
  //           child: FutureBuilder<Uint8List>(
  //             future: picture.toPNG(),
  //             builder:
  //                 (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
  //               switch (snapshot.connectionState) {
  //                 case ConnectionState.done:
  //                   if (snapshot.hasError) {
  //                     return Text('Error: ${snapshot.error}');
  //                   } else {
  //                     final image = Image.memory(snapshot.data!);
  //                     return Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         image,
  //                         Text('${picture.width}x${picture.height}'),
  //                       ],
  //                     );
  //                   }
  //                 default:
  //                   return const FractionallySizedBox(
  //                     widthFactor: 0.1,
  //                     alignment: Alignment.center,
  //                     child: AspectRatio(
  //                       aspectRatio: 1.0,
  //                       child: CircularProgressIndicator(),
  //                     ),
  //                   );
  //               }
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Painter(
            onSave: () {},
          ),
        ),
      ),
    );
  }
}

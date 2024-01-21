// import 'package:flutter/material.dart';

// class CustomCard extends StatelessWidget {
//   final String text;
//   final String imageUrl;

//   CustomCard({required this.text, required this.imageUrl});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
//       child: Container(
//         height: 100,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             fit: BoxFit.cover,
//             alignment: Alignment(0.00, 0.00),
//             image: NetworkImage(imageUrl),
//           ),
//           gradient: LinearGradient(
//             colors: [Colors.black, Colors.black],
//             stops: [0, 1],
//             begin: Alignment(1, 0),
//             end: Alignment(-1, 0),
//           ),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Stack(
//           children: [
//             Opacity(
//               opacity: 0.5,
//               child: Align(
//                 alignment: Alignment(0.00, 0.00),
//                 child: Container(
//                   width: double.infinity,
//                   height: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment(0.00, 0.00),
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   fontFamily: 'Readex Pro',
//                   color: Colors.white,
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

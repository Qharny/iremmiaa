// import 'package:flutter/material.dart';

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: EdgeInsets.all(16),
//               child: CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(
//                     'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60'),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 '[Hostel Name]',
//                 style: TextStyle(
//                   color: Colors.red, // Change the color
//                   fontSize: 30,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 '[Username]',
//                 style: TextStyle(
//                   color: Colors.blue, // Change the color
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 '[email]',
//                 style: TextStyle(
//                   color: Colors.blue, // Change the color
//                 ),
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.all(16),
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey, // Change the color
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Switch to Dark Mode',
//                         style: TextStyle(
//                           fontSize: 16,
//                         ),
//                       ),
//                       Switch(
//                         value: false, // Change the value as needed
//                         onChanged: (bool value) {
//                           // Implement dark mode toggle logic here
//                         },
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Edit Profile',
//                         style: TextStyle(
//                           fontSize: 16,
//                         ),
//                       ),
//                       Icon(Icons.chevron_right_rounded),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Scanned history',
//                         style: TextStyle(
//                           fontSize: 16,
//                         ),
//                       ),
//                       Icon(Icons.chevron_right_rounded),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Statistics',
//                         style: TextStyle(
//                           fontSize: 16,
//                         ),
//                       ),
//                       Icon(Icons.chevron_right_rounded),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Logout',
//                         style: TextStyle(
//                           fontSize: 16,
//                         ),
//                       ),
//                       Icon(Icons.logout),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

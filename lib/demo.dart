import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_gif/flutter_gif.dart';
// import 'dart:convert';

// class VerifyTenantsPage extends StatefulWidget {
//   final String accessToken;

//   const VerifyTenantsPage({Key? key, required this.accessToken})
//       : super(key: key);

//   @override
//   _VerifyTenantsPageState createState() => _VerifyTenantsPageState();
// }

// class _VerifyTenantsPageState extends State<VerifyTenantsPage>
//     with SingleTickerProviderStateMixin {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;
//   FlutterGifController? gifController;
//   String? result;
//   bool isVerificationDialogShown = false;

//   @override
//   void initState() {
//     super.initState();
//     gifController = FlutterGifController(vsync: this);
//   }

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (controller != null) {
//       controller!.resumeCamera();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         shadowColor: Colors.white,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFFF59B15)),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: const Text(
//           'Scan QR',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Color(0xFFF59B15),
//             fontSize: 20,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//             child: IconButton(
//               icon: const Icon(Icons.flash_on,
//                   color: Color(0xFFF59B15), size: 30),
//               onPressed: () {
//                 // Add an action to navigate to the profile page here.
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//             child: IconButton(
//               icon: const Icon(Icons.switch_camera,
//                   color: Color(0xFFF59B15), size: 30),
//               onPressed: () {
//                 // Add an action to navigate to the profile page here.
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//             child: IconButton(
//               icon: const Icon(Icons.account_circle,
//                   color: Color(0xFFF59B15), size: 35),
//               onPressed: () {
//                 // Add an action to navigate to the profile page here.
//               },
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: isVerificationDialogShown
//                   ? CircularProgressIndicator()
//                   : const Text(
//                       "Move camera to scan and verify tenant",
//                       style: TextStyle(fontSize: 16),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     gifController?.dispose(); // Dispose the gifController
//     super.dispose();
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       if (!isVerificationDialogShown) {
//         setState(() {
//           result = scanData.code;
//           isVerificationDialogShown = true;
//         });
//         verifyTenant(scanData.code);
//       }
//     });
//   }

//   Future<void> verifyTenant(String? qrCode) async {
//     if (qrCode == null) {
//       return;
//     }

//     final apiUrl = Uri.parse(
//         'https://ethenatx.pythonanywhere.com/management/verify-tenant/');
//     final response = await http.post(
//       apiUrl,
//       headers: {
//         'Authorization': 'Bearer ${widget.accessToken}',
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode({'verification_code': qrCode}),
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);

//       gifController!.repeat(
//         min: 0,
//         max: 0,
//         // duration: const Duration(milliseconds: 1000),
//         reverse: false,
//       );

//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Verification Successful'),
//             content: Column(
//               children: [
//                 GifImage(
//                   controller: gifController!,
//                   image: AssetImage('assets/success.gif'),
//                   width: 50,
//                   height: 50,
//                 ),
//                 Text('Hostel: ${data['hostel_name']}'),
//                 Text('Room Number: ${data['room_number']}'),
//                 Text('Name: ${data['tenant_name']}'),
//                 Text('ID: ${data['student_id']}'),
//                 Text('Stat: ${data['checked_in_status']}'),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     isVerificationDialogShown = false;
//                   });
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Close'),
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text('Failed to verify tenant. Please try again.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     isVerificationDialogShown = false;
//                   });
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Close'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class VerifyTenantsPage extends StatefulWidget {
//   final String accessToken;

//   VerifyTenantsPage({required this.accessToken});

//   @override
//   _VerifyTenantsPageState createState() => _VerifyTenantsPageState();
// }

// class _VerifyTenantsPageState extends State<VerifyTenantsPage> {
//   bool isLoading = false;
//   String scanMessage = "Scan the QR code to verify the tenant.";

//   Future<void> sendHardcodedVerificationCode() async {
//     setState(() {
//       isLoading = true;
//       scanMessage = "Verifying...";
//     });

//     try {
//       final response = await http.post(
//         Uri.parse(
//             'https://ethenatx.pythonanywhere.com/management/verify-tenant/'),
//         headers: {
//           'Authorization': 'Bearer ${widget.accessToken}',
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode({
//           'verification_code':
//               "EVAdc0a-05r0-En-011b0-lem-82dc4dbf-4fd5-42e9-8f4b-41188c18234f-enoch-20951781-072024k0-lemon-15:34:33.411574-Grj",
//         }),
//       );
// appBar: AppBar(
//         shadowColor: Colors.white,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFFF59B15)),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: const Text(
//           'Scan QR',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Color(0xFFF59B15),
//             fontSize: 20,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//             child: IconButton(
//               icon: const Icon(Icons.flash_on,
//                   color: Color(0xFFF59B15), size: 30),
//               onPressed: () {
//                 // Add an action to navigate to the profile page here.
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//             child: IconButton(
//               icon: const Icon(Icons.switch_camera,
//                   color: Color(0xFFF59B15), size: 30),
//               onPressed: () {
//                 // Add an action to navigate to the profile page here.
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
//             child: IconButton(
//               icon: const Icon(Icons.account_circle,
//                   color: Color(0xFFF59B15), size: 35),
//               onPressed: () {
//                 // Add an action to navigate to the profile page here.
//               },
//             ),
//           ),
//         ],
//       ),

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (responseData.containsKey('tenant_name') &&
//             responseData.containsKey('student_id')) {
//           print("it coming:");
//           print(responseData["message"]);
//           print(responseData);
//           print(response.statusCode);
//           print(response.body);
//           // Display the student's information
//           setState(() {
//             isLoading = false;
//             scanMessage = "Scan the QR code to verify the tenant.";
//           });

//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text('Verification Successful'),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text('Student: ${responseData['hostel_name']}'),
//                     Text('Room Number: ${responseData['room_number']}'),
//                     // Text('Hostel: ${responseData['Hostel']}'),
//                     // Text('Verification Status: ${responseData['Verified']}'),
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         } else {
//           print("Is it coming:");
//           print(responseData["message"]);
//           print(responseData);
//           print(response.statusCode);
//           print(response.body);
//           // Tenant is not verified or has not paid
//           setState(() {
//             isLoading = false;
//             scanMessage = "Tenant is not verified or has not paid.";
//           });
//         }
//       } else {
//         final responseData = json.decode(response.body);

//         print("An error occurred:");
//         print(responseData["message"]);
//         print(responseData);
//         print(response.statusCode);
//         print(response.body);
//         // Handle other response codes or errors
//         setState(() {
//           isLoading = false;
//           scanMessage = "An error occurred. Please try again later.";
//         });
//       }
//     } catch (e) {
//       // Handle network or other errors
//       print('Error: $e');
//       setState(() {
//         isLoading = false;
//         scanMessage = "A Network error occurred. Please try again later.";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Verify Tenants'),
//       ),
//       body: Column(
//         children: <Widget>[
//           SizedBox(height: 10),
//           Text(
//             scanMessage,
//             style: TextStyle(fontSize: 18),
//           ),
//           if (isLoading) CircularProgressIndicator(),
//           ElevatedButton(
//             onPressed: sendHardcodedVerificationCode,
//             child: Text('Verify Hardcoded Code'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyTenantsPage extends StatefulWidget {
  final String accessToken;

  VerifyTenantsPage({required this.accessToken});

  @override
  _VerifyTenantsPageState createState() => _VerifyTenantsPageState();
}

class _VerifyTenantsPageState extends State<VerifyTenantsPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = true;
  bool isLoading = false;
  String scanMessage = "Scan the QR code to verify the tenant.";

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.toggleFlash();
    }
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      final decodedQRCode = scanData.code; // Extract the text from Barcode
      setState(() {
        isLoading = true;
        scanMessage = "Verifying...";
      });

      // When a QR code is scanned, process it
      await verifyTenant(decodedQRCode);
    });
  }

  Future<void> verifyTenant(String? decodedQRCode) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://ethenatx.pythonanywhere.com/management/verify-tenant/'),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'verification_code': decodedQRCode,
        }),
      );
      print(decodedQRCode);
      if (response.statusCode == 200) {
        print(response);
        print(response.body);
        print(response.statusCode);
        final responseData = json.decode(response.body);
        if (responseData.containsKey('hostel_name') &&
            responseData.containsKey('student_id')) {
          // Tenant is verified
          // Display the student's information
          setState(() {
            isLoading = false;
            scanMessage = "Scan the QR code to verify the tenant.";
          });

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Verification Successful'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Student: ${responseData['hostel_name']}'),
                    Text('Room Number: ${responseData['room_number']}'),
                    Text('Hostel: ${responseData['tenant_name']}'),
                    Text('Verification Status: ${responseData['student_id']}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Tenant is not verified or has not paid
          setState(() {
            isLoading = false;
            scanMessage = "Tenant is not verified or has not paid.";
          });
        }
      } else {
        print("An error occurred :");
        print(response);
        print(response.body);
        print(response.statusCode);
        // Handle other response codes or errors
        setState(() {
          isLoading = false;
          scanMessage = "An error occurred. Please try again later.";
        });
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      setState(() {
        isLoading = false;
        scanMessage = "An error occurred. Please try again later.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Tenants'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: onQRViewCreated,
            ),
          ),
          SizedBox(height: 10),
          Text(
            scanMessage,
            style: TextStyle(fontSize: 18),
          ),
          if (isLoading) CircularProgressIndicator(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

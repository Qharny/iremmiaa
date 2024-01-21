import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/profile_page.dart';

import '../Custom_classes/Flashlight.dart';

class VerifyTenantsPage extends StatefulWidget {
  final String accessToken;

  const VerifyTenantsPage({super.key, required this.accessToken});

  @override
  _VerifyTenantsPageState createState() => _VerifyTenantsPageState();
}

class _VerifyTenantsPageState extends State<VerifyTenantsPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? result;
  bool isVerificationDialogShown = false;
  bool isFlashlightOn = false;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF59B15)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Scan QR',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFF59B15),
            fontSize: 20,
          ),
        ),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          //   child: IconButton(
          //     icon: const Icon(Icons.flash_on,
          //         color: Color(0xFFF59B15), size: 30),
          //     onPressed: () {},
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: FlashlightButton(
              isFlashlightOn: isFlashlightOn,
              onPressed: (value) {
                // Turn on/off flashlight
                controller?.toggleFlash();
                setState(() {
                  isFlashlightOn = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              icon: const Icon(Icons.switch_camera,
                  color: Color(0xFFF59B15), size: 30),
              onPressed: () {
                controller?.flipCamera();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              icon: const Icon(Icons.account_circle,
                  color: Color(0xFFF59B15), size: 35),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(accessToken: widget.accessToken),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
                _buildOverlay(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: isVerificationDialogShown
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Move camera to scan and verify tenant",
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
      ),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isVerificationDialogShown) {
        setState(() {
          result = scanData.code;
          isVerificationDialogShown = true;
        });
        verifyTenant(scanData.code);
      }
    });
  }

  Future<void> verifyTenant(String? qrCode) async {
    final apiUrl = Uri.parse(
        'https://ethenatx.pythonanywhere.com/management/verify-tenant/');
    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'verification_code': qrCode}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Verification Successful'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/Success.gif',
                      width: 90,
                      height: 90,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hostel: ${data['hostel_name']}'),
                        Text('Room Number: ${data['room_number']}'),
                        Text('Name: ${data['tenant_name']}'),
                        Text('ID: ${data['student_id']}'),
                        Text('Status: ${data['checked_in_status']}'),
                      ],
                    ),
                  ],
                ),
              ),
              contentPadding: EdgeInsets.all(16),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isVerificationDialogShown = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        handleVerificationError(response);
      }
    } catch (e) {
      handleVerificationError(null);
    }
  }

  void handleVerificationError(http.Response? response) {
    String errorMessage = 'Error';

    if (response != null) {
      final data = json.decode(response.body);

      if (response.statusCode == 401) {
        errorMessage = 'Tenant V-code has expired';
      } else if (response.statusCode == 404) {
        errorMessage = 'Tenant V-code not valid';
      } else if (response.statusCode == 403) {
        errorMessage = 'Portar is not verified';
      } else if (response.statusCode == 400) {
        errorMessage = 'Verification Error';
        // Display the hostel name provided in the response
        errorMessage += '\nHostel: ${data['message']}';
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(errorMessage),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/Error.gif',
                  width: 60,
                  height: 60,
                ),
                if (response != null)
                  Text(json.decode(response.body)['message'])
                else
                  const Text('Failed to verify tenant. Please try again.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isVerificationDialogShown = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

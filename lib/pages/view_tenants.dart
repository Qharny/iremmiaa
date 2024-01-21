import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:bookmie/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewTenantsPage extends StatefulWidget {
  final String accessToken;

  const ViewTenantsPage({Key? key, required this.accessToken})
      : super(key: key);

  @override
  _ViewTenantsPageState createState() => _ViewTenantsPageState();
}

class _ViewTenantsPageState extends State<ViewTenantsPage> {
  List<Map<String, dynamic>> tenants = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTenants();
  }

  Future<void> fetchTenants() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });
    try {
      final tenantsResponse = await http.get(
        Uri.parse(
            'https://ethenatx.pythonanywhere.com/management/view-tenants/'),
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );

      if (tenantsResponse.statusCode == 200) {
        final List<dynamic> tenantsData = json.decode(tenantsResponse.body);
        print(tenantsResponse.body);

        setState(() {
          tenants = List<Map<String, dynamic>>.from(tenantsData);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load tenants');
      }
    } catch (e) {
      print('Error fetching tenants: $e');
      setState(() {
        isLoading = false; // Also set loading state to false in case of error
      });
      // Handle the error appropriately
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
          'View Tenants',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFF59B15),
            fontSize: 21,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
            child: IconButton(
              icon: const Icon(Icons.account_circle,
                  color: Color(0xFFF59B15), size: 35),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      accessToken: widget.accessToken,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tenants.length,
              itemBuilder: (context, index) {
                final tenant = tenants[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    // elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Icon(Icons.person, color: Colors.black),
                            backgroundColor: Color(0xFFF59B15),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tenant['name'],
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Icon(Icons.door_back_door, size: 16.0),
                                    const SizedBox(width: 8.0),
                                    Text('Room: ${tenant['room_number']}'),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.solidAddressCard,
                                        size: 16.0),
                                    const SizedBox(width: 8.0),
                                    Text('Student ID: ${tenant['student_id']}'),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                Row(
                                  children: [
                                    Icon(Icons.payments_rounded, size: 16.0),
                                    const SizedBox(width: 8.0),
                                    Text('Payed: ${tenant['payed']}'),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                Row(
                                  children: [
                                    Icon(Icons.fact_check, size: 16.0),
                                    const SizedBox(width: 8.0),
                                    Text('Checked In: ${tenant['checked_in']}'),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                Row(
                                  children: [
                                    Icon(Icons.phone, size: 16.0),
                                    const SizedBox(width: 8.0),
                                    Text('Phone: ${tenant['phone_number']}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       elevation: 0,
//       backgroundColor: Colors.white,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Color(0xFFF59B15)),
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//       ),
//       title: const Text(
//         'View Tenants',
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           color: Color(0xFFF59B15),
//           fontSize: 21,
//         ),
//       ),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
//           child: IconButton(
//             icon: const Icon(Icons.account_circle,
//                 color: Color(0xFFF59B15), size: 35),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProfilePage(
//                     accessToken: widget.accessToken,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//     body: Padding(
//       padding: const EdgeInsets.all(16),
//       child: ListView.builder(
//         itemCount: tenants.length,
//         itemBuilder: (context, index) {
//           final tenant = tenants[index];
//           return _buildTenantCard(tenant);
//         },
//       ),
//     ),
//   );
// }

// Widget _buildTenantCard(Map<String, dynamic> tenant) {
//   return Card(
//     elevation: 1,
//     margin: EdgeInsets.symmetric(vertical: 8),
//     child: ListTile(
//       leading: CircleAvatar(
//         // Use a profile icon or tenant's profile picture if available
//         child: Icon(Icons.person),
//       ),
//       title: Text(tenant['name'] ?? 'No Name'),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Room Number: ${tenant['room_number'] ?? 'N/A'}'),
//           Text('Student ID: ${tenant['student_id'] ?? 'N/A'}'),
//           Text('Payed: ${tenant['payed'] ?? 'N/A'}'),
//           Text('Checked In: ${tenant['checked_in'] ?? 'N/A'}'),
//         ],
//       ),
//     ),
//   );
// }
// }

//profile page.dart
import 'dart:convert';
import 'package:bookmie/pages/income_stats.dart';
import 'package:bookmie/pages/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '/pages/edit_profile_page.dart';
import '../Custom_classes/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  final String accessToken;

  ProfilePage({Key? key, required this.accessToken}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String hostelName = '';
  String managerName = '';
  String managerProfilePicture = '';
  String hostelImage = '';
  int numberOfRooms = 0;
  int numberOfTenants = 0;
  int numberOfRoomsOccupied = 0;
  int numberOfSpaceLeft = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url =
        'https://ethenatx.pythonanywhere.com/management/management-profile/';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          hostelName = data['hostel_name'] ?? '';
          managerName = data['manager'] ?? '';
          numberOfRooms = data['number_of_rooms'] ?? 0;
          numberOfTenants = data['number_of_tenants'] ?? 0;
          numberOfRoomsOccupied = data['number_rooms_occupied'] ?? 0;
          numberOfSpaceLeft = data['total_bed_space_left'] ?? 0;
          final baseUrl = 'https://ethenatx.pythonanywhere.com';
          managerProfilePicture =
              '$baseUrl${data['hostel_manager_profile_picture']}';
          hostelImage = '$baseUrl${data['hostel_image']}';
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle the error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                _buildStats(),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          accessToken: widget.accessToken,
                        ),
                      ),
                    );
                  },
                  child: _buildButton('Edit Profile', Icons.edit),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StatisticsPage(
                          accessToken: widget.accessToken,
                        ),
                      ),
                    );
                  },
                  child: _buildButton(
                      'Statistics', Icons.insert_chart_outlined_outlined),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalesStatsPage(
                          accessToken: widget.accessToken,
                        ),
                      ),
                    );
                  },
                  child:
                      _buildButton('Icome Stats', Icons.attach_money_rounded),
                ),
                _buildButton('Logout', Icons.logout, color: Color(0xFFF59B15)),
              ],
            ),
          ),
        ));
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 267,
      child: Stack(
        children: [
          _buildBackgroundImage(),
          _buildProfileImage(),
          _buildUserInfo(),
          _buildDarkModeToggle(),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Align(
      alignment: const AlignmentDirectional(0.00, -1.00),
      child: Container(
        width: double.infinity,
        height: 235,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.background
            ],
            stops: [0, 1],
            begin: AlignmentDirectional(0, -1),
            end: AlignmentDirectional(0, 1),
          ),
        ),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(hostelImage),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Align(
      alignment: const AlignmentDirectional(-1.00, 1.00),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            // Use CachedNetworkImage widget
            imageUrl: managerProfilePicture,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildDarkModeToggle() {
    return Align(
      alignment:
          const AlignmentDirectional(0.1, -0.5), // Move to the right side
      child: Row(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
            child: Icon(
              Icons.brightness_4,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
            child: Switch(
              value: true,
              onChanged: (bool value) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsItem(IconData icon, String value, String label) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 12, 12),
      child: Container(
        width: 140,
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          // boxShadow: const [
          //   BoxShadow(
          //     blurRadius: 4,
          //     // color: Color(0x34090F13),
          //     offset: Offset(0, 2),
          //   )
          // ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
              child: Icon(
                icon,
                color: const Color(
                    0xFFF59B15), // Adjust icon color based on the theme
                size: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, {Color? color}) {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 10),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: const AlignmentDirectional(0.00, 0.00),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                child: Icon(
                  icon,
                  // color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildUserInfoText(hostelName, managerName),
        ],
      ),
    );
  }

  Widget _buildUserInfoText(String title, String subtitle) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 30,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: const AlignmentDirectional(-0.91, -0.8),
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back,
            size: 24, color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      width: double.infinity,
      height: 106,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 1),
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatisticsPage(
                    accessToken: widget.accessToken,
                  ),
                ),
              );
            },
            child:
                _buildStatsItem(Icons.bed, numberOfRooms.toString(), 'Rooms'),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatisticsPage(
                      accessToken: widget.accessToken,
                    ),
                  ),
                );
              },
              child: _buildStatsItem(Icons.supervisor_account_rounded,
                  numberOfTenants.toString(), 'Tenants')),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatisticsPage(
                      accessToken: widget.accessToken,
                    ),
                  ),
                );
              },
              child: _buildStatsItem(Icons.door_back_door,
                  numberOfRoomsOccupied.toString(), 'Occupied')),
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatisticsPage(
                      accessToken: widget.accessToken,
                    ),
                  ),
                );
              },
              child: _buildStatsItem(Icons.grid_view_rounded,
                  numberOfSpaceLeft.toString(), 'Space Left'))
        ],
      ),
    );
  }
}

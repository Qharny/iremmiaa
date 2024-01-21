// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/profile_page.dart';

class RoomDetailsPage extends StatefulWidget {
  final String accessToken;

  const RoomDetailsPage({Key? key, required this.accessToken})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RoomDetailsPageState createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  String searchText = '';
  int selectedCapacity = 0;
  int searchTenants = 0;
  // String searchGender = '';
  bool showOccupiedOnly = false;
  bool isLoading = true;

  List<Room> rooms = [];
  List<Room> filteredRooms = [];

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> showFilterDialog(
    String title,
    String hintText,
    void Function(String) onFilter,
  ) async {
    String filterValue = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                onChanged: (value) {
                  filterValue = value;
                },
                decoration: InputDecoration(
                  hintText: hintText,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  onFilter(filterValue);
                  Navigator.pop(context);
                },
                child: Text('Apply Filter'),
              ),
            ],
          ),
        );
      },
    );
  }

  void searchGender(String query) {
    setState(() {
      filteredRooms = rooms
          .where((room) =>
              room.gender.toLowerCase().contains(query.toLowerCase()) &&
              (query.isEmpty ||
                  room.gender.toLowerCase() == query.toLowerCase()))
          .toList();
    });
  }

  void filterRooms() {
    setState(() {
      filteredRooms = rooms.where((room) {
        final matchesSearch =
            room.roomNo.toLowerCase().contains(searchText.toLowerCase());
        final matchesCapacity =
            selectedCapacity == 0 || room.roomCapacity == selectedCapacity;
        final matchesOccupancy = !showOccupiedOnly || room.occupied;
        final matchesTenants =
            searchTenants == 0 || room.noOfTenants == searchTenants;

        return matchesSearch &&
            matchesCapacity &&
            matchesOccupancy &&
            matchesTenants;
      }).toList();
    });
  }

  Future<void> fetchRooms() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse('https://ethenatx.pythonanywhere.com/management/rooms/'),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> roomData = json.decode(response.body);

      rooms = roomData.map((roomJson) => Room.fromJson(roomJson)).toList();
      print("filter: $rooms");
      print(rooms);
      print(roomData);

      filteredRooms = List.from(rooms);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  void updateRoom(Room updatedRoom) {
    // Find and update the room in the list.
    final index = rooms.indexWhere((room) => room.roomId == updatedRoom.roomId);
    if (index != -1) {
      setState(() {
        rooms[index] = updatedRoom;
      });
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
          'Rooms',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFF59B15),
            fontSize: 25,
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
        children: [
          _buildSearchBar(),
          _buildFilter(),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : filteredRooms.isEmpty
                    ? const Center(child: Text('No rooms match your criteria.'))
                    : _buildRoomGridView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
                filterRooms();
              });
            },
            decoration: const InputDecoration(
              hintText: 'Search by Room No',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<int>(
                value: searchTenants,
                onChanged: (value) {
                  setState(() {
                    searchTenants = value!;
                    filterRooms();
                  });
                },
                items: <DropdownMenuItem<int>>[
                  const DropdownMenuItem<int>(
                    value: 0,
                    child: Text('Filter by Tenants'),
                  ),
                  for (var tenants
                      in rooms.map((room) => room.noOfTenants).toSet())
                    if (tenants != 0)
                      DropdownMenuItem<int>(
                        value: tenants,
                        child: Text('$tenants'),
                      ),
                ],
              ),
              // Filter by Gender
              DropdownButton<String>(
                hint: Text('Filter by Gender'),
                value: null,
                onChanged: (value) {
                  setState(() {
                    searchGender(
                        value ?? ''); // Pass an empty string for "All Genders"
                  });
                },
                items: ['All Genders', 'male', 'female', 'open']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value == 'All Genders' ? '' : value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Filter by Capacity
        DropdownButton<int>(
          value: selectedCapacity,
          onChanged: (value) {
            setState(() {
              selectedCapacity = value!;
              filterRooms();
            });
          },
          items: <DropdownMenuItem<int>>[
            const DropdownMenuItem<int>(
              value: 0,
              child: Text('Filter by Capacity'),
            ),
            for (var capacity in rooms.map((room) => room.roomCapacity).toSet())
              DropdownMenuItem<int>(
                value: capacity,
                child: Text('Capacity $capacity'),
              ),
          ],
        ),

        // Filter by Occupancy
        Row(
          children: [
            const Text('Occupied Only'),
            Checkbox(
              value: showOccupiedOnly,
              onChanged: (value) {
                setState(() {
                  showOccupiedOnly = value ?? false;
                  filterRooms();
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  GridView _buildRoomGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.63,
      ),
      itemCount: filteredRooms.isEmpty ? rooms.length : filteredRooms.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return RoomCard(
          room: filteredRooms.isEmpty ? rooms[index] : filteredRooms[index],
          onEdit: (room) => _showEditRoomDialog(context, room),
          accessToken: widget.accessToken,
          updateRoom: updateRoom,
        );
      },
    );
  }

  Future<void> _showEditRoomDialog(BuildContext context, Room room) async {
    Room updatedRoom =
        room.copyWith(); // Initialize the variable before setState

    final TextEditingController roomNoController =
        TextEditingController(text: room.roomNo);
    final TextEditingController roomCapacityController =
        TextEditingController(text: room.roomCapacity.toString());
    final TextEditingController roomPriceController =
        TextEditingController(text: room.roomPrice.toString());
    final TextEditingController roomBedSpaceController =
        TextEditingController(text: room.roomBedSpace.toString());
    bool isOccupied = room.occupied;

    bool isSaving = false;

    void showSnackbar(String message, Color color) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Room Details'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      controller: roomNoController,
                      decoration: const InputDecoration(labelText: 'Room No'),
                    ),
                    TextFormField(
                      controller: roomCapacityController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: 'Room Capacity'),
                    ),
                    TextFormField(
                      controller: roomPriceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: 'Room Price'),
                    ),
                    TextFormField(
                      controller: roomBedSpaceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: 'Space Left'),
                    ),
                    DropdownButtonFormField<String>(
                      value: updatedRoom.gender,
                      onChanged: (value) {
                        setState(() {
                          updatedRoom = updatedRoom.copyWith(gender: value);
                        });
                      },
                      items: ['male', 'female', 'open']
                          .map((gender) => DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      decoration: const InputDecoration(labelText: 'Gender'),
                    ),
                    CheckboxListTile(
                      title: const Text('Occupied'),
                      value: isOccupied,
                      onChanged: (value) {
                        setState(() {
                          isOccupied = value ?? false;
                          updatedRoom =
                              updatedRoom.copyWith(occupied: isOccupied);
                        });
                      },
                    ),
                    if (isSaving)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          setState(() {
                            isSaving = true;
                          });

                          final updatedRoom = room.copyWith(
                            roomNo: roomNoController.text,
                            roomCapacity:
                                int.tryParse(roomCapacityController.text) ?? 0,
                            roomPrice: double.parse(roomPriceController.text),
                            roomBedSpace:
                                int.tryParse(roomBedSpaceController.text) ?? 0,
                            occupied: isOccupied,
                          );

                          try {
                            await _updateRoom(updatedRoom, widget.accessToken);
                            updateRoom(updatedRoom);
                            Navigator.of(context).pop();

                            showSnackbar('Room details saved successfully',
                                Colors.green);
                          } catch (e) {
                            showSnackbar(
                                'Failed to save room details', Colors.red);
                          } finally {
                            setState(() {
                              isSaving = false;
                            });
                          }
                        },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateRoom(Room updatedRoom, String accessToken) async {
    final apiUrl = Uri.parse(
        'https://ethenatx.pythonanywhere.com/management/room-details/${updatedRoom.roomId}');
    final response = await http.put(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'room_no': updatedRoom.roomNo,
        'room_capacity': updatedRoom.roomCapacity,
        'room_price': updatedRoom.roomPrice,
        'bed_space_left': updatedRoom.roomBedSpace,
        'occupied': updatedRoom.occupied,
        'gender': updatedRoom.gender,
      }),
    );

    if (response.statusCode == 200) {
      // Update the room in the rooms and filteredRooms lists.
      final index =
          rooms.indexWhere((room) => room.roomId == updatedRoom.roomId);
      if (index != -1) {
        setState(() {
          rooms[index] = updatedRoom;

          final filteredIndex = filteredRooms
              .indexWhere((room) => room.roomId == updatedRoom.roomId);
          if (filteredIndex != -1) {
            filteredRooms[filteredIndex] = updatedRoom;
          }
        });
      }
    } else {
      // Handle error
      // You may want to show an error message here
    }
  }
}

class Room {
  final String roomNo;
  final int roomCapacity;
  final double roomPrice;
  final int roomBedSpace;
  final int noOfTenants;
  final bool occupied;
  final String roomId;
  final String gender;

  Room({
    required this.roomNo,
    required this.roomCapacity,
    required this.roomPrice,
    required this.roomBedSpace,
    required this.noOfTenants,
    required this.occupied,
    required this.roomId,
    required this.gender,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomNo: json['room_no'] ?? '',
      roomCapacity: json['room_capacity'] ?? 0,
      roomPrice: double.parse(json['room_price']),
      roomBedSpace: json['bed_space_left'] ?? 0,
      noOfTenants: json['number_of_tenants'] ?? 0,
      occupied: json['occupied'] ?? false,
      roomId: json['room_id'],
      gender: json['gender'] ?? '',
    );
  }

  Room copyWith({
    String? roomNo,
    int? roomCapacity,
    double? roomPrice,
    int? roomBedSpace,
    int? noOfTenants,
    bool? occupied,
    String? gender,
  }) {
    return Room(
      roomNo: roomNo ?? this.roomNo,
      roomCapacity: roomCapacity ?? this.roomCapacity,
      roomPrice: roomPrice ?? this.roomPrice,
      roomBedSpace: roomBedSpace ?? this.roomBedSpace,
      noOfTenants: noOfTenants ?? this.noOfTenants,
      occupied: occupied ?? this.occupied,
      roomId: roomId,
      gender: gender ?? this.gender,
    );
  }
}

class RoomCard extends StatelessWidget {
  final Room room;
  final void Function(Room) onEdit;
  final String accessToken;
  final Function(Room) updateRoom;

  const RoomCard({
    Key? key,
    required this.room,
    required this.onEdit,
    required this.accessToken,
    required this.updateRoom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(8.0),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Room No: ${room.roomNo}',
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Capacity: ${room.roomCapacity}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'GH₵${room.roomPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                'Space Left: ${room.roomBedSpace}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Tenants: ${room.noOfTenants}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Gender: ${room.gender}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Occupied: ${room.occupied ? 'Yes' : 'No'}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 3),
              ElevatedButton(
                onPressed: () => onEdit(room),
                child: const Text('Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

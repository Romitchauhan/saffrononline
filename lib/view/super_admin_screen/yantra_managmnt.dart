import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saffrononline/utils/app_color.dart';
import 'dart:convert'; // Required for decoding API responses
import '../../models/admin_yantra_model.dart';
import 'add_yantra.dart'; // Assuming you're using GetX for navigation

class YantraListScreen extends StatefulWidget {
  @override
  _YantraListScreenState createState() => _YantraListScreenState();
}

class _YantraListScreenState extends State<YantraListScreen> {
  TextEditingController _searchController = TextEditingController();
  int _entriesPerPage = 10;
  int _currentPage = 1;
  Timer? _debounce;

  Future<List<AdminYantra>> fetchAllYantras() async {
    try {
      final response = await http.get(Uri.parse(
          'https://saffrononline.bhavenaayurveda.com/api/admin/yantra-all.php'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return (jsonResponse['data'] as List)
            .map((data) => AdminYantra.fromJson(data))
            .toList();
      } else {
        Get.snackbar('Error', 'Failed to load yantras');
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: AppColors.main,
        appBar: AppBar(
          title: Text('Yantras'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Get.to(() => AddYantraScreen());
              },
            ),
          ],
        ),
        body: Column(

          children: [
            SizedBox(height: 10,),

            ElevatedButton(
              onPressed: () {
                Get.to(AddYantraScreen());
              },
              child: Text('Add Yantra'),
            ),
            SizedBox(height: 20,),
            // Search Bar
            Container(
              width: 200,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Yantras',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search,color: Colors.white),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            // Yantra Table
            Expanded(
              child: FutureBuilder<List<AdminYantra>>(
                future: fetchAllYantras(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(child: Text('Error fetching yantras'));
                  }

                  final yantras = snapshot.data ?? [];
                  final filteredYantras = yantras
                      .where((yantra) => yantra.yantraName
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();

                  if (filteredYantras.isEmpty) {
                    return Center(child: Text('No yantras found.'));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),

                        DataTable(

                          columns: [


                            DataColumn(
                              label: Container(
                                color: AppColors.main,

                                // Set the background color to blue
                                padding: EdgeInsets.all(
                                    8), // Optional: Add some padding
                                child: Text(
                                  'No.',
                                  style: TextStyle(
                                      color: Colors
                                          .white), // Set text color to white for contrast
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                                color: AppColors.main,

                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Yantra Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                                color: AppColors.main,

                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Image',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                            color: AppColors.main,
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Price',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Container(
                                color: AppColors.main,

                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Actions',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                          rows: filteredYantras
                              .skip((_currentPage - 1) * _entriesPerPage)
                              .take(_entriesPerPage)
                              .map((yantra) => DataRow(cells: [
                                    DataCell(Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(yantra.id, style: TextStyle(color: Colors.white),),
                                    )),

                                    DataCell(Text(yantra.yantraName,style: TextStyle(color: Colors.white),)),
                                    DataCell(Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(yantra.yantraImage,
                                          height: 50, width: 50),
                                    )),
                                    DataCell(Text('₹${yantra.yantraPrice}',style: TextStyle(color: Colors.white),)),
                                    DataCell(Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          color: Colors.green,
                                          onPressed: () {
                                            Get.to(() => EditYantraFormScreen(
                                                yantra: yantra));
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          color: Colors.blue,

                                          onPressed: () {
                                            Get.to(() => ViewYantraScreen(
                                                yantra: yantra));
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          color: Colors.red,

                                          onPressed: () {
                                            _deleteYantra(yantra.id);
                                          },
                                        ),
                                      ],
                                    )),
                                  ]))
                              .toList(),
                        ),
                        // Pagination Controls
                        _buildPaginationControls(filteredYantras.length),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(int totalEntries) {
    final totalPages = (totalEntries / _entriesPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white),
    //color: Colors.white,
          onPressed: _currentPage > 1
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
        ),
        Text('Page $_currentPage of $totalPages',style: TextStyle(color: Colors.white),),
        IconButton(
          icon: Icon(Icons.arrow_forward,color: Colors.white),
          onPressed: _currentPage < totalPages
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }

  void _deleteYantra(String id) async {
    try {
      final response = await http.delete(Uri.parse(
          'https://saffrononline.bhavenaayurveda.com/api/admin/yantra-delete.php/$id'));
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Yantra deleted successfully');
        setState(() {}); // Refresh data or update the UI accordingly
      } else {
        Get.snackbar('Error', 'Failed to delete yantra');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting yantra.');
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      setState(
          () {}); // Trigger a rebuild to filter results based on search input
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}

class AddYantraFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Yantra')),
      body: Center(child: Text('Add Yantra Form Goes Here')),
    );
  }
}

class EditYantraFormScreen extends StatelessWidget {
  final AdminYantra yantra;

  EditYantraFormScreen({required this.yantra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Yantra')),
      body: Center(child: Text('Edit Form for ${yantra.yantraName}')),
    );
  }
}

class ViewYantraScreen extends StatelessWidget {
  final AdminYantra yantra;

  ViewYantraScreen({required this.yantra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Yantra')),
      body: Center(
        child: Column(
          children: [
            Image.network(yantra.yantraImage),
            SizedBox(height: 20),
            Text('Name: ${yantra.yantraName}'),
            Text('Price: ₹${yantra.yantraPrice}'),
            Text('Date Added: ${yantra.date}'),
          ],
        ),
      ),
    );
  }
}

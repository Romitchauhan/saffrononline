import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:saffrononline/utils/app_color.dart';
import 'package:saffrononline/view/winner_yantra_page.dart';
import '../controllers/balance_controller.dart';
import '../controllers/game_controller.dart';
import '../controllers/home_controller.dart';
import '../services/game_service.dart';
import '../utils/screen_utils.dart';
import 'history_screen.dart';

class HomePage extends StatefulWidget {
  final HomeController homeController = Get.put(HomeController());

  final BalanceController balanceController = Get.put(BalanceController());


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  final GetStorage _storage = GetStorage(); // GetStorage instance
  bool _isLoading = true;
  String _errorMessage = '';
  List<dynamic> _lastFiveDraws = [];


  @override
  void initState() {
    super.initState();
    widget.homeController.fetchBalance(); // Fetch balance when the home screen is initialized
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _fetchLastFiveDraws();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }
  Future<void> _fetchLastFiveDraws() async {
    try {
      final response = await http.get(Uri.parse('https://saffrononline.bhavenaayurveda.com/api/winner-yantra.php'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          final draws = data['data'] as List<dynamic>;
          setState(() {
            _lastFiveDraws = draws.take(5).toList();
            _isLoading = false; // Set loading to false after fetching data
          });
        } else {
          setState(() {
            _errorMessage = data['message'] ?? 'No data found';
            _isLoading = false; // Set loading to false in case of an error
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch data';
          _isLoading = false; // Set loading to false in case of a failed response
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false; // Set loading to false in case of an exception
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }



  void togglePoint(int index, int point) {
    final homeController = widget.homeController;
    homeController.selectedPoint.value = point;
    if (homeController.selectedImageIndex.value == index) {
      if (homeController.rotationAngle.value == 1.0) {
        // Stop rotation if the same point is clicked
        homeController.rotationAngle.value = 0.0;
        _animationController.stop();
      } else {
        // Start rotation with the new point
        homeController.rotationAngle.value = 1.0;
        _animationController.repeat();
      }
    } else {
      homeController.selectedImageIndex.value = index;
      homeController.rotationAngle.value = 1.0;
      _animationController.repeat();
    }
  }

  void selectYantra(int index) {
    final homeController = widget.homeController;
    final selectedPoint = homeController.selectedPoint.value;

    // If the yantra is already selected, add the new point value
    if (homeController.selectedYantraPoints[index] > 0) {
      homeController.selectedYantraPoints[index] += selectedPoint;
    } else {
      // Otherwise, just set the point value
      homeController.selectedYantraPoints[index] = selectedPoint;
    }
  }

  void clearSelections() {
    final homeController = widget.homeController;
    homeController.clearSelections();
    _animationController.stop();
  }

  Future<void> refreshScreen() async {
    clearSelections();
    await widget.homeController.fetchAllDraw();
    setState(() {}); // Refresh the UI
  }

  void confirmSelection() async {
    final homeController = widget.homeController;

    // Prepare the data to send to the API
    String? userId = _storage.read('user_id');
    String? username = _storage.read('username');  // Assuming username is stored
    if (userId == null || userId.isEmpty || username == null) {
      Get.snackbar('Error', 'User ID or Username is missing. Please log in again.');
      return;
    }

    List<Map<String, dynamic>> selectedYantras = homeController.selectedYantraPoints
        .asMap()
        .entries
        .map((entry) => {
      "yantra_id": entry.key + 1, // Assuming yantra IDs are 1-based
      "yantra_count": entry.value, // Number of points selected for this yantra
      "yantra_price": entry.value * 10, // Example calculation for yantra price
    })
        .where((yantra) => yantra['yantra_count']! > 0) // Only include yantras with selected points
        .toList();

    if (selectedYantras.isEmpty) {
      Get.snackbar('Error', 'Please select at least one yantra with points.');
      return;
    }

    Map<String, dynamic> requestData = {
      "user_id": int.parse(userId),
      "username": username,
      "yantra_data": selectedYantras,
    };

    print("Request Data: $requestData"); // Debugging print

    try {
      final response = await http.post(
        Uri.parse('https://saffrononline.bhavenaayurveda.com/api/purchase-yantra.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Response Data: $responseData");

        if (responseData['status'] == 1) {
          // Success message
          Get.snackbar('Success', responseData['message'] ?? 'Yantras purchased successfully!', snackPosition: SnackPosition.BOTTOM);

          // Refresh screen
          refreshScreen();
        } else {
          // Error message from server
          Get.snackbar('Error', responseData['message'] ?? 'Failed to purchase yantras', snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        // Error handling for failed API call
        Get.snackbar('Error', 'Failed to purchase yantras. Please try again.', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM);
    }

    // Stop rotation animation
    _animationController.stop();
    homeController.rotationAngle.value = 0.0;
    homeController.selectedImageIndex.value = -1; // Deselect the currently selected point
  }



  Future<String?> loadFirstName() async {
    final username = _storage.read('first_name');
    print("Loaded first name: $username");
    return username != null ? username : 'Guest';
  }
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final BalanceController balanceController = widget.balanceController; // Use this to access balanceController
    ScreenUtils.init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),color: Colors.white,
          onPressed: () {
            _storage.erase();
            Get.offAllNamed('/login'); // Replace with your actual login route
          },
        ),
        title: Text('Saffron Online', style: TextStyle(color: Colors.white ),),
        backgroundColor: AppColors.main,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: List.generate(controller.pointValues.length, (index) {
                final point = controller.pointValues[index];
                return Obx(() =>
                    GestureDetector(
                      onTap: () {
                        togglePoint(index, point);
                      },
                      child: RotationTransition(
                        turns: widget.homeController.selectedImageIndex.value == index
                            ? _rotationAnimation
                            : AlwaysStoppedAnimation(0.0),
                        child: Container(
                          width: ScreenUtils.getWidth(25),
                          height: ScreenUtils.getWidth(25),
                          child: Image.asset(
                            'assets/images/${point}.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ));
              }),
            ),
          ),
          ElevatedButton(
            onPressed: (){confirmSelection();
            _animationController.stop();
              // Refresh the screen

            },
            child: Text('Submit'), // Changed from OK to Submit
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FutureBuilder<String?>(
                      future: loadFirstName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          final username = snapshot.data ?? 'Guest';
                          return Text(
                            'Welcome, $username',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: ScreenUtils.getHeight(15)),
                    // Yantras grid view
                    FutureBuilder<List<Yantra>>(
                      future: ApiService1().fetchAllYantras(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          final yantras = snapshot.data!;
                          return GridView.builder(
                            shrinkWrap: true, // Ensure it fits inside the scrollable view
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: yantras.length,
                            itemBuilder: (context, index) {
                              final yantra = yantras[index];
                              return GestureDetector(
                                onTap: () => selectYantra(index),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Image.network(
                                      yantra.yantraImage.startsWith('http')
                                          ? yantra.yantraImage
                                          : '${widget.homeController.baseUrl}${yantra.yantraImage}',
                                      height: ScreenUtils.getHeight(55),
                                      width: ScreenUtils.getWidth(100),
                                    ),
                                    Center(
                                      child: Text(
                                        yantra.yantraName,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: ScreenUtils.getHeight(20),
                                        width: ScreenUtils.getWidth(80),
                                        color: Colors.black54,
                                        child: Center(
                                          child: Obx(() {
                                            final points = (index < widget.homeController.selectedYantraPoints.length)
                                                ? widget.homeController.selectedYantraPoints[index]
                                                : 0;
                                            return Text(
                                              '$points',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ScreenUtils.getFontSize(15),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    // Additional buttons and controls
                    SizedBox(height: ScreenUtils.getHeight(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: clearSelections,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Dark blue
                          ),
                          child: Text('Clear'),
                        ),
                        SizedBox(width: ScreenUtils.getWidth(10)),
                        ElevatedButton(
                          onPressed:(){
                            Get.to(() => WinnerYantraPage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Dark blue
                          ),
                          child: Text('All Draw'),
                        ),
                        SizedBox(width: ScreenUtils.getWidth(10)),

                      ],
                    ),
                    SizedBox(height: ScreenUtils.getHeight(20)),

                    Center(
                      child: Text(
                        'Last 5 Draws:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: ScreenUtils.getHeight(20)),

                    // Content
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _errorMessage.isNotEmpty
                        ? Center(child: Text(_errorMessage))
                        : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _lastFiveDraws.isEmpty
                            ? [Center(child: Text('No draws available'))]
                            : _lastFiveDraws.map((draw) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: ScreenUtils.getWidth(35),
                                  height: ScreenUtils.getWidth(35),
                                  child: draw['image_url'] != null
                                      ? Image.network(
                                    draw['image_url'],
                                    fit: BoxFit.cover,
                                  )
                                      : Icon(Icons.image_not_supported, size: 40), // Fallback icon
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Round: ${draw['random_number'] ?? 'N/A'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Winner: ${draw['yantra_name'] ?? 'N/A'}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: ScreenUtils.getHeight(20)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Obx(() {
                return Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.blueGrey[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // User Balance
                      Obx(() {
                        if (balanceController.isLoading.value) {
                          return Center(child: CircularProgressIndicator()); // Show loading spinner
                        } else {
                          return Text(
                            'Balance: ${balanceController.balance.value}', // Display balance
                            style: TextStyle(fontSize: 24),
                          );
                        }
                      }),
                      SizedBox(height: 10),

                      // User Points
                      Text(
                        'Points: ${controller.selectedPoint.value}', // Update with actual points if available
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),

                      // Current Date
                      Text(
                        'Date: ${controller.currentDate.value}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),

                      // Remaining Time
                      Text(
                        'Remaining Time: ${controller.remainingTime.value}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),

                      // Current Time
                      Text(
                        'Current Time: ${controller.currentTime.value}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),

                      // Display last five draws
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => HistoryScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Dark blue
                        ),
                        child: Text('Show History'),
                      ),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}


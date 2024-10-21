import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saffrononline/view/super_admin_screen/yantra_managmnt.dart';

class SuperAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Super Admin'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.fullscreen),
            onPressed: () {
              // Toggle fullscreen
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Logout functionality
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // Ensure proper padding
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent, // Adjust color as per your theme
              ),
              child: Text(
                'Super Admin Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            // Dashboard Button
            ListTile(
              title: Text('Dashboard'),
              leading: Icon(Icons.dashboard),
              onTap: () {
                // Navigate to Dashboard
                Get.toNamed('/super_admin');
              },
            ),
            // Agent Management Button
            ListTile(
              title: Text('Agent Management'),
              leading: Icon(Icons.group),
              onTap: () {
                // Navigate to Agent Management
                Get.toNamed('/agentManagement');
              },
            ),
            // Client Management Button
            ListTile(
              title: Text('Client Management'),
              leading: Icon(Icons.person),
              onTap: () {
                // Navigate to Client Management
                Get.toNamed('/clientManagement');
              },
            ),
            // Yantra Management Button
            ListTile(
              title: Text('Yantra Management'),
              leading: Icon(Icons.widgets),
              onTap: () {
                Get.to(YantraListScreen());
              },
            ),
            // Jackpot Winner Button
            ListTile(
              title: Text('Jackpot Winner'),
              leading: Icon(Icons.emoji_events),
              onTap: () {
                // Navigate to Jackpot Winner
                Get.toNamed('/jackpotWinner');
              },
            ),
            // Yantra Winner List Button
            ListTile(
              title: Text('Yantra Winner List'),
              leading: Icon(Icons.list),
              onTap: () {
                // Navigate to Yantra Winner List
                Get.to(YantraListScreen());
              },
            ),
            // Reports Button
            ListTile(
              title: Text('Reports'),
              leading: Icon(Icons.insert_chart),
              onTap: () {
                // Navigate to Reports
                Get.toNamed('/reports');
              },
            ),
            // Purchase History Button
            ListTile(
              title: Text('Purchase History'),
              leading: Icon(Icons.history),
              onTap: () {
                // Navigate to Purchase History
                Get.toNamed('/purchaseHistory');
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Home / Dashboard'),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Stop timer functionality
                    },
                    child: Text('Stop Timer'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Start timer functionality
                    },
                    child: Text('Start Timer'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Win type selection
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Win Type'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('Auto Win'),
                                onTap: () {
                                  // Select Auto Win
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                title: Text('Manual Win'),
                                onTap: () {
                                  // Select Manual Win
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text('Win Type'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Start auto timer functionality
                    },
                    child: Text('Start Auto Timer'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2,
                children: [
                  buildAdminButton('Agent Management', () {
                    // Navigate to Agent Management
                  }),
                  buildAdminButton('Client Management', () {
                    // Navigate to Client Management
                  }),

                  buildAdminButton('Yantra Management', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  YantraListScreen()),
                    );
                    // Navigate to Yantra Management
                   // Get.toNamed('/yantraManagement');
                  }),
                  buildAdminButton('Jackpot Winner', () {
                    // Navigate to Jackpot Winner
                  }),
                  buildAdminButton('Yantra Winner List', () {
                    // Navigate to Yantra Winner List
                  }),
                  buildAdminButton('Reports', () {
                    // Navigate to Reports
                  }),
                  buildAdminButton('Win Price', () {
                    // Navigate to Win Price
                  }),
                  buildAdminButton('Recharge Agent', () {
                    // Navigate to Recharge Agent
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAdminButton(String title, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 24),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:saffrononline/utils/app_color.dart';
import 'package:saffrononline/view/purchase_history_screen.dart';
import 'package:saffrononline/view/agent_screen/update_agent_screen.dart';
import 'package:saffrononline/view/client_screen/update_client_screen.dart';
import 'package:saffrononline/view/agent_screen/withdraw_agent_screen.dart';
import 'package:saffrononline/view/client_screen/withdraw_client_points_screen.dart';
import '../../controllers/agent_details_controller.dart';
import '../client_screen/client_list_screen.dart';
import '../client_screen/client_recharge_screen.dart';
import '../client_screen/delete_client_screen.dart';
import '../client_screen/get_client_screen.dart';
import 'add_agent_screen.dart';
import 'add_client_screen.dart';
import 'agent_details_screen.dart';
import 'agent_recharge_screen.dart';
import 'agent_screen.dart';
import 'delete_agent.dart';

class AgentPage extends StatefulWidget {
  final AgentDetailsController controller = Get.put(AgentDetailsController());

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  final GetStorage _storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    // Fetch agent name and balance from storage
    String agentName = _storage.read('first_name') ?? 'Agent';
    String agentId = _storage.read('user_id') ?? 'RC';
    String balance = _storage.read('balance') ?? '0.00';

    return Scaffold(
      appBar: AppBar(
        title: Text('$agentName Agent'),
        backgroundColor: AppColors.ag,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: Image.asset(
                "assets/icon/agent_logo.png",
                width: 30,
                height: 30,
              ),
              onPressed: () {},
            ),
          ), // Agent icon on the right
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Agent ID and balance
            Text(
              'Agent ID: $agentId (Balance: ₹$balance)',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            // Button list
            Expanded(
              child: ListView(
                children: [
                  _buildButton('Agents List', () {
                    print("Navigating to Agents List");
                    Get.to(() => AgentScreen());  // Navigate to AgentScreen here
                  }),
                  _buildButton('Add New Agent', () {
                    print("Navigating to Add New Agent");
                    Get.to(() => AddAgentScreen());  // Navigate to AddAgentScreen here
                  }),
                  _buildButton('Agent Details', () {  // New button for Agent Details
                    print("Navigating to Agent Details");
                    Get.to(() => AgentDetailsScreen());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Update Agent', () {  // New button for Agent Details
                    print("Navigating to Update Agent");
                    Get.to(() => UpdateAgentScreen());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Delete Agent', () {  // New button for Agent Details
                    print("Navigating to Delete Agent");
                    Get.to(() => DeleteAgentScreen());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Agent Recharge', () {  // New button for Agent Details
                    print("Navigating to Agent Recharge");
                    Get.to(() => AgentRechargeScreen());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Withdraw Agent', () {  // New button for Agent Details
                    print("Navigating to Withdraw Agent");
                    Get.to(() => WithdrawAgentPage());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Client List', () {  // New button for Agent Details
                    print("Navigating to Client List");
                    Get.to(() => ClientListPage());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Add Client', () {  // New button for Agent Details
                    print("Navigating to Add Client");
                    Get.to(() => AddClientPage());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Get Client', () {  // New button for Agent Details
                    print("Navigating to Get Client");
                    Get.to(() => GetClientPage());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Update Client', () {  // New button for Agent Details
                    print("Navigating to Update Client");
                    Get.to(() => UpdateClientPage());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Delete Client', () {  // New button for Agent Details
                    print("Navigating to Delete Client");
                    Get.to(() => DeleteClientPage());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Client Recharge', () {  // New button for Agent Details
                    print("Navigating to Client Recharge");
                    Get.to(() => ClientRechargePage());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Withdraw Client Points', () {  // New button for Agent Details
                    print("Navigating to Withdraw Client Points");
                    Get.to(() => WithdrawClientPointsPage());  // Navigate to AgentDetailScreen
                  }),
                  _buildButton('Purchase History', () {  // New button for Agent Details
                    print("Navigating to Purchase History");
                    Get.to(() => PurchaseHistoryScreen());  // Navigate to AgentDetailScreen
                  }),
                  // _buildButton('Transaction History', () {
                  //   print("Navigating to Transaction History");
                  //   Get.toNamed('/transaction-history');
                  // }),
                  // _buildButton('Transaction Report', () {
                  //   print("Navigating to Transaction Report");
                  //   Get.toNamed('/transaction-report');
                  // }),
                  // _buildButton('Agent Transaction Report', () {
                  //   Get.toNamed('/agent-transaction-report');
                  // }),
                  // _buildButton('Client Transaction History', () {
                  //   Get.toNamed('/client-transaction-history');
                  // }),
                  // _buildButton('Request Balance Transfer', () {
                  //   Get.toNamed('/agent-balance-transfer');
                  // }),
                  // // _buildButton('Agent Hisab', () {
                  // //   Get.toNamed('/agent-hisab');
                  // // }),
                  // // _buildButton('Client', () {
                  // //   Get.toNamed('/client');
                  // // }),
                  // _buildButton('Balance Transfer Client', () {
                  //   Get.toNamed('/balance-transfer-client');
                  // }),
                  // _buildButton('Game Agent', () {
                  //   Get.toNamed('/game-agent');
                  // }),
                  // _buildButton('Hisab Kitab', () {
                  //   Get.toNamed('/hisab-kitab');
                  // }),
                  // _buildButton('Profile', () {
                  //   Get.toNamed('/profile');
                  // }),
                  // _buildButton('Settings', () {
                  //   Get.toNamed('/settings');
                  // }),
                  // _buildButton('Notifications', () {
                  //   Get.toNamed('/notifications');
                  // }),
                  _buildButton('Logout', () {
                    Get.offAllNamed('/login');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(title, style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

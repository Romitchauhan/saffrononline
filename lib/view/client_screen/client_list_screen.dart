import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../models/client_model.dart';
import '../../utils/app_color.dart';

class ClientListPage extends StatefulWidget {
  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  final ClientController controller = Get.put(ClientController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Clients',style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.main,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.clientList.isEmpty) {
          return Center(child: Text('No clients found'));
        } else {
          return ListView.builder(
            itemCount: controller.clientList.length,
            itemBuilder: (context, index) {
              final client = controller.clientList[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('${client.firstname} (${client.username})'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mobile: ${client.mobileno}'),
                      Text('Email: ${client.email}'),
                      Text('Role: ${client.role}'),
                      Text('Created At: ${client.createdAt}'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}

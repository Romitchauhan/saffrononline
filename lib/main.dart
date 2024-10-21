import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:saffrononline/utils/screen_utils.dart';
import 'package:saffrononline/view/agent_screen/agent_homescreen.dart';
import 'package:saffrononline/view/agent_screen/agent_recharge_screen.dart';
import 'package:saffrononline/view/agent_screen/agent_screen.dart';

import 'package:saffrononline/view/client_screen/balance_transfer_client_page.dart';
import 'package:saffrononline/view/home_screen.dart';
import 'package:saffrononline/view/login_screen.dart';
import 'package:saffrononline/view/history_screen.dart';
import 'package:saffrononline/view/splash_screen.dart';
import 'package:saffrononline/view/super_admin_screen/super_admin_page.dart';
import 'package:saffrononline/view/super_admin_screen/yantra_managmnt.dart';
import 'package:saffrononline/view/transaction_history.dart';
import 'package:saffrononline/view/transaction_report.dart';
import 'bindings/auth_binding.dart';

void main() async {
  await GetStorage.init();
  // Initialize your values here if necessary
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, widget) {
        ScreenUtils.init(context);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Saffrononline',
      initialBinding: AuthBinding(),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/history', page: () => HistoryScreen()),
        GetPage(name: '/transaction-history', page: () => TransactionHistoryPage()),
        GetPage(name: '/transaction-report', page: () => TransactionReportPage()),
        GetPage(name: '/balance-transfer-client', page: () => BalanceTransferClientPage()),
        GetPage(name: '/agent-balance-transfer', page: () => AgentRechargeScreen()),
        GetPage(name: '/agent', page: () => AgentPage()),
        GetPage(name: '/super_admin', page: () => SuperAdminPage()),
        GetPage(name: '/agentscreen', page: () => AgentScreen()),
      //  GetPage(name: '/yantraManagement', page: () => YantraListScreen()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/splash', page: () => SplashScreen()),
      ],
    );
  }
}

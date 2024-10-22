import 'package:dolirest/infrastructure/dal/services/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/storage/storage.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/home/components/home_screen_tile.dart';
import 'package:dolirest/presentation/widgets/dialog_action_button.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: DoubleBack(
        message: 'Press back again to exit',
        child: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Image(
          image: AssetImage('assets/images/smbi.png'),
          height: 4,
        ),
      ),
      title: const Text("Dashboard"),
      centerTitle: true,
      actions: [
        Obx(() => _getStatusIcon(controller.refreshing.value)),
        _buildPopupMenu()
      ],
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton(
      itemBuilder: (context) => [
        // _buildPopupMenuItem(
        //     onTap: () => _logout(), value: '/settings', text: 'Logout'),
        _buildPopupMenuItem(
          onTap: () => _showAboutDialog(context),
          value: '/about',
          text: "About",
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem({
    required VoidCallback onTap,
    required String value,
    required String text,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      value: value,
      child: Text(text),
    );
  }

  void _showAboutDialog(BuildContext context) {
    Get.dialog(
      barrierDismissible: false,
      const AboutDialog(
        applicationVersion: '0.1.6-beta',
        applicationName: 'DoliREST',
        applicationLegalese: "© Copyright SMBI 2024",
        applicationIcon: _AppIcon(),
        children: [Text('A Restful API client for Dolibarr CRM.')],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildUserInfo(),
        _buildInvoices(),
        _buildCashflow(),
        _buildTiles(),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Center(
      child: Column(
        children: [
          _buildDatabaseTile(),
        ],
      ),
    );
  }

  Widget _buildTiles() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 300,
        child: GridView.count(
          childAspectRatio: 2,
          primary: false,
          reverse: false,
          crossAxisCount: 2,
          children: List.generate(6, (index) => _buildTile(index)),
        ),
      ),
    );
  }

  Obx _buildDatabaseTile() {
    return Obx(() => ListTile(
          title: Text(
            'DATABASE: ${Utils.subString(controller.baseUrl.value).toUpperCase()}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          trailing: Text(
            'USER: ${controller.currentUser.value.toUpperCase()}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ));
  }

  Widget _buildTile(int index) {
    switch (index) {
      case 0:
        return HomeScreenTile(
          onTap: () {
            Get.toNamed(Routes.CUSTOMERLIST);
          },
          title: 'Customers',
          icon: Icons.people_alt_outlined,
        );
      case 1:
        return HomeScreenTile(
          onTap: () {
            Get.toNamed(Routes.INVOICELIST);
          },
          title: 'Invoices',
          icon: Icons.list_alt,
        );
      case 2:
        return HomeScreenTile(
          onTap: () {
            if (Get.find<NetworkController>().connected.value) {
              Get.toNamed(Routes.EDITCUSTOMER, arguments: {'customerId': ''});
            } else {
              SnackbarHelper.networkSnackbar();
            }
          },
          title: 'New Customer',
          icon: Icons.person_add_alt_outlined,
        );
      case 3:
        return HomeScreenTile(
          onTap: () {
            if (Get.find<NetworkController>().connected.value) {
              Get.toNamed(Routes.PAYMENT,
                  arguments: {'fromhome': true, 'invid': '', 'socid': ''});
            } else {
              SnackbarHelper.networkSnackbar();
            }
          },
          title: 'Record Payment',
          icon: Icons.currency_exchange,
        );
      case 4:
        return HomeScreenTile(
          onTap: () {
            if (Get.find<NetworkController>().connected.value) {
              Get.toNamed(Routes.CREATEINVOICE, arguments: {'fromhome': true});
            } else {
              SnackbarHelper.networkSnackbar();
            }
          },
          title: 'New Invoice',
          icon: Icons.inventory_sharp,
        );

      case 5:
        return HomeScreenTile(
          onTap: () {
            if (Get.find<NetworkController>().connected.value) {
              Get.toNamed(Routes.REPORTS);
            }
          },
          title: 'Reports',
          icon: Icons.receipt_long_outlined,
        );
      default:
        // A default tile for indexes not explicitly handled
        return HomeScreenTile(
          onTap: () {},
          title: 'Placeholder',
          icon: Icons.help_outline,
        );
    }
  }
}

_logout() async {
  Get.defaultDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      title: 'Logout',
      middleText:
          'Logging out will clear all locally stored data. You will need to enter your login details again. Would you like to continue?',
      barrierDismissible: false,
      confirm: DialogActionButton(
          onPressed: () {
            Get.back();
            Get.find<StorageController>().clearAll();
            Get.offAllNamed(Routes.SETTINGS);
          },
          buttonText: 'Yes'),
      cancel: DialogActionButton(
        buttonColor: Colors.red,
        buttonText: 'No',
        onPressed: () => Get.back(),
      ));
}

_buildCashflow() {
  return Align(
    alignment: Alignment.center,
    child: ValueListenableBuilder(
        valueListenable: Get.find<StorageController>().paymentsListenable(),
        builder: (context, box, widget) {
          var list = box.values.toList();

          //Day Cashflow
          var dayCashflow = list
              .where((p) =>
                  Utils.datePaid(p.date!) == Utils.datePaid(DateTime.now()))
              .toList();
          List<int> dayAmounts = dayCashflow
              .map((payment) => Utils.intAmounts(payment.amount))
              .toList();
          int dayTotal =
              dayAmounts.isEmpty ? 0 : dayAmounts.reduce((a, b) => a + b);
          return Card(
            child: ListTile(
              leading: const Icon(Icons.money_outlined),
              title: Text("Collected today: R$dayTotal"),
              subtitle: Text("${dayCashflow.length} invoices"),
              onTap: () => Get.toNamed(Routes.CASHFLOW),
            ),
          );
        }),
  );
}

_buildInvoices() {
  return ValueListenableBuilder(
    valueListenable: Get.find<StorageController>().invoicesListenable(),
    builder: (context, box, widget) {
      int openInvoices = box.values.where((i) => i.remaintopay != 0).length;
      int overDues = box.values
          .where((i) =>
              Utils.intToDateTime(i.dateLimReglement).isBefore(DateTime.now()))
          .length;
      int sales = box.values
          .where((i) =>
              Utils.dateMonth(Utils.intToDateTime(i.date)) ==
              Utils.dateMonth(DateTime.now()))
          .length;
      return Column(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_outlined),
              title: Text("Open Invoices: $openInvoices. (Overdue: $overDues)"),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_outlined),
              title: Text("Items Sold This Month: $sales"),
            ),
          ),
        ],
      );
    },
  );
}

class _AppIcon extends StatelessWidget {
  const _AppIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage('assets/images/smbi.png'),
        ),
      ),
    );
  }
}

Widget _makeIcon(String text, IconData icon, Color color) {
  return Tooltip(
      message: text,
      child: SizedBox(
          width: 40,
          height: null,
          child: Icon(
            icon,
            size: 24,
            color: color,
          )));
}

Widget _getStatusIcon(bool refreshing) {
  if (refreshing) {
    return const SpinKitDualRing(
      color: Colors.blueAccent,
      size: 10,
    );
  }
  if (!Get.find<NetworkController>().connected.value) {
    return _makeIcon('No connection', Icons.cloud_off_outlined, Colors.red);
  } else {
    return _makeIcon('Connected', Icons.cloud_done_outlined, Colors.lightGreen);
  }
}

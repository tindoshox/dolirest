import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/home/components/home_screen_tile.dart';

import 'controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: const DoubleBack(
        message: 'Press back again to exit',
        child: Column(
          children: [Text('Due Today')],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    final statusIcon = _getStatusIcon(controller.connected.value);
    return AppBar(
      title: const Text("Dashboard"),
      centerTitle: true,
      actions: [statusIcon, _buildPopupMenu()],
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton(
      itemBuilder: (context) => [
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

  Widget _buildDrawer() {
    return NavigationDrawer(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 12, 46, 196),
            image: DecorationImage(
              image: AssetImage('assets/images/smbi.png'),
              fit: BoxFit.contain,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 8.0,
                left: 4.0,
                child: Text(
                  "DoliREST",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children:
              List.generate(7, (index) => _buildTile(index), growable: true),
        )
      ],
    );
  }

  Widget _buildTile(int index) {
    switch (index) {
      case 0:
        return HomeScreenTile(
          onTap: () {
            Get.toNamed(Routes.HOME);
          },
          title: 'Dashboard',
          icon: Icons.dashboard_outlined,
        );
      case 1:
        return HomeScreenTile(
          onTap: () {
            Get.toNamed(Routes.CUSTOMERLIST);
          },
          title: 'Customers',
          icon: Icons.people_alt_outlined,
        );
      case 2:
        return HomeScreenTile(
          onTap: () {
            Get.toNamed(Routes.INVOICELIST);
          },
          title: 'Invoices',
          icon: Icons.list_alt,
        );
      case 3:
        return HomeScreenTile(
          onTap: () {
            Get.toNamed(Routes.EDITCUSTOMER, arguments: {'customerId': ''});
          },
          title: 'New Customer',
          icon: Icons.person_add_alt_outlined,
        );
      case 4:
        return HomeScreenTile(
          onTap: () {
            Get.toNamed(Routes.PAYMENT,
                arguments: {'fromhome': true, 'invid': '', 'socid': ''});
          },
          title: 'Record Payment',
          icon: Icons.currency_exchange,
        );
      case 5:
        return HomeScreenTile(
          onTap: () {
            Get.toNamed(Routes.CREATEINVOICE, arguments: {'fromhome': true});
          },
          title: 'New Invoice',
          icon: Icons.inventory_sharp,
        );

      case 6:
        return HomeScreenTile(
          onTap: () {
            Get.toNamed(Routes.REPORTS);
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

Widget _makeIcon(String text, IconData icon) {
  return Tooltip(
      message: text,
      child: SizedBox(width: 40, height: null, child: Icon(icon, size: 24)));
}

Widget _getStatusIcon(bool status) {
  if (!status) {
    return _makeIcon('No connection', Icons.cloud_off);
  } else {
    return _makeIcon('Connected', Icons.cloud_queue);
  }
}

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/home/components/home_screen_tile.dart';
import 'package:dolirest/utils/utils.dart';

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
      title: const Text("Dashboard"),
      centerTitle: true,
      actions: [_buildPopupMenu()],
    );
  }

  Widget _buildPopupMenu() {
    return PopupMenuButton(
      itemBuilder: (context) => [
        _buildPopupMenuItem(
          onTap: () => controller.logout(),
          value: '/settings',
          text: "Settings",
        ),
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
    return Stack(
      children: [
        _buildUserInfo(),
        _buildTiles(),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Center(
      child: Column(
        children: [
          _buildDatabaseTile(),
          _buildNetworkStatusTile(),
          const SizedBox(height: 110),
          const Image(image: AssetImage('assets/images/smbi.png')),
        ],
      ),
    );
  }

  Obx _buildDatabaseTile() {
    return Obx(() => ListTile(
          title: Text(
            'DATABASE: ${Utils.subString(controller.baseUrl.value).toUpperCase()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'USER: ${controller.currentUser.value.toUpperCase()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
  }

  Obx _buildNetworkStatusTile() {
    return Obx(() => ListTile(
          title: Text(
            controller.connected.value ? '' : 'Network Disconnected',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          subtitle: Text(
            controller.connected.value ? '' : 'Data capture is disabled',
            style: const TextStyle(color: Colors.amber),
          ),
        ));
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

  Widget _buildTile(int index) {
    // Assuming a method to generate tiles based on index
    // This is a placeholder for the actual implementation
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
            if (controller.connected.value) {
              Get.toNamed(Routes.EDITCUSTOMER, arguments: {'customerId': ''});
            }
          },
          title: 'New Customer',
          icon: Icons.person_add_alt_outlined,
        );
      case 3:
        return HomeScreenTile(
          onTap: () {
            if (controller.connected.value) {
              Get.toNamed(Routes.PAYMENT,
                  arguments: {'fromhome': true, 'invid': '', 'socid': ''});
            }
          },
          title: 'Record Payment',
          icon: Icons.currency_exchange,
        );
      case 4:
        return HomeScreenTile(
          onTap: () {
            if (controller.connected.value) {
              Get.toNamed(Routes.CREATEINVOICE, arguments: {'fromhome': true});
            }
          },
          title: 'New Invoice',
          icon: Icons.inventory_sharp,
        );

      case 5:
        return HomeScreenTile(
          onTap: () {
            if (controller.connected.value) {
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

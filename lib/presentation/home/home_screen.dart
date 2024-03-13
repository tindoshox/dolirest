// ignore_for_file: use_super_parameters

import 'package:dolirest/infrastructure/dal/services/get_storage.dart';
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
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: const [],
      //
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () => Get.toNamed(Routes.SETTINGS),
                  value: '/settings',
                  child: const Text("Settings"),
                ),
                PopupMenuItem(
                  onTap: () => Get.dialog(
                      barrierDismissible: false,
                      AboutDialog(
                        applicationVersion: '0.1.0-beta',
                        applicationName: 'DoliREST',
                        applicationLegalese: "© Copyright SMBI 2024",
                        applicationIcon: Container(
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
                        ),
                        children: const [
                          Text('A Restful API client for Dolibarr CRM.')
                        ],
                      )),
                  value: '/about',
                  child: const Text("About"),
                ),
              ];
            },
          ),
        ],
      ),
      body: DoubleBack(
        message: 'Press back again to exit',
        child: Stack(children: [
          SizedBox(
            child: Center(
              child: Column(
                children: [
                  ListTile(
                    title: Obx(() => Text(
                          controller.baseUrl.value.isEmpty
                              ? ''
                              : 'DATABASE: ${subString(controller.baseUrl.value).toUpperCase()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                    subtitle: Obx(() => Text(
                        controller.isLoading.value
                            ? ''
                            : 'USER: ${controller.currentUser.value.lastname ?? controller.currentUser.value.login}',
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  const SizedBox(
                    height: 110,
                  ),
                  const Image(
                    image: AssetImage('assets/images/smbi.png'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 300,
              child: GridView.count(
                childAspectRatio: 2,
                primary: false,
                reverse: false,
                crossAxisCount: 2,
                children: [
                  HomeScreenTile(
                      onTap: () {
                        Get.toNamed(Routes.CUSTOMERLIST);
                      },
                      title: 'Customers',
                      icon: Icons.people_alt_outlined),
                  HomeScreenTile(
                      onTap: () {
                        Get.toNamed(
                          Routes.INVOICELIST,
                        );
                      },
                      title: 'Invoices',
                      icon: Icons.list_alt),
                  HomeScreenTile(
                      onTap: () {
                        bool connected = getBox.read('connected');
                        if (connected) {
                          Get.toNamed(Routes.EDITCUSTOMER,
                              arguments: {'customerId': ''});
                        }
                      },
                      title: 'New Customer',
                      icon: Icons.person_add_alt_outlined),
                  HomeScreenTile(
                      onTap: () {
                        bool connected = getBox.read('connected');
                        if (connected) {
                          Get.toNamed(Routes.PAYMENT, arguments: {
                            'fromhome': true,
                            'invid': '',
                            'socid': ''
                          });
                        }
                      },
                      title: 'Record Payment',
                      icon: Icons.currency_exchange),
                  HomeScreenTile(
                      onTap: () {
                        bool connected = getBox.read('connected');
                        if (connected) {
                          Get.toNamed(Routes.CREATEINVOICE,
                              arguments: {'fromhome': true});
                        }
                      },
                      title: 'New Invoice',
                      icon: Icons.inventory_sharp),
                  HomeScreenTile(
                      onTap: () {
                        bool connected = getBox.read('connected');
                        if (connected) {
                          Get.toNamed(Routes.REPORTS);
                        }
                      },
                      title: 'Reports',
                      icon: Icons.receipt_long_outlined),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

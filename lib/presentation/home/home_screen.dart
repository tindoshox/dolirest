import 'package:change_case/change_case.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/widgets/status_icon.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(controller),
      body: DoubleBack(
        message: 'Press back again to exit',
        child: SingleChildScrollView(
          child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUserInfo(context),
                  _buildMainShortCuts(),
                  _buildSecondaryShortCuts(),
                  if (controller.noInvoiceCustomers.value > 0)
                    _buildNoInvoiceCustomer(context),
                  _buildInvoices(context),
                  if (controller.cashflow.value > 0) _buildCashflow(context),
                ],
              )),
        ),
      ),
    );
  }

  Widget _appIcon(BuildContext context) {
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

  PopupMenuItem<String> _buildPopupMenuItem({
    required VoidCallback onTap,
    required String value,
    required Widget child,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      value: value,
      child: child,
    );
  }

  PopupMenuButton<String> _setThemeMode(HomeController controller) {
    return PopupMenuButton(
      onSelected: (value) => Get.back(),
      child: ListTile(
        title: Text('Theme'),
        leading: Icon(Icons.format_paint),
      ),
      itemBuilder: (BuildContext context) => [
        _buildPopupMenuItem(
          onTap: () {
            Get.changeThemeMode(ThemeMode.light);
            controller.saveThemeSetting('light');
          },
          value: '#',
          child: ListTile(
            title: Text('Light'),
            leading: Icon(Icons.light_mode),
          ),
        ),
        _buildPopupMenuItem(
          onTap: () {
            Get.changeThemeMode(ThemeMode.dark);
            controller.saveThemeSetting('dark');
          },
          value: '#',
          child: ListTile(
            title: Text('Dark'),
            leading: Icon(Icons.dark_mode),
          ),
        ),
        _buildPopupMenuItem(
          onTap: () {
            Get.changeThemeMode(ThemeMode.system);
            controller.saveThemeSetting('system');
          },
          value: '#',
          child: ListTile(
            title: Text('Auto'),
            leading: Icon(Icons.brightness_auto),
          ),
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    final packageInfo = controller.packageInfo;
    Get.dialog(
      barrierDismissible: false,
      AboutDialog(
        applicationVersion: packageInfo.version,
        applicationName: packageInfo.packageName,
        applicationLegalese: "© Copyright SMBI 2024",
        applicationIcon: _appIcon(context),
        children: [Text('A Restful API client for Dolibarr CRM.')],
      ),
    );
  }

  Widget _buildPopupMenu(HomeController controller) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        _buildPopupMenuItem(
          onTap: () {},
          value: '#',
          child: _setThemeMode(controller),
        ),
        _buildPopupMenuItem(
          onTap: () => _showAboutDialog(context),
          value: '/about',
          child: ListTile(
            title: Text("About"),
            leading: Icon(Icons.info),
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar(HomeController controller) {
    return AppBar(
      leading: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Image(
          image: AssetImage('assets/images/smbi.png'),
          height: 4,
        ),
      ),
      title: Obx(() => Text(
            controller.company.value.isNotEmpty
                ? controller.company.value.toTitleCase()
                : "Dashboard",
          )),
      centerTitle: true,
      actions: [
        Obx(() => getStatusIcon(
            connected: controller.connected.value,
            refreshing: controller.refreshing.value,
            onPressed: controller.connected.value
                ? () => controller.forceRefresh()
                : () => controller.refreshConnection())),
        _buildPopupMenu(controller)
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Obx(() {
      var userName = controller.user.value.firstname != null
          ? '${controller.user.value.firstname!} ${controller.user.value.lastname!}'
              .toTitleCase()
          : controller.user.value.login?.toTitleCase();
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              ListTile(
                leading: Initicon(
                  text: userName ?? '',
                  size: 30,
                ),
                title: Text(
                  "Welcome $userName",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget shortcutItem({
    void Function()? onTap,
    Color color = Colors.transparent,
    required Widget icon,
    required String line1,
    String? line2,
    TextStyle? style,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: color,
                child: icon,
              ),
            ),
            Text(
              line1,
              style: style,
            ),
            if (line2 != null)
              Text(
                line2,
                style: style,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainShortCuts() {
    return SizedBox(
      height: 150,
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            shortcutItem(
                onTap: () {
                  if (controller.connected.value) {
                    Get.toNamed(Routes.EDITCUSTOMER, arguments: {});
                  } else {
                    SnackBarHelper.networkSnackbar();
                  }
                },
                icon: Icon(
                  Icons.person_add,
                  color: Colors.green[700],
                ),
                line1: 'New',
                line2: 'Customer',
                color: const Color.fromARGB(255, 228, 253, 199)),
            shortcutItem(
                onTap: () {
                  if (controller.connected.value) {
                    Get.toNamed(Routes.CREATEINVOICE, arguments: {});
                  } else {
                    SnackBarHelper.networkSnackbar();
                  }
                },
                icon: Icon(
                  Icons.inventory_sharp,
                  color: Colors.blue[700],
                ),
                line1: 'New',
                line2: 'Invoice',
                color: const Color.fromARGB(255, 127, 197, 255)),
            shortcutItem(
                onTap: () {
                  if (controller.connected.value) {
                    Get.toNamed(Routes.PAYMENT, arguments: {'batch': true});
                  } else {
                    SnackBarHelper.networkSnackbar();
                  }
                },
                icon: Icon(
                  Icons.payment,
                  color: Colors.orange,
                ),
                line1: 'New',
                line2: 'Payment',
                color: const Color.fromARGB(255, 255, 221, 192)),
          ],
        ),
      ),
    );
  }

  SizedBox _buildSecondaryShortCuts() {
    return SizedBox(
      height: 150,
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            shortcutItem(
                onTap: () => Get.toNamed(Routes.CUSTOMERLIST, arguments: {
                      'noInvoiceCustomers': false,
                    }),
                icon: Icon(
                  Icons.people_alt,
                  color: Colors.purple[700],
                ),
                line1: 'List of',
                line2: 'Customers',
                color: const Color.fromARGB(255, 244, 182, 255)),
            shortcutItem(
                onTap: () =>
                    Get.toNamed(Routes.INVOICELIST, arguments: {'drafts': 0}),
                icon: Icon(
                  Icons.list_outlined,
                  color: Colors.brown[700],
                ),
                line1: 'List of',
                line2: 'Invoices',
                color: const Color.fromARGB(255, 241, 205, 192)),
            shortcutItem(
                onTap: () {
                  if (controller.connected.value &&
                      controller.enabledModules.contains('reports')) {
                    Get.toNamed(Routes.REPORTS);
                  }
                },
                icon: Icon(
                  Icons.receipt_long_outlined,
                  color: Colors.blueGrey,
                ),
                line1: 'Generate',
                line2: 'Reports',
                color: const Color.fromARGB(255, 212, 212, 212)),
          ],
        ),
      ),
    );
  }

  Column _buildInvoices(BuildContext context) {
    return Column(
      children: [
        if (controller.draftInvoices.value > 0)
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_outlined),
              title: Text(
                "Draft Invoices: ${controller.draftInvoices.value}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: controller.draftInvoices.value == 0
                  ? null
                  : Text('Tap to View',
                      style: Theme.of(context).textTheme.bodySmall),
              onTap: () => controller.draftInvoices.value == 0
                  ? null
                  : Get.toNamed(Routes.INVOICELIST, arguments: {
                      'drafts': controller.draftInvoices.value,
                    }),
            ),
          ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.inventory_outlined),
            title: Text(
              "Open Invoices: ${controller.openInvoices.value}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Overdue: ${controller.overDueInvoices.value}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  "Items Sold This Month: ${controller.salesInvoices.value}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        if (controller.dueTodayInvoices.value > 0)
          Card(
            child: ListTile(
              onTap: () => Get.toNamed(Routes.DUETODAY),
              leading: const Icon(Icons.inventory_outlined),
              title: Text(
                "Invoices Due Today: ${controller.dueTodayInvoices.value}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Text(
                'Tap to View',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
      ],
    );
  }

  Card _buildNoInvoiceCustomer(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person_outline),
        title: Text(
          "Customers Without Invoices: ${controller.noInvoiceCustomers}",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: controller.noInvoiceCustomers.value == 0
            ? null
            : Text('Tap to View', style: Theme.of(context).textTheme.bodySmall),
        onTap: () => controller.noInvoiceCustomers.value == 0
            ? null
            : Get.toNamed(Routes.CUSTOMERLIST, arguments: {
                'noInvoiceCustomers': true,
              }),
      ),
    );
  }

  Card _buildCashflow(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.money_outlined),
        title: Text(
          "Collected today: R${controller.cashflow}",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(
          'Tap to View',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: () => Get.toNamed(Routes.CASHFLOW),
      ),
    );
  }
}

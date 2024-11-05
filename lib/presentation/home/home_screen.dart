import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/widgets/dialog_action_button.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
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
      title: Obx(() => Text(
            controller.company.value.name?.capitalize ?? "Dashboard",
          )),
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
        _buildPopupMenuItem(
          onTap: () {},
          value: '#',
          child: _setThemeMode(),
        ),
        _buildPopupMenuItem(
          onTap: () => _logout(),
          value: '/login',
          child: ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.logout),
          ),
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

  _setThemeMode() {
    return PopupMenuButton(
      child: ListTile(
        title: Text('Theme'),
        leading: Icon(Icons.format_paint),
      ),
      itemBuilder: (BuildContext context) => [
        _buildPopupMenuItem(
          onTap: () {
            Get.changeThemeMode(ThemeMode.light);
            controller.storage.storeSetting(StorageKey.theme, 'light');
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
            controller.storage.storeSetting(StorageKey.theme, 'dark');
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
            controller.storage.storeSetting(StorageKey.theme, 'system');
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

  void _showAboutDialog(BuildContext context) {
    Get.dialog(
      barrierDismissible: false,
      const AboutDialog(
        applicationVersion: '0.1.7',
        applicationName: 'DoliREST',
        applicationLegalese: "© Copyright SMBI 2024",
        applicationIcon: _AppIcon(),
        children: [Text('A Restful API client for Dolibarr CRM.')],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildUserInfo(),
          SizedBox(height: 10),
          _buildMainShortCuts(),
          SizedBox(height: 10),
          _buildSecondaryShortCuts(),
          SizedBox(height: 10),
          _buildInvoices(),
          SizedBox(height: 10),
          _buildCashflow(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Obx(() {
      var userName = controller.user.value.firstname != null
          ? '${controller.user.value.firstname?.capitalizeFirst} ${controller.user.value.lastname!.capitalizeFirst}'
          : controller.user.value.login?.capitalizeFirst;
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              ListTile(
                leading: Initicon(text: userName ?? ''),
                title: Text(
                  "Welcome $userName",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  _buildSecondaryShortCuts() {
    return SizedBox(
      height: 150,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _shortcutItem(
                onTap: () => Get.toNamed(Routes.CUSTOMERLIST),
                icon: Icon(
                  Icons.people_alt,
                  color: Colors.purple[700],
                ),
                line1: 'List of',
                line2: 'Customers',
                color: const Color.fromARGB(255, 244, 182, 255)),
            _shortcutItem(
                onTap: () => Get.toNamed(Routes.INVOICELIST),
                icon: Icon(
                  Icons.list_outlined,
                  color: Colors.brown[700],
                ),
                line1: 'List of',
                line2: 'Invoices',
                color: const Color.fromARGB(255, 241, 205, 192)),
            _shortcutItem(
                onTap: () {
                  if (Get.find<NetworkController>().connected.value) {
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

  Widget _buildMainShortCuts() {
    return SizedBox(
      height: 150,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _shortcutItem(
                onTap: () {
                  if (Get.find<NetworkController>().connected.value) {
                    Get.toNamed(Routes.EDITCUSTOMER,
                        arguments: {'customerId': ''});
                  } else {
                    SnackbarHelper.networkSnackbar();
                  }
                },
                icon: Icon(
                  Icons.person_add,
                  color: Colors.green[700],
                ),
                line1: 'New',
                line2: 'Customer',
                color: const Color.fromARGB(255, 228, 253, 199)),
            _shortcutItem(
                onTap: () {
                  if (Get.find<NetworkController>().connected.value) {
                    Get.toNamed(Routes.CREATEINVOICE,
                        arguments: {'fromhome': true});
                  } else {
                    SnackbarHelper.networkSnackbar();
                  }
                },
                icon: Icon(
                  Icons.inventory_sharp,
                  color: Colors.blue[700],
                ),
                line1: 'New',
                line2: 'Invoice',
                color: const Color.fromARGB(255, 127, 197, 255)),
            _shortcutItem(
                onTap: () {
                  if (Get.find<NetworkController>().connected.value) {
                    Get.toNamed(Routes.PAYMENT, arguments: {
                      'fromhome': true,
                      'invid': '',
                      'socid': ''
                    });
                  } else {
                    SnackbarHelper.networkSnackbar();
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

  Widget _shortcutItem({
    void Function()? onTap,
    Color color = Colors.transparent,
    required Widget icon,
    required String line1,
    String? line2,
    TextStyle? style = const TextStyle(fontSize: 11),
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: Column(
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
        )
      ],
    );
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
              Get.find<StorageService>().clearAll();
              Get.offAllNamed(Routes.LOGIN);
            },
            buttonText: 'Yes'),
        cancel: DialogActionButton(
            buttonColor: Colors.red,
            buttonText: 'No',
            onPressed: () => Get.back()));
  }

  _buildCashflow() {
    return Align(
      alignment: Alignment.center,
      child: ValueListenableBuilder(
          valueListenable: Get.find<StorageService>().paymentsListenable(),
          builder: (context, box, widget) {
            var list = box.values.toList();

            //Day Cashflow
            var dayCashflow = list
                .where((p) =>
                    DateUtils.dateOnly(p.date!) ==
                    DateUtils.dateOnly(DateTime.now()))
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
                subtitle: Text('Tap to View'),
                onTap: () => Get.toNamed(Routes.CASHFLOW),
              ),
            );
          }),
    );
  }

  _buildInvoices() {
    return ValueListenableBuilder(
      valueListenable: controller.storage.invoicesListenable(),
      builder: (context, box, widget) {
        var openInvoices =
            box.values.where((element) => element.remaintopay != "0").length;

        int overDues = box.values
            .where((i) => Utils.intToDateTime(i.dateLimReglement)
                .isBefore(DateTime.now().subtract(Duration(days: 31))))
            .length;
        List<InvoiceModel> dueToday = box.values
            .where((i) =>
                Utils.intToDateTime(i.dateLimReglement).day ==
                DateTime.now().day)
            .toList();
        dueToday.removeWhere((d) => DateUtils.isSameMonth(
            Utils.intToDateTime(d.dateLimReglement),
            DateTime.now().add(Duration(days: 30))));

        int sales = box.values
            .where((i) => DateUtils.isSameMonth(
                Utils.intToDateTime(i.date), DateTime.now()))
            .length;

        return Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory_outlined),
                title: Text("Open Invoices: $openInvoices"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Overdue: $overDues"),
                    Text("Items Sold This Month: $sales"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                onTap: () => Get.toNamed(Routes.DUETODAY,
                    arguments: {'dueToday': dueToday}),
                leading: const Icon(Icons.inventory_outlined),
                title: Text("Invoices Due Today: ${dueToday.length}"),
                subtitle: Text('Tap to View'),
              ),
            ),
          ],
        );
      },
    );
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
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: const SpinKitThreeInOut(
          color: Colors.blueAccent,
          size: 10,
        ),
      );
    }
    if (!Get.find<NetworkController>().connected.value) {
      return _makeIcon('No connection', Icons.cloud_off_outlined, Colors.red);
    } else {
      return _makeIcon(
          'Connected', Icons.cloud_done_outlined, Colors.lightGreen);
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

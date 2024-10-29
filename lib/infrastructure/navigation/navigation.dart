import 'package:dolirest/infrastructure/navigation/bindings/controllers/createinvoice_controller_binding.dart';
import 'package:dolirest/infrastructure/navigation/bindings/controllers/customerdetail_controller_binding.dart';
import 'package:dolirest/infrastructure/navigation/bindings/controllers/customerlist_controller_binding.dart';
import 'package:dolirest/infrastructure/navigation/bindings/controllers/duetoday.controller.binding.dart';
import 'package:dolirest/infrastructure/navigation/bindings/controllers/editcustomer_controller_binding.dart';
import 'package:dolirest/infrastructure/navigation/bindings/controllers/home_controller_binding.dart';
import 'package:dolirest/infrastructure/navigation/bindings/controllers/invoicedetail_controller_binding.dart';
import 'package:dolirest/infrastructure/navigation/bindings/controllers/invoicelist_controller_binding.dart';
import 'package:dolirest/infrastructure/navigation/bindings/controllers/login.controller.binding.dart';
import 'package:dolirest/infrastructure/navigation/bindings/controllers/payment_controller_binding.dart';
import 'package:dolirest/presentation/createinvoice/create_invoice_screen.dart';
import 'package:dolirest/presentation/customerdetail/customer_detail_screen.dart';
import 'package:dolirest/presentation/customerlist/customer_list_screen.dart';
import 'package:dolirest/presentation/duetoday/duetoday.screen.dart';
import 'package:dolirest/presentation/editcustomer/edit_customer_screen.dart';
import 'package:dolirest/presentation/home/home_screen.dart';
import 'package:dolirest/presentation/invoicedetail/invoice_detail_screen.dart';
import 'package:dolirest/presentation/invoicelist/invoicelist_screen.dart';
import 'package:dolirest/presentation/login/login.screen.dart';
import 'package:dolirest/presentation/payment/payment_screen.dart';
import 'package:dolirest/presentation/reports/reports_screen.dart';
import 'package:get/get.dart';

import '../../presentation/cashflow/collections_screen.dart';
import 'bindings/controllers/cashflow.controller.binding.dart';
import 'bindings/controllers/reports.controller.binding.dart';
import 'routes.dart';

//import 'package:flutter/material.dart';

// ignore_for_file: use_key_in_widget_constructors

const transition = Transition.rightToLeft;
const transitionDuration = Duration(milliseconds: 300);

class Nav {
  static List<GetPage> routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeControllerBinding(),
      transition: transition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.CUSTOMERLIST,
      page: () => const CustomerListScreen(),
      binding: CustomerlistControllerBinding(),
      transition: transition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.INVOICELIST,
      page: () => const InvoicelistScreen(),
      binding: InvoicelistControllerBinding(),
      transition: transition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.CUSTOMERDETAIL,
      page: () => const CustomerDetailScreen(),
      binding: CustomerdetailControllerBinding(),
      transition: transition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.INVOICEDETAIL,
      page: () => const InvoiceDetailScreen(),
      binding: InvoicedetailControllerBinding(),
      transition: transition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.EDITCUSTOMER,
      page: () => const EditCustomerScreen(),
      binding: EditCustomerControllerBinding(),
      transition: transition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => const PaymentScreen(),
      binding: PaymentControllerBinding(),
      transition: transition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.CREATEINVOICE,
      page: () => const CreateinvoiceScreen(),
      binding: CreateinvoiceControllerBinding(),
      transition: transition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.REPORTS,
      page: () => const ReportsScreen(),
      binding: ReportsControllerBinding(),
      transition: transition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginControllerBinding(),
      transition: transition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.CASHFLOW,
      page: () => const CashflowScreen(),
      binding: CashflowControllerBinding(),
      transition: transition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.DUETODAY,
      page: () => const DueTodayScreen(),
      binding: DuetodayControllerBinding(),
    ),
  ];
}

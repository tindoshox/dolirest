import 'dart:convert';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dolirest/infrastructure/dal/models/build_report_request_mode.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/reportid_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:open_filex/open_filex.dart';

class ReportsController extends GetxController {
  GlobalKey<FormState> reportFormKey = GlobalKey<FormState>();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  RxList<GroupModel> groups = List<GroupModel>.empty().obs;

  late bool permissionReady;
  late TargetPlatform? platform;

  /// A list of available reports.
  List<ReportIdModel> reportList = [
    ReportIdModel(
        reportid: 'balances', displayName: 'Balances', hasGroupParameter: true),
    ReportIdModel(
        reportid: 'receipts_mobile',
        displayName: 'Receipts',
        hasFromDateParameter: true,
        hasToDateParameter: true),
    ReportIdModel(
      reportid: 'receipts',
      displayName: 'Receipts (A4)',
      hasFromDateParameter: true,
      hasToDateParameter: true,
    ),
    ReportIdModel(
      reportid: 'Monthly_Collection_Totals',
      displayName: 'Monthly Totals',
      hasFromDateParameter: true,
      hasToDateParameter: true,
    ),
    ReportIdModel(
        reportid: 'Overdue',
        displayName: 'Overdue',
        hasFromDateParameter: true,
        hasToDateParameter: true,
        hasGroupParameter: true),
    ReportIdModel(
        reportid: 'Sales_Invoices',
        displayName: 'Sales',
        hasFromDateParameter: true,
        hasToDateParameter: true),
  ];

  Rx<DateTime> fromdate = DateTime.now().obs;
  Rx<DateTime> todate = DateTime.now().obs;
  Rx<GroupModel> selectedGroup = GroupModel().obs;
  Rx<ReportIdModel> selectedReport = ReportIdModel().obs;
  RxString salesperson = ''.obs;

  /// Initializes the controller.
  @override
  void onInit() async {
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    List<GroupModel> list = Storage.groups.toMap().values.toList();

    if (list.length < 50) {
      await refreshGroups();
    } else {
      groups.value = list;
    }
    fromDateController.text = Utils.dateTimeToString(DateTime.now());
    toDateController.text = Utils.dateTimeToString(DateTime.now());
    super.onInit();
  }

  Future getGroups({String search = ""}) async {
    if (search.isNotEmpty) {
      groups.value = Storage.groups
          .toMap()
          .values
          .toList()
          .where((group) => group.name.contains(search))
          .toList();
    } else {
      groups.value = Storage.groups.toMap().values.toList();
    }
    return groups;
  }

  Future<List<GroupModel>> refreshGroups() async {
    await RemoteServices.fetchGroups().then((value) async {
      if (!value.hasError) {
        for (GroupModel group in value.data) {
          Storage.groups.put(group.id, group);
        }
      }
    });

    return groups;
  }

  /// Validates the form.
  void validate() async {
    final FormState form = reportFormKey.currentState!;
    if (form.validate()) {
      var requestModel = BuildReportRequestModel(
        reportid: selectedReport.value.reportid,
        groupid: selectedReport.value.hasGroupParameter
            ? selectedGroup.value.id
            : '',
        salesperson:
            selectedReport.value.hasSalesParameter ? salesperson.value : '',
        fromdate: selectedReport.value.hasFromDateParameter
            ? DateFormat('yyyy-MM-dd').format(fromdate.value)
            : '',
        todate: selectedReport.value.hasToDateParameter
            ? DateFormat('yyyy-MM-dd').format(todate.value)
            : '',
      ).toMap();

      requestModel.removeWhere((key, value) => value == null || value == '');

      await _generateReport(jsonEncode(requestModel));
    }
  }

  /// Generates the report if the form is valid.
  Future _generateReport(String body) async {
    permissionReady = await Utils.checkPermission(platform);
    if (permissionReady) {
      DialogHelper.showLoading(
          'Fetching ${selectedReport.value.displayName} report...');

      /// Checks permissions
      if (permissionReady) {
        await RemoteServices.buildReport(body).then((value) async {
          if (value.hasError) {
            DialogHelper.hideLoading();
            SnackBarHelper.errorSnackbar(message: value.errorMessage);
          } else {
            //Creates file in storage
            Utils.createFileFromString(
                    value.data.content, '${selectedReport.value.reportid}.pdf')
                .then((value) {
              DialogHelper.hideLoading();

              /// Opens file in default viewer
              OpenFilex.open(value);
            });
          }
        });
      }
    } else {
      DialogHelper.hideLoading();
      Get.snackbar('Permission Error', 'Download Failed');
    }
  }

  /// Sets the initial from date.
  void setFromDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: fromdate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      fromdate.value = selectedDate;
      fromDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    }
  }

  /// Sets the initial to date.
  void setToDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: fromdate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      todate.value = selectedDate;
      todate.value = selectedDate;
      toDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    }
  }
}

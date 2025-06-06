import 'dart:convert';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/build_report_request_model.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/models/reportid_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/document_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/group_repository.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

class ReportsController extends GetxController {
  final StorageService storage = Get.find();
  final GroupRepository groupRepository = Get.find();
  GlobalKey<FormState> reportFormKey = GlobalKey<FormState>();
  TextEditingController endDateController = TextEditingController();
  TextEditingController toEndController = TextEditingController();
  TextEditingController startReceiptController = TextEditingController();
  TextEditingController endReceiptController = TextEditingController();
  RxList<GroupModel> groups = List<GroupModel>.empty().obs;
  final DocumentRepository repository = Get.find();

  late bool permissionReady;
  late TargetPlatform? platform;

  var startPeriod = ''.obs;
  var endPeriod = ''.obs;

  /// A list of available reports.
  List<ReportIdModel> reportList = [
    ReportIdModel(
        reportid: 'balances',
        displayName: 'Balances',
        hasGroupParam: true,
        groupIsRequired: true),
    ReportIdModel(
        reportid: 'receipts_mobile',
        displayName: 'Receipts',
        hasStartDateParam: true,
        hasEndDateParam: true),
    ReportIdModel(
      reportid: 'receipts',
      displayName: 'Receipts (A4)',
      hasStartDateParam: true,
      hasEndDateParam: true,
    ),
    ReportIdModel(
      reportid: 'daily_totals',
      displayName: 'Daily Totals',
      hasStartPeriodParam: true,
    ),
    ReportIdModel(
      reportid: 'monthly_totals',
      displayName: 'Monthly Totals',
      hasStartPeriodParam: true,
      hasEndPeriodParam: true,
    ),
    ReportIdModel(
      reportid: 'percentage',
      displayName: 'Performance',
      hasStartPeriodParam: true,
    ),
    ReportIdModel(
      reportid: 'overdue',
      displayName: 'Overdue',
      hasStartDateParam: true,
      hasEndDateParam: true,
      hasGroupParam: true,
    ),
    ReportIdModel(
        reportid: 'sales',
        displayName: 'Sales',
        hasStartDateParam: true,
        hasEndDateParam: true,
        hasGroupParam: true),
    ReportIdModel(
      reportid: 'returns',
      displayName: 'Returns',
      hasStartDateParam: true,
      hasEndDateParam: true,
      hasGroupParam: true,
    ),
    ReportIdModel(
        reportid: 'receiptbook',
        displayName: 'Receipt Book',
        hasStartReceiptParam: true,
        hasEndReceiptParam: true),
    ReportIdModel(
      reportid: 'stock',
      displayName: 'Stock',
      hasWarehouseParam: true,
    ),
  ];

  Rx<DateTime> startdate = DateTime.now().obs;
  Rx<DateTime> enddate = DateTime.now().obs;
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

    List<GroupModel> list = storage.getGroupList();

    if (list.length < 50) {
      await refreshGroups();
    } else {
      groups.value = list;
    }
    endDateController.text = Utils.dateTimeToString(DateTime.now());
    toEndController.text = Utils.dateTimeToString(DateTime.now());
    super.onInit();
  }

  Future getGroups({String search = ""}) async {
    if (search.isNotEmpty) {
      groups.value = storage
          .getGroupList()
          .where((group) => group.name.contains(search))
          .toList();
    } else {
      groups.value = storage.getGroupList();
    }
    return groups;
  }

  Future<List<GroupModel>> refreshGroups() async {
    final result = await groupRepository.fetchGroups();
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (groups) {
      for (GroupModel group in groups) {
        storage.storeGroup(group.id, group);
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
        groupid:
            selectedReport.value.hasGroupParam ? selectedGroup.value.id : '',
        salesperson:
            selectedReport.value.hasSalesParam ? salesperson.value : '',
        startdate: selectedReport.value.hasStartDateParam
            ? DateFormat('yyyy-MM-dd').format(startdate.value)
            : '',
        enddate: selectedReport.value.hasEndDateParam
            ? DateFormat('yyyy-MM-dd').format(enddate.value)
            : '',
        startreceipt: selectedReport.value.hasStartReceiptParam
            ? startReceiptController.text.trim()
            : '',
        endreceipt: selectedReport.value.hasEndReceiptParam
            ? endReceiptController.text.trim()
            : '',
        startperiod: startPeriod.value,
        endperiod: endPeriod.value,
      ).toJson();

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

      final result = await repository.buildReport(body);
      result.fold((failure) {
        DialogHelper.hideLoading();
        SnackBarHelper.errorSnackbar(message: failure.message);
      }, (report) {
        //Creates file in storage
        Utils.createFileFromString(
                report.content, selectedReport.value.reportid)
            .then((value) {
          DialogHelper.hideLoading();

          /// Opens file in default viewer
          OpenFilex.open(value);
        });
      });
    } else {
      DialogHelper.hideLoading();
      Get.snackbar('Permission Error', 'Download Failed');
    }
  }

  /// Sets the initial from date.
  void setStartDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: startdate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      startdate.value = selectedDate;
      endDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    }
  }

  /// Sets the initial to date.
  void setEndDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: startdate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      enddate.value = selectedDate;
      enddate.value = selectedDate;
      toEndController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
    }
  }

  void clearGroup() {
    selectedGroup(GroupModel());
  }
}

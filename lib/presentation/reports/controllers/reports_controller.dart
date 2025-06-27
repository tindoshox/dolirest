import 'dart:convert';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/build_report_request_model.dart';
import 'package:dolirest/infrastructure/dal/models/group/group_entity.dart';
import 'package:dolirest/infrastructure/dal/models/reportid_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/document_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/group_repository.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

class ReportsController extends GetxController {
  final NetworkService _network = Get.find();
  final StorageService _storage = Get.find();

  final GroupRepository _groupRepository = Get.find();
  GlobalKey<FormState> reportFormKey = GlobalKey<FormState>();
  TextEditingController endDateController = TextEditingController();
  TextEditingController toEndController = TextEditingController();
  TextEditingController startReceiptController = TextEditingController();
  TextEditingController endReceiptController = TextEditingController();
  RxList<GroupEntity> groups = List<GroupEntity>.empty().obs;
  final DocumentRepository _repository = Get.find();

  late bool _permissionReady;
  late TargetPlatform? _platform;

  var startPeriod = ''.obs;
  var endPeriod = ''.obs;
  var connected = false.obs;

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
  Rx<GroupEntity> selectedGroup = GroupEntity().obs;
  Rx<ReportIdModel> selectedReport = ReportIdModel().obs;
  RxString salesperson = ''.obs;

  /// Initializes the controller.
  @override
  void onInit() async {
    ever(_network.connected, (_) {
      connected = _network.connected;
    });
    connected = _network.connected;
    if (Platform.isAndroid) {
      _platform = TargetPlatform.android;
    } else {
      _platform = TargetPlatform.iOS;
    }

    List<GroupEntity> list = _storage.getGroupList();

    if (list.length < 50) {
      await refreshGroups();
    } else {
      groups.value = list;
    }
    endDateController.text = Utils.dateTimeToDMY(DateTime.now());
    toEndController.text = Utils.dateTimeToDMY(DateTime.now());
    super.onInit();
  }

  Future getGroups({String search = ""}) async {
    if (search.isNotEmpty) {
      groups.value = _storage
          .getGroupList()
          .where((group) => group.name!.contains(search))
          .toList();
    } else {
      groups.value = _storage.getGroupList();
    }
    return groups;
  }

  Future<List<GroupEntity>> refreshGroups() async {
    final result = await _groupRepository.fetchGroups();
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (groups) {
      for (GroupEntity group in groups) {
        _storage.storeGroup(group);
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
        groupid: selectedReport.value.hasGroupParam
            ? selectedGroup.value.groupId
            : '',
        salesperson:
            selectedReport.value.hasSalesParam ? salesperson.value : '',
        startdate: selectedReport.value.hasStartDateParam
            ? Utils.dateTimeToYMD(startdate.value)
            : '',
        enddate: selectedReport.value.hasEndDateParam
            ? Utils.dateTimeToYMD(enddate.value)
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
    _permissionReady = await Utils.checkPermission(_platform);
    if (_permissionReady) {
      DialogHelper.showLoading(
          'Fetching ${selectedReport.value.displayName} report...');

      final result = await _repository.buildReport(body);
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
      endDateController.text = Utils.dateTimeToDMY(selectedDate);
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
      toEndController.text = Utils.dateTimeToDMY(selectedDate);
    }
  }

  void clearGroup() {
    selectedGroup(GroupEntity());
  }
}
